/*******************************************************************************
 * Este arquivo é parte do Biblivre5.
 * 
 * Biblivre5 é um software livre; você pode redistribuí-lo e/ou 
 * modificá-lo dentro dos termos da Licença Pública Geral GNU como 
 * publicada pela Fundação do Software Livre (FSF); na versão 3 da 
 * Licença, ou (caso queira) qualquer versão posterior.
 * 
 * Este programa é distribuído na esperança de que possa ser  útil, 
 * mas SEM NENHUMA GARANTIA; nem mesmo a garantia implícita de
 * MERCANTIBILIDADE OU ADEQUAÇÃO PARA UM FIM PARTICULAR. Veja a
 * Licença Pública Geral GNU para maiores detalhes.
 * 
 * Você deve ter recebido uma cópia da Licença Pública Geral GNU junto
 * com este programa, Se não, veja em <http://www.gnu.org/licenses/>.
 * 
 * @author Alberto Wagner <alberto@biblivre.org.br>
 * @author Danniel Willian <danniel@biblivre.org.br>
 ******************************************************************************/
package biblivre.core.utils;

import java.io.IOException;
import java.io.InputStream;
import java.util.Map;
import java.util.Properties;

import org.apache.log4j.Logger;

public class DatabaseConfig {

	private static Logger logger = Logger.getLogger(DatabaseConfig.class);

	private static Properties props = new Properties();

	static {
		InputStream is = null;
		try {
			is = DatabaseConfig.class.getClassLoader().getResourceAsStream("database.properties");
			if (is != null) {
				props.load(is);
			} else {
				logger.error("database.properties not found on classpath");
			}
		} catch (IOException e) {
			logger.error("Failed to load database.properties", e);
		} finally {
			if (is != null) {
				try {
					is.close();
				} catch (IOException e) {
					logger.error("Failed to close database.properties stream", e);
				}
			}
		}
	}

	public static String getHost() {
		return props.getProperty("db.host", "localhost");
	}

	public static String getPort() {
		return props.getProperty("db.port", "5432");
	}

	public static String getDatabase() {
		return props.getProperty("db.database", "biblivre4");
	}

	public static String getUser() {
		return props.getProperty("db.user", "biblivre");
	}

	public static String getPassword() {
		return props.getProperty("db.password", "");
	}

	public static String getSslMode() {
		return props.getProperty("db.sslmode", "disable");
	}

	public static String getJdbcUrl() {
		return "jdbc:postgresql://" + getHost() + ":" + getPort() + "/" + getDatabase()
				+ "?ssl=true&sslmode=" + getSslMode();
	}

	public static void configurePgEnvironment(ProcessBuilder pb) {
		Map<String, String> env = pb.environment();
		env.put("PGHOST", getHost());
		env.put("PGPORT", getPort());
		env.put("PGDATABASE", getDatabase());
		env.put("PGUSER", getUser());
		env.put("PGPASSWORD", getPassword());
		env.put("PGSSLMODE", getSslMode());
	}
}
