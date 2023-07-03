import static org.junit.Assert.*;

import org.junit.Test;

public class TestSecretCode {

	@Test
	public void testIstruzioni() {
		//Test Case 1
		String[] s = new String[] {"A","B","C","D","E"};
		SecretCode sc = new SecretCode(s);
		
		assertEquals(1,sc.getTurno());
		
		String[] t1 = new String[] {"A","C","Z","Z","Z"};
		assertFalse(sc.guessCode(t1));
		assertEquals(-3,sc.getPoints());

		
		String[] r1 = new String[] {"Hit","Close","Miss","Miss","Miss"};
		String[] res = sc.getResults();
		for(int i=0; i<res.length; i++) {
			assertEquals(r1[i],res[i]);	
		}
		
		String[] t2 = new String[] {"C","C","Z","Z","Z"};
		assertFalse(sc.guessCode(t2));
		
		assertEquals(2,sc.getTurno());
		 
		String[] t3 = new String[] {"A","B","C","D","E"};
		assertTrue(sc.guessCode(t3));
		
	}
	
	@Test
	public void testMCDC() {
		String[] s = new String[] {"A","B","C","D","E"};
		SecretCode sc = new SecretCode(s);
		
		//Test Case 2
		String[] t3 = new String[] {"A","B","C","D","E"};
		sc.guessCode(t3);
		assertTrue(sc.guessCode(t3));
		
		//Test Case 3
		String[] s2 = new String[] {"A","B","C","D","E"};
		SecretCode sc2 = new SecretCode(s2);
		String[] t5 = new String[] {"Z","Z","Z","Z","Z"};
		
		for(int i=0; i<10; i++) {
			assertFalse(sc2.guessCode(t5)); //vado al turno 10
		}
		
		assertFalse(sc2.guessCode(t5));
	}

}
