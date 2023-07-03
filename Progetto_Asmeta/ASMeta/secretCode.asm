
asm secretCode

import StandardLibrary


signature:
	// DOMAINS
	// Il codice è composto da diversi colori
	enum domain Options = {RED | YELLOW | GREEN | BLUE | WHITE | BLACK | ORANGE | BROWN}
	//Hit se il colore è giusto nel posto giusto, close se è giusto nel posto sbagliato, miss se è sbagliato
	enum domain Results = {MISS | CLOSE | HIT}
	//Inizio al primo turno, sbagliato se il codice non è corretto, allarme se non è stato ripetuto un colore corretto
	// Vittoria se viene indovinato il codice
	enum domain Texts = {INIZIO | SBAGLIATO | VITTORIA | ALLARME}
	domain Slots subsetof Integer
	domain Turns subsetof Integer
	domain Pointsdomain subsetof Integer
	
	dynamic controlled turn : Turns
	//Input del giocatore che deve indovinare
	dynamic monitored input: Slots -> Options
	//Input del giocatore che scrive il codice segreto (potevano essere messi in uno solo) 
	dynamic monitored input_code: Slots -> Options
	//Il codice da indovinare
	dynamic controlled code : Slots -> Options
	//Risultati di ogni slot ad ogni turno
	dynamic controlled results : Slots -> Results
	//Indica se il gioco è finito
	dynamic controlled endGame : Boolean
	//Risultati degli slot al turno precedente
	dynamic controlled previous: Slots -> Results
	//I punti del giocatore che deve indovinare
	dynamic controlled points: Pointsdomain 
	//Messaggio visualizzato 
	dynamic controlled outMess: Texts
	
	//Controlla che la regola di ripetizione sia rispettata
	derived checkHits: Slots -> Boolean
	//assegna i punti in base al risultato
	static pointsValue: Results -> Pointsdomain
	//calcola i punti da aggiungere o sottrarre ad ogni turno
	derived getPoints: Prod(Turns,Results) -> Pointsdomain

definitions:
	// DOMAIN DEFINITIONS
	domain Slots = {1:3}
	domain Turns = {0:10}
	domain Pointsdomain  = {-500:500}
	
	// FUNCTION DEFINITIONS	
	function pointsValue($d in Results) =
		switch($d)
			case HIT: 2
			case MISS: -2
			case CLOSE: 1
		endswitch 
		
	function getPoints($t in Turns, $r in Results)=
		//Più avanti nel gioco siamo più perdi/guadagni punti
		pointsValue($r)*$t  

	function checkHits($s in Slots)=
		// A => B equivale a 
		// notA or B
		if(previous($s) != HIT or results($s) = HIT) then
			true
		else
			false
		endif
		
	
	macro rule r_askCode =
		forall $s in Slots with true do
		//Altri modi per inizializzare il codice, ad esempio senza un giocatore esterno
		//Ho messo input per far si che fosse più semplice creare gli scenari
		//Siccome se uso step until sarebbero numerosi turni e diventa imprevedibile
			//choose $p in Options with true do
				//code($s) := $p
			code($s) := input_code($s)
			
	macro rule r_checkColors ($s in Slots)=	
		//Colore giusto al posto giusto
		if(code($s) = input($s)) then
				results($s) := HIT
		else
			//Colore sbagliato al posto sbagliato
			forall $s2 in Slots with not ($s=$s2) do
				if ( code($s2) = input($s)) then
					results($s) := CLOSE
				endif
		endif		
			
	macro rule r_guessCode=
		seq
		//Impostazioni iniziali del turno 
		previous(1) := results(1)
		previous(2) := results(2)
		previous(3) := results(3)
		//Imposto tutto a miss perchè poi cambio solo i valori Hit o Close 
		results(1) := MISS
		results(2) := MISS
		results(3) := MISS
		
		//calcolo i risultati
		forall $s in Slots with true do
			r_checkColors[$s]
			
		//calcolo i punti
		points := points + getPoints(turn+1,results(1)) + getPoints(turn+1,results(2)) + getPoints(turn+1,results(3))
		
		//calcolo il messaggio di uscita
		if(turn<=10) then
			if not(checkHits(1) and checkHits(2) and checkHits(3)) then
				par
					endGame := true
					outMess := ALLARME
				endpar
			else 
				if (exist $s3 in Slots with results($s3) != HIT) then 
					par
						endGame := false
						outMess := SBAGLIATO
					endpar				
				else
					par
						endGame := true
						outMess := VITTORIA
					endpar
				endif
			endif
		else
			par
				endGame := true
				outMess := SBAGLIATO
			endpar
		endif
		
	endseq
	
	//Invarianti per far rispettare il vincolo di ripetizione
	invariant over turn: turn<=10
	invariant over turn: previous(1) = HIT implies results(1) = HIT
	invariant over turn: previous(2) = HIT implies results(2) = HIT
	invariant over turn: previous(3) = HIT implies results(3) = HIT
	
	//Ciclo principale 
	main rule r_Game =
		if not (endGame) then
			par
				turn := turn+1	
				if(outMess = INIZIO) then
					par
						outMess := SBAGLIATO
						r_askCode[]
					endpar					
				else
					r_guessCode[]
				endif	
			endpar	
		endif 

// INITIAL STATE
default init s0:
	function outMess = INIZIO
	function points = 0
 	function results($a in Slots) = MISS
	function previous($a in Slots) = MISS
	function turn = 0
	function endGame = false