package MBT;

import static org.junit.Assert.*;

import org.junit.Test;

public class ProvaMBT {

	@Test
	public void testFFF2() {
		Options white = Options.WHITE;
		Options green = Options.GREEN;
		Options black = Options.BLACK;
		Options blue = Options.BLUE;
		Options[] array1 = new Options[]{white,white,green};
		CodiceSegreto cs = new CodiceSegreto(array1);
		
		assertEquals(Results.MISS,cs.results[0]);
		assertEquals(Results.MISS,cs.results[1]);
		assertEquals(Results.MISS,cs.results[2]);
		assertEquals(Turn.INIZIO,cs.turno);
		assertEquals(white, cs.code[0]);
		assertEquals(white, cs.code[1]);
		assertEquals(green, cs.code[2]);
		
		Options[] array2 = new Options[]{white,white,white};
		cs.indovinaCodice(array2);
		
		assertEquals(Results.HIT,cs.results[0]);
		assertEquals(Results.HIT,cs.results[1]);
		assertEquals(Results.CLOSE,cs.results[2]);
		assertEquals(Turn.GIOCO,cs.turno);
		
		Options[] array3 = new Options[]{blue,black,black};
		cs.indovinaCodice(array2);
	}
	
	@Test
	public void testT() {
		Options white = Options.WHITE;
		Options black = Options.BLACK;
		Options[] array1 = new Options[]{white,white,white};
		CodiceSegreto cs = new CodiceSegreto(array1);
		
		assertEquals(Results.MISS,cs.results[0]);
		assertEquals(Results.MISS,cs.results[1]);
		assertEquals(Results.MISS,cs.results[2]);
		assertEquals(Turn.INIZIO,cs.turno);
		assertEquals(white, cs.code[0]);
		assertEquals(white, cs.code[1]);
		assertEquals(white, cs.code[2]);
		
		Options[] array2 = new Options[]{black,black,black};
		cs.indovinaCodice(array2);
		
		assertEquals(Turn.GIOCO,cs.turno);
		
		Options[] array3 = new Options[]{white,white,white};
		cs.indovinaCodice(array3);
		
		assertEquals(Results.HIT,cs.results[0]);
		assertEquals(Results.HIT,cs.results[1]);
		assertEquals(Results.HIT,cs.results[2]);
	}
	

}
