# Helios: Game Design Document (version C)

This document presents the main design of the game Helios.

## Overview

In the year 2400, the fledgling colonies of Mars have declared independence from Earth. Now, the political factions of Mars must compete for dominance before Earth sends an army to reassert control over its wayward subject. HELIOS is a computer game where 2-6 players seek to win an election process through protest, violence, and terrorism.

## The Objective

Every 3 turns a vote occurs. Players get a vote for each territory on the Martian globe they control. Whoever wins two votes in a row wins the game. Players can gain territories by controlling the majority of Citizen units present on a territory, by means of civilian protests, militia oppression, or terrorist attacks.

Terran Army units eventually start invading. Players must control at least half of the territories on the map, or the game ends.

## The Map

Mars is divided into 12 sectors. Each sector can contain units belonging to multiple players: ownership of the sector is determined by whoever has the most Citizen units present loyal to their party.

If there are 5 players, 2 provinces start with no Citizens. Otherwise, provinces are evenly divided amongst the players.

## The Units

There are 4 kinds of player units in HELIOS, and 1 kind of computer unit. Units cost Build Points to place on the map, and players get 1 Build Point for each territory they control. You may Build in any territory that doesn't have a Terran Army on it, even if you don't have any units there.

### Citizens

*X Build Points*

Citizens are the most important and numerous unit in HELIOS, since they are used to assert electoral control over a Martian territory: whoever has the most citizens on a territory secure the territory's votes in elections. If you have citizens in a territory, you can use the 'Organize Protest' action.

#### Special Action: Organize Protest

Citizen action. This announces a public protest in the territory the Citizen is in, to occur not on the turn it is announced, but the NEXT turn, so everyone can see that it has been scheduled. When the protest finally occurs, it will convert a number of citizens to the announcing citizen's player.

### Militia

*X Build Points*

Militia are hyper-partisan, and are willing to engage in violence against members of non-party units. Militia can attack militia of other parties and fight Police. If you have militias in a territory, you can use the 'Persecute Enemies' action.

#### Special Action: Persecute Enemies

Militia action. This occurs on the turn that it is announced, and attacks a specific enemy faction. If the target faction has a militia present, a combat occurs between the two enemy militia, and they lose militia units according to the casualties inflicted. If the target faction has no militia present, then a combat occurs between the attacking militia and any police present. Finally, if no police are present, then the attack is conducted against citizens of the target faction!

### Terrorists

*X Build Points*

Terrorists are secretly-placed units that grow stronger each turn they remain hidden. When a terrorist attacks, a devastating attack is unleashed, but the terrorist is used up. If you have a terrorist in a territory, you can use the 'Commit Terror Attack' action.

#### Special Action: Commit Terror Attack

Terrorist action. This occurs on the turn that it is announced, and attacks all factions. If there are Police conducting Counterterrorism, a combat occurs: if the police win, the terrorist is removed with no further consequence. If the police lose, or none are present, then the terror attack succeeds, and inflicts damage against all enemy units in the territory. If a Protest is happening in the territory this turn, then the attack is much more deadly. There is a 15% chance of the terrorist's identity/party being revealed. If a Terran Army is present, the attack is instead directed solely at the Terran Army unit.

### Police

*X Build Points*

Police belong to whoever won the last election, and are very powerful units. Police are the only unit that can move from one territory to another. If you have a police in a territory, you can use the 'Martial Law' and 'Remobilize' actions.

#### Special Action: Martial Law

Police action. This occurs on the turn that it is announced, and does two things. First, protests become much less effective at converting citizens if a protest is happening this turn. Second, the police can attack a specific enemy's militia in the territory.

#### Special Action: Move

Police action. This occurs on the turn it is announced. This action targets any territory on the map: the police unit is moved to that territory immediately.

### Terran Army

Terran Armies start landing on Mars after a number of turns, and are incredibly powerful units controlled by the computer: they can only be fended off by having massive amounts of Police and Militia teaming up. A Terran Army prevents players from creating units on the territory it is in, although Police are free to move in. If no police or militia are present in the territory that a Terran Army is in, all citizen units are removed (considered pacified and made subjects of Earth again). Terran Armies will use their Subjugation action if there is a Militia or Police present. If no Militia or Police is present, but Citizens are, the Terran Army will use their Pacify action. If no Militia, Police, or Citizens are present, then the Terran will March. Terran Armies appear on random territories, at a rate that increases and increases until they control more than half of Mars (ending the game) or a Martian government is formed (a player wins two elections in a row).

#### Special Action: Subjugation

Terran Army action. This occurs on the turn it is announced. This action attacks all factions' Militia and Police in the territory.

#### Special Action: Pacify

Terran Army action. This occurs on the turn it is announced. This action removes all Citizen units from the territory, of all factions.

#### Special Action: March

Terran Army action. This occurs on the turn it is announced. This action targets the nearest territory on the map that has player units and no Terran Army on it. The Terran Army is moved to that territory. Terran Army movements occur strictly after Police Move actions and Build commands.
