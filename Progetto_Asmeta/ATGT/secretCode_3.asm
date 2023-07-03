
asm secretCode_3

import StandardLibrary


signature:
	// DOMAINS
	enum domain Options = {RED | YELLOW | GREEN | BLUE | WHITE | BLACK | ORANGE | BROWN}
	enum domain Results = {MISS | CLOSE | HIT}
	enum domain Turn = {INIZIO | GIOCO | FINE}
	
	dynamic monitored input_1: Options
	dynamic monitored input_2: Options
	dynamic monitored input_3: Options
	dynamic monitored input_code1: Options
	dynamic monitored input_code2: Options
	dynamic monitored input_code3: Options
	dynamic controlled turno: Turn
	dynamic controlled code_1 : Options
	dynamic controlled code_2 : Options
	dynamic controlled code_3 : Options
	dynamic controlled results_1 : Results
	dynamic controlled results_2 : Results
	dynamic controlled results_3 : Results
	
definitions:
	
	main rule r_Game =
		if(results_1 = HIT and results_2 = HIT and results_3 = HIT) then
			turno := FINE
		else		
			par
				turno := GIOCO
				//slot uno
				if(input_1 = code_1) then
					results_1 := HIT
				else 
					if ( code_2 = input_1 or code_3 = input_1) then
						results_1 := CLOSE
					else
						results_1 := MISS
					endif
				endif
				//slot due
				if(input_2 = code_2) then
					results_2 := HIT
				else 
					if ( code_1 = input_2 or code_3 = input_2) then
						results_2 := CLOSE
					else
						results_2 := MISS
					endif
				endif
				//slot tre
				if(input_3 = code_3) then
					results_3 := HIT
				else 
					if ( code_1 = input_3 or code_2 = input_3) then
						results_3 := CLOSE
					else
						results_3 := MISS
					endif
				endif
			endpar
		endif	

// INITIAL STATE
default init s0:
 	function turno = INIZIO
 	function code_1 = input_code1
 	function code_2 = input_code2
 	function code_3 = input_code3
 	function results_1 = MISS
 	function results_2 = MISS
 	function results_3 = MISS