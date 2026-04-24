# Copilot Instructions for Biblivre-5

Biblivre is a multilingual, multi-tenant library management system (ILS) built as a Java Servlet web application deployed as a WAR on Apache Tomcat 7. It uses PostgreSQL 9.1 with schema-based multi-tenancy, JSP views with custom tag libraries, and a jQuery-based frontend.

## Build and Run

```bash
# Install local dependencies not available in public Maven repos (run from /lib/)
sh maven_deps.sh        # or run the mvn install:install-file commands individually

# Compile SCSS stylesheets
mvn sass:update-stylesheets

# Build the WAR
mvn package              # output: target/Biblivre4.war

# Database setup (requires PostgreSQL)
psql -U postgres -f sql/createdatabase.sql
psql -U postgres -f sql/biblivre4.sql -d biblivre4
```

The project targets Java 1.6 source/target. There is no automated test suite.

## Architecture

### Request Flow

All HTTP requests pass through a single **front controller** (`SchemaServlet` → `Controller`):

```
URL: /{schema}/{controller}?module={module}&action={action}

1. SchemaServlet parses schema + controller type from the URL path
2. ExtendedRequestResponseFilter wraps request/response with ExtendedRequest/ExtendedResponse
3. Controller dispatches to the appropriate controller type:
   - "json" → JsonController (AJAX/JSON responses)
   - "jsp"  → JspController (page rendering)
   - "download" / "media" → DownloadController
4. Controller loads Handler via reflection: Class.forName("biblivre." + module + ".Handler")
5. Validator (if exists) loaded similarly: Class.forName("biblivre." + module + ".Validator")
6. Controller invokes handler.{action}(request, response) via reflection
```

Key classes: `biblivre.core.controllers.SchemaServlet`, `Controller`, `JsonController`, `JspController`.

### Handler / BO / DAO Layering

Every module follows a strict three-tier pattern:

| Layer | Naming | Base Class | Role |
|-------|--------|------------|------|
| Handler | `biblivre.{module}.Handler` | `AbstractHandler` | Request parsing, response building |
| Business Object | `{Entity}BO` | `AbstractBO` | Business logic, orchestration |
| Data Access | `{Entity}DAO` | `AbstractDAO` | JDBC queries, connection management |

Supporting types: `{Entity}DTO` for data transfer, `Validator` for input validation, `DTOCollection` for paginated results.

Both BO and DAO use a **singleton-per-schema** pattern cached in static HashMaps. Obtain instances via:
```java
UserBO bo = UserBO.getInstance(schema);
UserDAO dao = UserDAO.getInstance(UserDAO.class, schema);
```

### Multi-Tenancy

Each library tenant is a **PostgreSQL schema** within the `biblivre4` database. The `public` schema holds global configuration.

- Schema is extracted from the first URL path segment (e.g., `/library1/json?module=...`)
- `AbstractDAO.getConnection()` automatically runs `SET search_path = '{schema}', public, pg_catalog`
- New schemas are created from `biblivre_template_4.0.0.sql` via the multi_schema module
- Reserved schema names: `public`, `schema`, `template`, `bib4template`, `DigitalMediaController`

### Database Access

All database access is raw JDBC through `AbstractDAO`:
- Connections obtained from JNDI DataSource (`java:comp/env/jdbc/biblivre4`)
- Every connection block must follow the try/finally pattern with `closeConnection()`:
  ```java
  Connection con = null;
  try {
      con = this.getConnection();
      PreparedStatement pst = con.prepareStatement(sql);
      // ...
  } catch (Exception e) {
      throw new DAOException(e);
  } finally {
      this.closeConnection(con);
  }
  ```
- Transactions: use `con.setAutoCommit(false)` then `commit(con)` / `rollback(con)` in finally
- Sequences: `getNextSerial(sequenceName)` for PostgreSQL serial IDs

### Frontend

- **JSP** pages in `WebContent/jsp/` with custom tag libraries (`layout.tld`, `translations.tld`)
- **i18n** via `<i18n:text key="..." />` tags; translations in `Traducoes - {locale}.txt` files (ptBR, enUS, es)
- **JavaScript**: jQuery + jQuery UI + Lodash, with module scripts named `biblivre.{module}.{feature}.js`
- **SCSS** stylesheets in `WebContent/static/styles/scss/`, compiled to CSS via `mvn sass:update-stylesheets`
- AJAX calls go to the `json` controller and return JSON via handler's `setJson()` method

### Spring

Spring Context is used **only** for Z39.50 client configuration (`applicationContext.xml` → `z3950Context.xml`). It does not manage handlers, BOs, or DAOs — those use custom singleton factories.

## Conventions

- **Module discovery is by convention**: handler class must be at `biblivre.{module}.Handler` and action methods must match the `action` query parameter name exactly
- **Error handling**: custom exceptions (`DAOException`, `AuthorizationException`, `ValidationException`) in `biblivre.core.exceptions`; handlers communicate results via `Message` with `ActionResult` enum (SUCCESS, WARNING, ERROR)
- **GPL v3 license headers** on all Java source files
- **Checkstyle**: "Biblivre Code Style" config referenced in `.checkstyle`
- **Encoding**: UTF-8 throughout (source, JSP, properties)
