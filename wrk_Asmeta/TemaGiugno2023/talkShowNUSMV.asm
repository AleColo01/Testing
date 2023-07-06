
asm talkShowNUSMV

import StandardLibrary
import CTLlibrary

signature:
	enum domain Stato = {PARLA | ASCOLTA | ATTESA}
	enum domain ChiParla = {CASO | NESSUNO | UNO | DUE | TRE}
	domain Persone subsetof Integer
	domain TempoAttesa subsetof Integer
	domain TempoParla subsetof Integer
	domain Percentuale subsetof Integer
	
	monitored input : ChiParla
	controlled moderatrice: Stato
	controlled persone: Persone -> Stato
	controlled inAttesa: Persone -> TempoAttesa
	controlled speaker: TempoParla
	controlled microfono: Persone
	
	static maxTempoAttesa : TempoAttesa
	static maxTempoParla : TempoParla
	
definitions:
	domain Persone = {1:3}
	domain TempoAttesa = {0:7} 
	domain TempoParla = {0:5}
	domain Percentuale = {1:10}	
	
	function maxTempoAttesa = 7
	
	function maxTempoParla = 5
	
	macro rule r_ScegliSpeaker = 
		if (persone(1) = ATTESA or persone(2) = ATTESA or persone(3) = ATTESA) then
			choose $p2 in Persone with persone($p2) = ATTESA do
				par
					speaker := maxTempoParla
					microfono := $p2
					persone($p2) := PARLA
					moderatrice := ASCOLTA
				endpar
		else	
			par
				microfono := undef
				moderatrice := PARLA
			endpar
		endif
		
	
	macro rule r_ScalaParla = 
		if speaker > 0 then
			speaker := speaker -1
		else
			par
				persone(microfono) := ASCOLTA
				r_ScegliSpeaker[]
			endpar
		endif
	
	macro rule r_ScalaAttesa = 
		par 
			if(persone(1) = ATTESA) then 
				if inAttesa(1) > 0 then
					inAttesa(1) := inAttesa(1) -1 
				else
					persone(1) := ASCOLTA
				endif
			endif
			
			if(persone(2) = ATTESA) then 
				if inAttesa(2) > 0 then
					inAttesa(2) := inAttesa(2) -1 
				else
					persone(2) := ASCOLTA
				endif
			endif
			
			if(persone(3) = ATTESA) then 
				if inAttesa(3) > 0 then
					inAttesa(3) := inAttesa(3) -1 
				else
					persone(3) := ASCOLTA
				endif
			endif
			
		endpar
		
	//Chiunque può parlare
	CTLSPEC (forall $p in Persone with ef(persone($p) = PARLA))
	//Solo uno parla
	CTLSPEC ag(persone(1) = PARLA implies (persone(2) != PARLA and persone(3) != PARLA and moderatrice != PARLA )) 
	CTLSPEC ag(persone(2) = PARLA implies (persone(1) != PARLA and persone(3) != PARLA and moderatrice != PARLA )) 
	CTLSPEC ag(persone(3) = PARLA implies (persone(1) != PARLA and persone(2) != PARLA and moderatrice != PARLA )) 
	CTLSPEC ag(moderatrice = PARLA implies (persone(2) != PARLA and persone(3) != PARLA and persone(1) != PARLA )) 
	//Solo la persona con il microfono acceso parla
	CTLSPEC ag (persone(1) = PARLA implies microfono = 1)
	CTLSPEC ag (persone(2) = PARLA implies microfono = 2)
	CTLSPEC ag (persone(3) = PARLA implies microfono = 3)
	//Sbagliata: può essere chi parla ha più tempo di 5
	CTLSPEC ef (speaker > maxTempoParla)
	
	main rule r_Main=
		par
			r_ScalaParla[]
			r_ScalaAttesa[]
			if(persone(1) = ASCOLTA) then 
				choose $s in Percentuale with true do
					if( ($s >= 7 and input = CASO) or input = UNO) then
						par
							inAttesa(1) := maxTempoAttesa
							persone(1) := ATTESA
						endpar
					endif
			endif
			
			if(persone(2) = ASCOLTA) then 
				choose $s2 in Percentuale with true do
					if( ($s2 >= 7 and input = CASO) or input = DUE) then
						par
							inAttesa(2) := maxTempoAttesa
							persone(2) := ATTESA
						endpar
					endif
			endif
			
			if(persone(3) = ASCOLTA) then 
				choose $s3 in Percentuale with true do
					if( ($s3 >= 7 and input = CASO) or input = TRE) then
						par
							inAttesa(3) := maxTempoAttesa
							persone(3) := ATTESA
						endpar
					endif
			endif
		endpar

// INITIAL STATE
default init s0:
	function speaker = 0
	function microfono = undef
	function persone($a in Persone) = ASCOLTA
	function inAttesa($a in Persone) = 0
	function moderatrice = PARLA
