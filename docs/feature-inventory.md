# Biblivre 5 — Feature Inventory for Migration Planning

> **Purpose:** This document catalogues every functional area of the Biblivre 5 library management system. Use it to select which features to include in the new Node.js + Supabase application.
>
> **How to use:** Review each feature area below. Mark features as **In Scope**, **Out of Scope**, or **Future Phase** for the migration.

---

## Feature Areas at a Glance

| # | Migrate | Feature Area | Menu Location | Description | User Roles |
|---|----------|-------------|---------------|-------------|------------|
| 1 | ☐ | [Bibliographic Search](#1-bibliographic-search) | Search → Bibliographic | Search the book catalogue | All users |
| 2 | ☐ | [Authority Search](#2-authority-search) | Search → Authorities | Search author/subject headings | All users |
| 3 | ☐ | [Vocabulary Search](#3-vocabulary-search) | Search → Vocabulary | Search controlled vocabulary/thesaurus | All users |
| 4 | ☐ | [Z39.50 Distributed Search](#4-z3950-distributed-search) | Search → Distributed | Search external library catalogues | All users |
| 5 | ☐ | [Bibliographic Cataloguing](#5-bibliographic-cataloguing) | Cataloguing → Bibliographic | Create and edit book records (MARC) | Librarians |
| 6 | ☐ | [Authority Cataloguing](#6-authority-cataloguing) | Cataloguing → Authorities | Manage author/subject authority records | Librarians |
| 7 | ☐ | [Vocabulary Cataloguing](#7-vocabulary-cataloguing) | Cataloguing → Vocabulary | Manage thesaurus/controlled terms | Librarians |
| 8 | ☐ | [Record Import](#8-record-import) | Cataloguing → Import | Import records from files or Z39.50 | Librarians |
| 9 | ☐ | [Label Printing](#9-label-printing) | Cataloguing → Labels | Print shelf labels for books | Librarians |
| 10 | ☐ | [Holdings Management](#10-holdings-management) | Within Bibliographic Cataloguing | Manage physical copies of a title | Librarians |
| 11 | ☐ | [Patron Management](#11-patron-management) | Circulation → Users | Register and manage library members | Staff |
| 12 | ☐ | [Lending & Returns](#12-lending--returns) | Circulation → Lending | Check out and return books | Staff |
| 13 | ☐ | [Reservations (Staff)](#13-reservations-staff) | Circulation → Reservations | Manage book reservations for patrons | Staff |
| 14 | ☐ | [Self-Service Reservations](#14-self-service-reservations) | Reservations (when logged in as reader) | Patrons reserve books themselves | Readers |
| 15 | ☐ | [Access Control](#15-access-control) | Circulation → Access Control | Track library entry/exit with access cards | Staff |
| 16 | ☐ | [User Card Printing](#16-user-card-printing) | Circulation → Print Cards | Print patron ID cards | Staff |
| 17 | ☐ | [Supplier Management](#17-supplier-management) | Acquisition → Suppliers | Manage book vendors/suppliers | Staff |
| 18 | ☐ | [Acquisition Requests](#18-acquisition-requests) | Acquisition → Requests | Track requests to purchase new materials | Staff |
| 19 | ☐ | [Quotations](#19-quotations) | Acquisition → Quotations | Manage price quotes from suppliers | Staff |
| 20 | ☐ | [Purchase Orders](#20-purchase-orders) | Acquisition → Orders | Create and track purchase orders | Staff |
| 21 | ☐ | [Logins & Permissions](#21-logins--permissions) | Administration → Logins & Permissions | Manage user accounts and access rights | Admins |
| 22 | ☐ | [User Types](#22-user-types) | Administration → User Types | Define patron categories and lending rules | Admins |
| 23 | ☐ | [System Configuration](#23-system-configuration) | Administration → Configurations | Library name, search settings, lending rules | Admins |
| 24 | ☐ | [Translations](#24-translations) | Administration → Translations | Customise UI text in multiple languages | Admins |
| 25 | ☐ | [Reports](#25-reports) | Administration → Reports | Generate library usage reports | Admins |
| 26 | ☐ | [Backup & Restore](#26-backup--restore) | Administration → Maintenance | Database backup and restore | Admins |
| 27 | ☐ | [Search Index Maintenance](#27-search-index-maintenance) | Administration → Maintenance | Rebuild search indexes | Admins |
| 28 | ☐ | [Z39.50 Server Configuration](#28-z3950-server-configuration) | Administration → Z39.50 Servers | Configure external catalogue sources | Admins |
| 29 | ☐ | [Access Card Management](#29-access-card-management) | Administration → Access Cards | Manage physical access cards | Admins |
| 30 | ☐ | [Form & Display Customisation](#30-form--display-customisation) | Administration → Customisation | Customise MARC fields and brief display | Admins |
| 31 | ☐ | [Digital Media](#31-digital-media) | Embedded in cataloguing | Upload/download file attachments to records | Librarians / All |
| 32 | ☐ | [Multi-Library (Multi-Schema)](#32-multi-library-multi-schema) | Multi-Library menu (global admin) | Manage multiple library instances | Global Admins |

---

## Detailed Feature Descriptions

### 1. Bibliographic Search
**Menu:** Search → Bibliographic  
**Available to:** Everyone (no login required)

Allows users to search the library's book catalogue. Supports:
- **Simple search** — keyword search across all fields or a specific field (title, author, subject, ISBN, etc.)
- **Advanced search** — combine multiple criteria with AND/OR operators, filter by material type (book, serial, audiovisual, etc.), date ranges
- **Browse/list** — alphabetical listing of all records sorted by title or author
- **Result display** — shows title, author, subject, shelf location, and availability (copies available vs. lent out)
- **Record detail view** — full MARC record with all cataloguing fields, linked holdings

**Database tables:** `biblio_records`, `biblio_idx_fields`, `biblio_idx_sort`, `biblio_search_results`, `biblio_searches`

---

### 2. Authority Search
**Menu:** Search → Authorities  
**Available to:** Everyone (no login required)

Search for authority records (standardised forms of author names, subject headings, and series titles). Used for catalogue consistency.
- Simple and advanced search modes
- Browse/list by alphabetical order
- View linked bibliographic records

**Database tables:** `authorities_records`, `authorities_idx_fields`, `authorities_idx_sort`

---

### 3. Vocabulary Search
**Menu:** Search → Vocabulary  
**Available to:** Everyone (no login required)

Search the controlled vocabulary/thesaurus for standardised terms used in subject classification.
- Simple and advanced search modes
- Browse/list alphabetically

**Database tables:** `vocabulary_records`, `vocabulary_idx_fields`, `vocabulary_idx_sort`

---

### 4. Z39.50 Distributed Search
**Menu:** Search → Distributed  
**Available to:** Everyone (no login required)

Search external library catalogues via the Z39.50 protocol. Allows librarians to find and import records from other libraries worldwide (e.g., Library of Congress, national libraries).

**Depends on:** Z39.50 server configuration (Feature #28)  
**Database tables:** `z3950_addresses`

---

### 5. Bibliographic Cataloguing
**Menu:** Cataloguing → Bibliographic  
**Available to:** Librarians / Staff with cataloguing permissions

Full MARC-based cataloguing for bibliographic records:
- **Create** new records using customisable MARC forms
- **Edit** existing records (all MARC fields and subfields)
- **Delete** records
- **Move** records between databases (main ↔ private/work)
- **Duplicate detection** — warns on ISBN/ISSN duplicates during import
- **Material types** — book, serial, audiovisual, computer file, map, score, photograph, manuscript, 3D object
- **Two databases** — main (public) and private (work-in-progress)

**Database tables:** `biblio_records`, `biblio_form_datafields`, `biblio_form_subfields`, `biblio_brief_formats`

---

### 6. Authority Cataloguing
**Menu:** Cataloguing → Authorities  
**Available to:** Librarians / Staff with cataloguing permissions

Create and manage authority records (name authority, subject authority, series authority). Ensures consistent use of author names and subject headings across the catalogue.

**Database tables:** `authorities_records`, `authorities_form_datafields`, `authorities_form_subfields`

---

### 7. Vocabulary Cataloguing
**Menu:** Cataloguing → Vocabulary  
**Available to:** Librarians / Staff with cataloguing permissions

Create and manage controlled vocabulary entries (thesaurus terms). Supports broader/narrower/related term relationships.

**Database tables:** `vocabulary_records`, `vocabulary_form_datafields`, `vocabulary_form_subfields`

---

### 8. Record Import
**Menu:** Cataloguing → Import  
**Available to:** Librarians / Staff with cataloguing permissions

Import cataloguing records from external sources:
- **File import** — upload MARC/ISO 2709 files
- **Z39.50 import** — search and import from remote catalogues
- **Duplicate checking** — validates ISBN/ISSN/ISRC against existing records
- **Batch processing** — import multiple records at once

---

### 9. Label Printing
**Menu:** Cataloguing → Labels  
**Available to:** Librarians / Staff with cataloguing permissions

Generate PDF shelf labels (spine labels) for physical book items. Includes call number, accession number, and other classification data.

---

### 10. Holdings Management
**Menu:** Within the Bibliographic Cataloguing screen (sub-panel)  
**Available to:** Librarians / Staff with cataloguing permissions

Manage physical copies (items/holdings) attached to a bibliographic record:
- **Add holdings** — register new physical copies with accession number, location, shelf location
- **Edit holdings** — update holding details
- **Track availability** — available, lent, reserved, in repair
- **Label printing status** — track whether a label has been printed

**Database tables:** `biblio_holdings`, `holding_form_datafields`, `holding_form_subfields`, `holding_creation_counter`

---

### 11. Patron Management
**Menu:** Circulation → Users  
**Available to:** Staff with circulation permissions

Register and manage library members (patrons):
- **Create/edit** patron profiles — name, address, contact details, photo
- **User types** — assign patron categories (student, professor, community, etc.) which control lending rules
- **Custom fields** — configurable additional fields (e.g., student ID, department)
- **Search** patrons by name or other criteria
- **Link to login** — associate a patron with a system login for self-service access
- **Status tracking** — active, inactive, blocked

**Database tables:** `users`, `users_types`, `users_fields`, `users_values`

---

### 12. Lending & Returns
**Menu:** Circulation → Lending  
**Available to:** Staff with circulation permissions

Core circulation workflow:
- **Check out (lend)** — scan/search a book and a patron, register the loan
- **Return** — process book returns, automatically calculate overdue fines
- **Renew** — extend a loan's due date
- **Fine management** — view, charge, and waive overdue fines
- **Receipt printing** — print lending/return receipts
- **Due date rules** — controlled by patron's user type (lending time, limits)
- **View active loans** — list all current checkouts for a patron

**Database tables:** `lendings`, `lending_fines`, `biblio_holdings` (availability), `users_types` (rules)

---

### 13. Reservations (Staff)
**Menu:** Circulation → Reservations  
**Available to:** Staff with circulation permissions

Staff-managed reservation system:
- **Search** bibliographic records and place reservations on behalf of patrons
- **View** all active reservations
- **Cancel** reservations
- **Expiration** — reservations automatically expire after a configurable period

**Database tables:** `reservations`

---

### 14. Self-Service Reservations
**Menu:** Reservations (appears when a reader/patron is logged in)  
**Available to:** Logged-in readers/patrons

Patron-facing reservation feature:
- **Search** the catalogue and place a hold on a book
- **View** own active reservations
- **Cancel** own reservations
- Requires the patron to have a system login (linked in Feature #11)

**Database tables:** `reservations`

---

### 15. Access Control
**Menu:** Circulation → Access Control  
**Available to:** Staff with circulation permissions

Track physical entry/exit to the library using access cards:
- **Bind** an access card to a patron (check-in)
- **Unbind** an access card (check-out / departure)
- **Search** card or patron to view current status
- **Log** arrival and departure times

**Database tables:** `access_control`, `access_cards`

---

### 16. User Card Printing
**Menu:** Circulation → Print Cards  
**Available to:** Staff with circulation permissions

Generate and print PDF patron ID cards with name and photo.

**Database tables:** `users`

---

### 17. Supplier Management
**Menu:** Acquisition → Suppliers  
**Available to:** Staff with acquisition permissions

Manage vendor/supplier directory:
- Create, edit, search, and delete supplier records
- Fields: company name, trade name, VAT number, address, phone numbers, contacts, website, email

**Database tables:** `suppliers`

---

### 18. Acquisition Requests
**Menu:** Acquisition → Requests  
**Available to:** Staff with acquisition permissions

Track requests to purchase new library materials:
- Create, edit, search, and delete requests
- Fields: requester name, author, title, subtitle, edition, publisher, quantity, status, notes

**Database tables:** `requests`

---

### 19. Quotations
**Menu:** Acquisition → Quotations  
**Available to:** Staff with acquisition permissions

Manage supplier price quotes for acquisition requests:
- Link requests to supplier quotations
- Track response dates, expiration, delivery time
- Compare unit prices and quantities across suppliers

**Database tables:** `quotations`, `request_quotation`

---

### 20. Purchase Orders
**Menu:** Acquisition → Orders  
**Available to:** Staff with acquisition permissions

Create and track purchase orders based on accepted quotations:
- Fields: invoice number, receipt date, total value, delivery quantities, payment terms, deadline
- Track order status

**Database tables:** `orders`

---

### 21. Logins & Permissions
**Menu:** Administration → Logins & Permissions  
**Available to:** Administrators

Manage system user accounts and role-based access control:
- Create/delete login accounts
- Assign granular permissions per module (cataloguing, circulation, acquisition, administration)
- Employee vs. reader access levels
- Password management

**Database tables:** `logins`, `permissions`

---

### 22. User Types
**Menu:** Administration → User Types  
**Available to:** Administrators

Define patron categories with different lending rules:
- Name and description
- **Lending limit** — max simultaneous loans
- **Lending time** — loan period in days
- **Reservation limit** — max simultaneous reservations
- **Reservation time** — reservation hold period
- **Fine value** — daily overdue fine amount

**Database tables:** `users_types`

---

### 23. System Configuration
**Menu:** Administration → Configurations  
**Available to:** Administrators

Library-wide settings:
- **Library identity** — name, subtitle, default language
- **Search settings** — results per page, result limits
- **Circulation settings** — lending receipt printer type
- **Z39.50 server** — enable/disable the built-in Z39.50 server
- **Multi-library mode** — enable/disable multiple library schemas

**Database tables:** `configurations`

---

### 24. Translations
**Menu:** Administration → Translations  
**Available to:** Administrators

Customise all user interface text:
- Supported languages: Portuguese (Brazil), English (US), Spanish
- Edit any UI label, message, or menu text
- Export/import translation files

**Database tables:** `translations`

---

### 25. Reports
**Menu:** Administration → Reports  
**Available to:** Administrators

Generate library usage and management reports. Report types typically include circulation statistics, collection summaries, and overdue items.

---

### 26. Backup & Restore
**Menu:** Administration → Maintenance  
**Available to:** Administrators

Database backup and restore functionality:
- Create full or partial database backups
- Download backup files
- Restore from backup files
- Progress tracking for long-running operations

**Database tables:** `backups`

*Note: Backup/restore uses PostgreSQL `pg_dump`/`psql` command-line tools. This feature may need to be rearchitected for Supabase (which doesn't allow direct `CREATE DATABASE` or shell-level access).*

---

### 27. Search Index Maintenance
**Menu:** Administration → Maintenance  
**Available to:** Administrators

Rebuild the search indexes used by the catalogue search:
- Reindex bibliographic records
- Reindex authority records
- Reindex vocabulary records
- Progress tracking during reindexing

*Note: In the current app, search relies on application-level index tables (`_idx_fields`, `_idx_sort`). A modern implementation could use PostgreSQL full-text search or Supabase's built-in search features instead.*

---

### 28. Z39.50 Server Configuration
**Menu:** Administration → Z39.50 Servers  
**Available to:** Administrators

Configure remote Z39.50 library catalogue servers for distributed searching and record import:
- Add/edit/delete server definitions (name, URL, port, collection)

**Database tables:** `z3950_addresses`

---

### 29. Access Card Management
**Menu:** Administration → Access Cards  
**Available to:** Administrators

Manage the inventory of physical access cards used for library entry/exit tracking:
- Create, search, and delete card records
- Track card status (available, in use, blocked, cancelled)

**Database tables:** `access_cards`

---

### 30. Form & Display Customisation
**Menu:** Administration → Brief Customisation / Form Customisation  
**Available to:** Administrators

Customise how records are displayed and edited:
- **Brief display** — configure which MARC fields appear in search result summaries
- **Form layout** — configure which MARC fields/subfields appear in the cataloguing editor, their order, whether they are repeatable or collapsible

**Database tables:** `biblio_brief_formats`, `biblio_form_datafields`, `biblio_form_subfields` (and corresponding authority/vocabulary tables)

---

### 31. Digital Media
**Menu:** Embedded within cataloguing (attachments on records)  
**Available to:** Upload requires staff permissions; download is public

Attach digital files to catalogue records:
- Upload images (book covers), PDFs, documents
- Download/view attachments from record detail view
- Files stored as PostgreSQL large objects (BLOBs)

**Database tables:** `digital_media`

*Note: For Supabase migration, file storage should use Supabase Storage (S3-compatible) instead of database BLOBs.*

---

### 32. Multi-Library (Multi-Schema)
**Menu:** Multi-Library menu (only visible to global administrators)  
**Available to:** Global Administrators only

Support multiple independent library instances within a single application:
- **Create** new library schemas
- **Manage** existing libraries (enable/disable)
- **Global configurations** — settings that apply across all libraries
- **Global translations** — shared translations across all libraries
- **Multi-library backup** — backup all schemas together

**Database tables:** `global.schemas`, `global.configurations`, `global.translations`

*Note: The current app uses PostgreSQL schemas for multi-tenancy. A modern approach might use Supabase Row Level Security (RLS) policies instead.*

---

## Migration Considerations

### Features that may need significant rearchitecting

| Feature | Current Implementation | Migration Consideration |
|---------|----------------------|------------------------|
| **MARC Record Storage** | Records stored as ISO 2709 binary blobs | Consider whether to keep MARC format or move to a more modern JSON-based schema |
| **Search Indexing** | Custom application-level index tables | Could use PostgreSQL full-text search, Supabase pg_trgm, or an external search service |
| **Z39.50** | Java-based Z39.50 client/server (jzkit library) | Z39.50 is legacy; consider SRU/SRW (HTTP-based) alternatives or third-party APIs |
| **Digital Media** | PostgreSQL large objects (OIDs) | Use Supabase Storage (S3-compatible bucket) |
| **Multi-Tenancy** | PostgreSQL schema-per-tenant | Use Supabase RLS policies with a `library_id` column |
| **Backup/Restore** | Shell-level `pg_dump`/`psql` | Use Supabase's built-in backup features or logical export/import |
| **Label/Card Printing** | Server-side PDF generation (iText) | Client-side PDF generation or a PDF microservice |
| **Lending Receipts** | Server-side printer integration | Browser-based printing or receipt printer API |
| **Authentication** | Custom SHA-1 password hashing in DB | Use Supabase Auth (supports email/password, OAuth, magic links) |
| **Permissions** | Custom RBAC in `permissions` table | Use Supabase RLS + custom claims, or a roles table with RLS policies |

---

## Appendix: Database Schema Summary

### Per-Library Tables (in each library schema)

**Cataloguing:** `biblio_records`, `biblio_holdings`, `authorities_records`, `vocabulary_records`, `*_form_datafields`, `*_form_subfields`, `*_brief_formats`, `*_idx_fields`, `*_idx_sort`, `*_idx_autocomplete`, `*_searches`, `*_search_results`, `*_indexing_groups`

**Circulation:** `users`, `users_types`, `users_fields`, `users_values`, `lendings`, `lending_fines`, `reservations`, `access_cards`, `access_control`

**Acquisition:** `suppliers`, `requests`, `quotations`, `request_quotation`, `orders`

**Administration:** `logins`, `permissions`, `configurations`, `translations`, `digital_media`, `backups`, `z3950_addresses`, `holding_creation_counter`

### Global Tables (shared across all libraries)

`configurations`, `logins`, `backups`, `schemas`, `translations`, `versions`
