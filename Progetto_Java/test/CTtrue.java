import static org.junit.Assert.*;

import org.junit.Test;

public class CTtrue {

	@Test
	public void test() {
		//inizializzazione
		String[] code = new String[] {"B","E","A","D","D"};
		SecretCode sc = new SecretCode(code);
		
		//turno 1
		String[] slot1x = new String[] {"B","A","E","C","B"};
		sc.guessCode(slot1x);
		
		//turno 2
		String[] slot2x = new String[] {"B","B","B","E","B"};
		sc.guessCode(slot2x);
		
		//turno 3
		String[] slot3x = new String[] {"B","C","A","E","C"};
		sc.guessCode(slot3x);
		
		//turno 4
		String[] slot4x = new String[] {"B","E","A","D","D"};
		assertTrue(sc.guessCode(slot4x));
	
	}

}
