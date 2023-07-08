package MBT;

public class CodiceSegreto {
	Options[] code = new Options[3];
	Turn turno;
	Results[] results = new Results[3];
	
	public CodiceSegreto(Options[] codice) {
		this.code = codice;
		turno = Turn.INIZIO;
		results[0] = Results.MISS;
		results[1] = Results.MISS;
		results[2] = Results.MISS;
	}
	
	public void indovinaCodice(Options[] codice) {
		if(results[0] == Results.HIT && results[1] == Results.HIT && results[0] == Results.HIT) {
			turno = Turn.FINE;
		}else {
			turno = Turn.GIOCO;
			//slot uno
			if(codice[0] == code[0]) results[0] = Results.HIT;
			else if (codice[0] == code[1] || codice[0] == code[2]) results[0] = Results.CLOSE;
			else results[0] = Results.MISS;
			//slot due
			if(codice[1] == code[1]) results[1] = Results.HIT;
			else if (codice[1] == code[2] || codice[1] == code[0]) results[1] = Results.CLOSE;
			else results[1] = Results.MISS;
			//slot tre
			if(codice[2] == code[2]) results[2] = Results.HIT;
			else if (codice[2] == code[1] || codice[2] == code[0]) results[2] = Results.CLOSE;
			else results[2] = Results.MISS;
		}
	}
}
