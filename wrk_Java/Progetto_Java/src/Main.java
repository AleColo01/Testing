import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;

public class Main {

	public static void main(String[] args) {
		String[] s = new String[] {"A","B","C","D","E"};
		SecretCode sc = new SecretCode(s);
		
		String[] t1 = new String[] {"A","C","Z","Z","Z"};
		System.out.println("codice: " + sc.guessCode(t1));
		System.out.println("punti: " + sc.getPoints());
		
		System.out.println("turno: " + sc.getTurno());
		
		String[] r1 = new String[] {"Hit","Close","Miss","Miss","Miss"};
		String[] res = sc.getResults();
		
		System.out.println("turno: " + sc.getTurno());
		
		for(int i=0; i<res.length; i++) {
			System.out.println("result " + i + ": "+res[i]);	
		}
		
		//Test Case 2
		String[] t2 = new String[] {"C","C","Z","Z","Z"};
		System.out.println("codice " + sc.guessCode(t2));
		
		System.out.println("turno " +sc.getTurno());
		
		//Test Case 3
		String[] t3 = new String[] {"A","B","C","D","E"};
		System.out.println("codice " +sc.guessCode(t3));
		
		String[] s3 = new String[] {"AAA","B","C","D","E"};
		//Violazione di un prerequisito (e invariante)
		SecretCode sc3 = new SecretCode(s3);

	}

}
