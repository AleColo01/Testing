import static org.junit.Assert.*;

import org.junit.Test;

public class CTfalse {

	@Test
	public void test() {
		//inizializzazione
		String[] code = new String[] {"B","B","C","C","C"};
		SecretCode sc = new SecretCode(code);
		
		//turno 1
		String[] slot1x = new String[] {"C","A","A","A","A"};
		sc.guessCode(slot1x);
		
		//turno 2
		String[] slot2x = new String[] {"A","B","D","B","E"};
		sc.guessCode(slot2x);
		
		//turno 3
		String[] slot3x = new String[] {"D","B","E","D","B"};
		sc.guessCode(slot3x);
		
		//turno 4
		String[] slot4x = new String[] {"E","B","B","E","D"};
		assertFalse(sc.guessCode(slot4x));
	}

}
