
asm talkShow

import StandardLibrary

signature:
	enum domain Stato = {PARLA | ASCOLTA | ATTESA}
	domain Persone subsetof Integer
	domain TempoAttesa subsetof Integer
	domain TempoParla subsetof Integer
	domain Percentuale subsetof Integer
	
	controlled moderatrice: Stato
	controlled persone: Persone -> Stato
	controlled inAttesa: Persone -> TempoAttesa
	controlled speaker: TempoParla
	controlled microfono: Persone
	
	static maxTempoAttesa : TempoAttesa
	static maxTempoParla : TempoParla
	
definitions:
	domain Persone = {1:6}
	domain TempoAttesa = {0:7} 
	domain TempoParla = {0:5}
	domain Percentuale = {1:10}	
	
	function maxTempoAttesa = 7
	
	function maxTempoParla = 5
	
	macro rule r_ScegliSpeaker = 
		if (exist $p in Persone with persone($p) = ATTESA) then
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
				speaker := 0
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
		forall $p in Persone with persone($p) = ATTESA do
			if inAttesa($p) > 0 then
				inAttesa($p) := inAttesa($p) -1 
			else
				persone($p) := ASCOLTA
			endif
			
	invariant inv_mod over moderatrice: moderatrice = PARLA implies speaker = 0
	
	main rule r_Main=
		par
			r_ScalaParla[]
			r_ScalaAttesa[]
			forall $p in Persone with persone($p)=ASCOLTA do
				choose $s in Percentuale with true do
					if( $s >= 7 ) then
						par
							inAttesa($p) := maxTempoAttesa
							persone($p) := ATTESA
						endpar
					endif
		endpar

// INITIAL STATE
default init s0:
	function speaker = 0
	function microfono = undef
	function persone($a in Persone) = ASCOLTA
	function inAttesa($a in Persone) = 0
	function moderatrice = PARLA
