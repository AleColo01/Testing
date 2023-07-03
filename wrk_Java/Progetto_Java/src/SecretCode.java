
public class SecretCode {
	//IL CODICE SEGRETO
	private /*@spec_public@*/ String code[] = new String[5];
	private /*@spec_public@*/ int points;
	private /*@spec_public@*/ int turn;
	private /*@spec_public@*/ boolean previous[]; //true se ho indovinato questo slot, false altrimenti 
	private /*@spec_public@*/ int results[] = new int[5]; //-1 miss, 0 close, 1 hit 
	public boolean endGame = false;
	
	//i turni devono essere compresi tra 0 e 10
	//@ public invariant turn >=0 && turn <=10;
	
	//ogni pezzo di codice è composto da una e una sola lettera
	//@ public invariant (\forall int x; x<5 && x>=0; (code[x].length())== 1); 
	
	
	
	//il codice non può essere vuoto
	//@ requires c!=null;
	// il codice deve essere lungo 5
	//@ requires c.length == 5;
	// posso passare solo 1 lettera
	//@ requires (\forall int x; x<5 && x>=0; c[x].length()==1);
	// inizialmente i controlli sono settati a falso
	//@ ensures (\forall int x; x<5 && x>=0; previous[x]==false);
	//il codice segreto viene impostato uguale all'input
	//@ ensures code == c;
	public SecretCode(String c[]) {
		//inizializzo tutto come se fossero tutti gli slot sbagliati
		results = new int[]{-1,-1,-1,-1,-1};
		previous = new boolean[]{false,false,false,false,false};
		code = c;
		points = 0;
		turn = 1;
	}
	
	
	// la lunghezza del tentativo deve essere 5
	//@ requires c.length == 5;
	// ogni parte di codice non deve essere nulla e lunga 1
	//@ requires (\forall int x; x<5 && x>=0; (c[x].length())== 1 && c[x]!=null);
	// se al turno precedente ho indovinato un pezzo, devo mantenere quel risultato
	//@ requires isCodeValid(c);
	// se ho indovinato il codice, ritorna vero, altrimenti, ritorna falso
	//@ ensures (code==c && turn<10 && isCodeValid(c)) ==> \result;
	//@ ensures !\result ==> (code!=c);
	// se il turno è maggiore o uguale a 10 torna falso, ma se è falso non vuol dire che il turno sia >=10
	//@ ensures (turn>=10) ==> !\result;
	// i punti vengono assegnati correttamente
	//@ ensures (turn<10 && isCodeValid(c)) ==> (points == \old(points) + guessPoints(c));
	//@ diverges true;
	public boolean guessCode(String c[]) {
		
		boolean end = endGame; 
		// se ho già indovinato non serve che ricontrollo visto che gli slot giusti si ripetono
		//se non sono trascorsi 10 turni e sto rispettando le regole
		if(turn < 10 && isCodeValid(c) && !endGame) {
			
			int i = 0;
			//@ loop_invariant code[i]!=null;
			for(i=0; i< code.length ;i++) {
				if(code[i].equals(c[i])==false) {
					end = false;
					break;
				}else {
					end= true;	
				}	
			}
			
			if(end) endGame = true;
			points += guessPoints(c);
			turn++;
			//@ assert turn <= 10;
		}
	
		return end;
		
	}
	
	// la lunghezza del tentativo deve essere 5
	//@ requires c.length == 5;
	// controllo che il risultato rispecchi la regola di correttezza
	//@ ensures \result <==> (\forall int x; x<5 && x>=0; code[x].equals(c[x]) || !previous[x]);
	//@ ensures !\result <==> (\exists int x; x<5 && x>=0; !(code[x].equals(c[x])) || previous[x]);
	//@ diverges true;
	private /*@ pure spec_public @*/boolean isCodeValid(String c[]) {
		/*Controllo che se al turno precedente ho indovinato uno slot 
		Allora la stessa lettera deve essere indovinata anche al turno successivo*/
		
		boolean flag = false;
		int i = 0;
		//@ loop_invariant code[i]!=null;
		for(i=0; i< code.length ;i++) {
			if(code[i].equals(c[i])==false && previous[i]) {
				flag = false;
				break;
			}else {
				flag= true;
			}	
		}		
		
		return flag;
	}
	
	// la lunghezza del tentativo deve essere 5
	//@ requires c.length == 5;
	// se ho fatto tutto giusto, devo aver guadagnato 10*turn punti
	//@ ensures  (\forall int x; x<5 && x>=0; code[x].equals(c[x])) <==> \result==10*turn;
	// se ho fatto qualcosa di sbagliato, devo aver guadagnato meno di 10*turn punti
	//@ ensures  (\exists int x; x<5 && x>=0; !(code[x].equals(c[x]))) <==> \result<=10*turn;
	//@ diverges true;
	private /*@ pure spec_public @*/ int guessPoints(String c[]) {
		
		/*
		 * Assegno i punti in base agli slot:
		 * CORRETTO + 2*turno
		 * QUASI + 1*turno
		 * SBAGLIATO -2*turno
		 */
		int p = 0;
		int i = 0;
		//@ loop_invariant code[i]!=null;
		for(i=0; i< code.length ;i++) {
			if(code[i].equals(c[i])) {
				previous[i] = true;
				p += 2*turn;
				results[i] = 1;
			}else if( isLetterinCode(c[i])){
				previous[i] = false;
				p += 1*turn;
				results[i] = 0;
			}else {
				previous[i] = false;
				p -= 2*turn;
				results[i] = -1;
			}
		}
		return p;
	}
	
	//puoi prendere solo una lettera come input
	//@ requires l!=null && l.length() == 1 ;
	// se esiste una pezzo di codice uguale alla lettera, ritorna vero
	//@ ensures  (\exists int x; x<5 && x>=0; code[x].equals(l)) <==> \result;
	// se non esiste una pezzo di codice uguale alla lettera, ritorna falso
	//@ ensures  (\forall int x; x<5 && x>=0; !(code[x].equals(l))) <==> !\result;
	//@ diverges true;
	private boolean isLetterinCode(String l) {
		/*
		 * RITORNA
		 * vero se è presente la lettera in un qualsiasi slot del codice segreto
		 * falso altrimenti
		 * 
		 */
		
		boolean flag = false;
		int i = 0;
		//@ loop_invariant code[i]!=null;
		for(i=0; i< code.length ;i++) {
			if(code[i].equals(l)) {
				flag = true;
				break;
			}else {
				flag= false;
			}	
		}
		return flag;
	}
	
	//@ requires true;
	//@ ensures  \result == points ;
	public int getPoints() {
		return points;
	}
	
	public int getTurno() {
		return turn;
	}
	
	// non lo posso lanciare prima del primo turno perchè non avrei nessuna risposta
	//@ requires turn>=2;
	//@ ensures \result.length == 5;
	public String[] getResults() {
		String[] s = new String[5];
		int i = 0;
		// @ loop_writes i, s[*];
		for(i=0;i<5;i++) {
			if(results[i]==1) s[i]="Hit";
			else if(results[i]==0) s[i]="Close";
			else s[i]="Miss";
		}
		return s;
	}
	
}
