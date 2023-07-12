import static org.junit.Assert.*;

import org.junit.Test;

public class Scenari {

	@Test
	public void testVittoria() {
		String[] s = new String[] {"G","W","R","_","_"};
		SecretCode sc = new SecretCode(s);
		assertEquals(1,sc.getTurno());
		
		String[] t1 = new String[] {"G","R","B","_","_"};
		assertFalse(sc.guessCode(t1));
		assertEquals(2,sc.getTurno());
		String[] res = sc.getResults();
		assertEquals("Hit",res[0]);
		assertEquals("Close",res[1]);
		assertEquals("Miss",res[2]);
		assertFalse(sc.endGame);
		
		String[] t2 = new String[] {"G","O","R","_","_"};
		assertFalse(sc.guessCode(t2));
		assertEquals(3,sc.getTurno());
		res = sc.getResults();
		assertEquals("Hit",res[0]);
		assertEquals("Miss",res[1]);
		assertEquals("Hit",res[2]);
		assertFalse(sc.endGame);
		
		String[] t3 = new String[] {"G","W","R","_","_"};
		assertTrue(sc.guessCode(t3));
		assertEquals(4,sc.getTurno());
		res = sc.getResults();
		assertEquals("Hit",res[0]);
		assertEquals("Hit",res[1]);
		assertEquals("Hit",res[2]);
		assertTrue(sc.endGame);
	}

}
