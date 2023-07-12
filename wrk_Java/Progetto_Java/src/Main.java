public class Main {

	public static void main(String[] args) {
		String[] s = new String[] {"A","B","C","D","E"};
		SecretCode sc = new SecretCode(s);
		
		//Scenario con codice sbagliato
		String[] t1 = new String[] {"A","C","Z","Z","Z"};
		System.out.println("codice: " + sc.guessCode(t1));
		System.out.println("punti: " + sc.getPoints());
		
		System.out.println("turno: " + sc.getTurno());
		
		String[] r1 = new String[] {"Hit","Close","Miss","Miss","Miss"};
		String[] res = sc.getResults();
		
		System.out.println("turno: " + sc.getTurno());
		
		for(int i=0; i<res.length; i++) {
			System.out.println("result " + i + ": "+res[i] + " expected : " + r1[i]);	
		}
		
		String[] t2 = new String[] {"C","C","Z","Z","Z"};
		System.out.println("codice " + sc.guessCode(t2));
		
		System.out.println("turno " +sc.getTurno());
		
		//Scenario di vittoria
		String[] t3 = new String[] {"A","B","C","D","E"};
		
		System.out.println("codice: " +sc.guessCode(t3));
		
		//Scenario con violazione di un invariante
		String[] s3 = new String[] {"AAA","B","C","D","E"};
		SecretCode sc3 = new SecretCode(s3);
		System.out.println("lunghezza AAA:" + s3[0].length());
		System.out.println("errato:" + sc3.endGame);
		
	}

}
