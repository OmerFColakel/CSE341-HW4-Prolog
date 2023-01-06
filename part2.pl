%	200104004043 Omer Faruk Colakel
%	CSE341 - Programming Languages - HW4 - Part 2


%	All Schedules - Facts
schedule(istanbul, izmir, 2).
schedule(izmir, istanbul,  2).

schedule(istanbul, rize, 4).
schedule(rize, istanbul,  4).

schedule(istanbul, ankara, 1).
schedule(ankara, istanbul,  1).

schedule(ankara, rize, 5).
schedule(rize, ankara, 5).

schedule(ankara, izmir, 6).
schedule(izmir, ankara, 6).

schedule(ankara, van, 4).
schedule(van, ankara, 4).

schedule(ankara, diyarbakir, 8).		% "diyarbakir" is "diyarbakır" in pdf
schedule(diyarbakir, ankara, 8).

schedule(van, gaziantep, 3).
schedule(gaziantep, van, 3).

schedule(antalya, diyarbakir, 4).
schedule(diyarbakir, antalya, 4).

schedule(antalya, erzincan, 3).
schedule(erzincan, antalya, 3).

schedule(antalya, izmir, 2).
schedule(izmir, antalya, 2).

schedule(erzincan, canakkale, 6).
schedule(canakkale, erzincan, 6).

%	New Facts
schedule(giresun,bayburt, 1).
schedule(bayburt, giresun,1).

schedule(giresun,trabzon, 2).
schedule(trabzon, giresun,2).

schedule(hakkari, gaziantep, 2).
schedule(gaziantep, hakkari, 2).

%	Rules

% START   -> Start Point
% ENDDEST -> End Point
% VISITED -> Visited Cities are Listed to Prevent Visiting Them Again
% TOTCOST -> Total Cost

connection(START , ENDDEST , COST) :-  
			total(START , ENDDEST , COST , []).
 
% returns closest city''s cost
total(START , ENDDEST , COST , _) :-  
				schedule(START , ENDDEST , COST)
				.   


total(NEXTDEST , ENDDEST , TOTCOST , VISITED) :-  
				schedule(NEXTDEST, NEWDEST, CURCOST),					% takes the next destination
				\+ member(NEWDEST, VISITED),							% checks if the new destination is visited. avoids loops
				total(NEWDEST, ENDDEST, NEXTCOST, [NEXTDEST|VISITED]),	% calls itself recursively
				NEXTDEST \= ENDDEST,									% checks if the program reached end destinat
				TOTCOST is CURCOST + NEXTCOST							% returns total cost recursively
				.	
		
