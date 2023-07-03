
asm secretCode_2

import StandardLibrary
import CTLlibrary
import LTLlibrary

signature:
	// DOMAINS
	enum domain Options = {RED | YELLOW | GREEN | BLUE | WHITE | BLACK | ORANGE | BROWN}
	enum domain Results = {MISS | CLOSE | HIT}
	enum domain Texts = {INIZIO | SBAGLIATO | VITTORIA | ALLARME}
	domain Slots subsetof Integer
	domain Turns subsetof Integer
	domain PointsDomain subsetof Integer
	
	dynamic controlled turn : Turns
	dynamic monitored input_1: Options
	dynamic monitored input_2: Options
	dynamic monitored input_3: Options
	dynamic monitored inputCode_1: Options
	dynamic monitored inputCode_2: Options
	dynamic monitored inputCode_3: Options
	dynamic controlled code : Slots -> Options
	dynamic controlled results : Slots -> Results
	dynamic controlled endGame : Boolean
	dynamic controlled endTemp : Slots
	dynamic controlled previous: Slots -> Results
	dynamic controlled points: PointsDomain 
	
	dynamic controlled outMess: Texts
	
	derived checkHits: Slots -> Boolean
	static pointsValue: Results -> PointsDomain  
	
definitions:
	// DOMAIN DEFINITIONS
	domain Slots = {1:3}
	domain Turns = {0:10}
	domain PointsDomain  = {-500:500}
	
	// FUNCTION DEFINITIONS	
	function pointsValue($d in Results) =
		switch($d)
			case HIT: 2
			case MISS: -2
			case CLOSE: 1
		endswitch 

	function checkHits($s in Slots)=
		if(previous($s) != HIT or results($s) = HIT) then
			true
		else
			false
		endif
		
	macro rule r_askCode =
		par
			code(1) := inputCode_1
			code(2) := inputCode_2
			code(3) := inputCode_3
		endpar
			
	macro rule r_checkColors=
	par		
	
		if(code(1) = input_1) then
				results(1) := HIT
		else if ( code(1) = input_2 or code(1) = input_3) then
					results(1) := CLOSE
				else
					results(1) := MISS
				endif
		endif
		
		if(code(2) = input_2) then
			results(2) := HIT
		else if ( code(2) = input_1 or code(2) = input_3) then
					results(2) := CLOSE
				else
					results(2) := MISS
				endif
		endif
		
		if(code(3) = input_3) then
				results(3) := HIT
		else if ( code(3) = input_2 or code(3) = input_2) then
					results(3) := CLOSE
				else
					results(3) := MISS
				endif
		endif
	endpar
			
			
	macro rule r_guessCode=
		seq
		previous(1) := results(1)
		previous(2) := results(2)
		previous(3) := results(3)
		
		r_checkColors[]
		
		points := points + pointsValue(results(1))*turn +  pointsValue(results(2))*turn + pointsValue(results(3))*turn
		
		if(turn<=10) then
			if not(checkHits(1) and checkHits(2) and checkHits(3)) then
				par
					endGame := true
					outMess := ALLARME
				endpar
			else 
				//if (exist $s3 in Slots with results($s3) != HIT)then 
				if (results(1)!= HIT or results(2)!= HIT or results(3)!= HIT )then 
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
	
	/* 
	invariant over turn: turn<=10
	invariant over turn: previous(1) = HIT implies results(1) = HIT
	invariant over turn: previous(2) = HIT implies results(2) = HIT
	invariant over turn: previous(3) = HIT implies results(3) = HIT
	*/
	
	// Esiste uno stato in cui vinco
	CTLSPEC ef(outMess = VITTORIA)
	//esiste uno stato in cui il codice è sempre sbagliato fino alla fine del gioco
	CTLSPEC ew( (outMess != ALLARME or outMess = INIZIO), endGame)
	//se results è giusto, anche results del futuro deve essere giusto
	CTLSPEC ag( results(1) = HIT implies af(results(1) = HIT))
	CTLSPEC ag( results(2) = HIT implies af(results(2) = HIT))
	CTLSPEC ag( results(3) = HIT implies af(results(3) = HIT))
	// se ho indovinato tutti i risultati, ho vinto e il gioco finisce
	CTLSPEC ag( (previous(1) = HIT and previous(2) = HIT and previous(3) = HIT and turn<=10) implies af(endGame and outMess = VITTORIA))
	// se il gioco non è finito, posso ancora vincere
	CTLSPEC ag( turn<9 implies ef(outMess = VITTORIA or outMess = ALLARME))
	// se ho vinto non posso cambiare scelte
	CTLSPEC ag( outMess = VITTORIA implies not ef(outMess=SBAGLIATO))  
	
	//uno falso: è possibile che il turno sia uguale a 15
	CTLSPEC ef(turn = 15)
	
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
	function turn = 1
	function endGame = false