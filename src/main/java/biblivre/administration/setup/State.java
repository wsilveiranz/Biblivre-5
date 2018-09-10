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
package biblivre.administration.setup;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicBoolean;

import org.apache.commons.lang3.StringUtils;

public class State {
	public static AtomicBoolean LOCKED = new AtomicBoolean(false);
	private static StringBuilder log;
	private static String lastMessage;
	private static long steps;
	private static long currentStep;

	private static long currentSecondaryStep;
	
	public static void start() {
		State.LOCKED.set(true);
		State.log = new StringBuilder();
		State.lastMessage = "";
		State.steps = 0;
		State.currentStep = 0;
		State.currentSecondaryStep = 0; 
	}
	
	public static void cancel() {
		State.LOCKED.set(false);
	}

	public static void finish() {
		State.LOCKED.set(false);
	}
	
	public static String getLog() {
		if (State.log == null) {
			return "";
		}
		
		return State.log.toString();
	}

	public static String getLastMessage() {
		return State.lastMessage;
	}
	
	public static void setSteps(long steps) {
		State.steps = steps;
	}
	
	public static long getSteps() {
		return State.steps;
	}

	public static long getCurrentStep() {
		return State.currentStep;
	}
	
	public synchronized static void incrementCurrentStep() {
		State.currentStep++;
	}

	public synchronized static void incrementCurrentStep(long count) {
		State.currentStep += count;
	}
	
	
	public static void setCurrentSecondaryStep(long steps) {
		State.currentSecondaryStep = steps;
	}

	public static long getCurrentSecondaryStep() {
		return State.currentSecondaryStep;
	}
	
	public synchronized static void incrementCurrentSecondaryStep() {
		State.currentSecondaryStep++;
	}

	public synchronized static void incrementCurrentSecondaryStep(long count) {
		State.currentSecondaryStep += count;
	}

	public synchronized static void writeLog(String message) {
		if (StringUtils.isBlank(message)) {
			return;
		}
		
		State.log.append(message).append("\n");
		State.lastMessage = message;
	}

	public static void attachLogMonitor(Process p) throws IOException {
		try (
				final BufferedReader br = new BufferedReader(
						new InputStreamReader(p.getInputStream(), "UTF-8"));
		) {
			Executor executor = Executors.newSingleThreadExecutor();
			executor.execute(() -> br.lines().forEach(line -> State.writeLog(line)));
		}
	}
}
