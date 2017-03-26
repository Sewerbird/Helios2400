# Helios: Game Design Document (version B)

This document presents the main design of the game Helios.

## Elevator Pitch

Helios is basically a game of RISK where, instead of just being able to place units on your own zones, you can secretly and overtly build units over several turns in enemy provinces. To speed up the game, a voting system is in place to elect a winner, and turns are taken simultaneously. The game is made for 2-8 players, and is designed to last 30 minutes to 2 hours.

## The Objective

To win a game of Helios, you must win an Election to become the Ruler of Mars. This is done simply by winning an Election twice in a row. An Election is held every few turns, and counts votes cast by the players. Players get votes in proportion to their map control, which itself is gained via popular support, military action, and insurrection.

## Starting a Game

### Gameplay Perspective

<TODO: Writeup about the strategy at game-start>

### UX Perspective

To begin a game of Helios, 2-8 people open up a Helios client program on their device. One person needs to run the Helios server program and tell the other players the online address of the hosted game.

When players boot up a Helios client, they are greeted with a title screen and a prompt to connect to a game. The player puts in the address of the hosted game here, a username, and enters a lobby with other players waiting for the game to begin.

The lobby screen allows players to choose from among the factions they will play as in the game, a chatbox to converse in, a panel showing the game settings, a 'Quit' button, and a 'Ready' button. When all players have selected a unique faction to play and marked themselves as 'Ready', the game begins. 

When the host player boots up the Helios server, they are prompted to set the scenario, choose from some option toggles, set the game turn timer length, and a few other configuration details. The server should have sensible defaults for a typical 'I have friends at my house' social situation as well as a 'I am only playing with people on the internet' situation. The server will then run a Helios host, and tell the host player the online address of the hosted game, to share with others.

### Code Perspective

<TODO: Writeup about the server-client architecture and how we keep everyone playing the same game>

## Playing The Game

### Gameplay Perspective

Once the players have chosen their faction to play, the game scenario is loaded and the players are ready to play.

The first thing that happens for the player is that they are presented with a map of the current situation: they will see that they control a part of the Martian surface, and see that some provinces are held more strongly than others. A timer is evident counting down, so the player needs to prioritize figuring out what actions are necessary to make 'good moves'.

The tricksome thing is that the player needs to anticipate other players' offensives at the same time as planning their own, so the player has to spend their political capitol wisely but under time pressure. Clicking on provinces, the player can see where they can start raising up support, and think about what kind of tactics best suit the province. 

	- Is it a homeland, where peaceful rallies are most useful for ensuring local support? 
	- Or is it a territory balancing between yourself and another player, where a successful protest would tilt public opinion your way? 
	- Or is it deep in your opponents' heartland, where a terrorist plot against a peaceful rally would help you polarize Martian society in your favor?

Another primary consideration is ensuring that your actions don't elevate the power of your rivals inadvertently: whenever you gain approval, rivals with similar voter blocs as you benefit as well. This can result in your work bolstering a rival too much, and perhaps gaining an electoral advantage over you. Many actions you can take are polarizing, and can solidify the opposition of voter blocs belonging to your rivals.

By quickly but wisely choosing which units to build and selecting from their capabilities when they are ready, the player can maximize their voter bloc's strength and minimize opposition. The player will want to use up all of their Political Power (conspicuously displayed on the screen) or bank some each turn, and when the player has done so they will find that their turn's orders are ready, and wait for other players to finish their turns as well.

The last thing that happens for the player on the turn is when all players are ready for the turn to end. At this point, order submission is halted, and the result of everyone's orders plays out on the map. This happens at a readable pace, so that the player can take in what has occurred and note who subverted, attacked, or supported their faction. Information learned from the events on the board should be taken into account when deciding who the most threatening and most supportive players are.

<TODO: writeup election gameplay>

### UX Perspective

Once the game is setup and hosted, the game scenario is loaded and the players are ready to play.

A map is presented to the player of Mars, which is divided up into provinces clearly labelled and outlined. The outlines of these provinces indicate which player controls it, and the player's own provinces are evident. Each province shows known Units and Units that are being recruited in the province, as well as an indicator of how strongly the player controls the province. At a glance from the map, the player can see the Turn Timer, an Information Panel, and a means by which to open up the main options menu (for adjusting graphics, sound, and save/load/exit functions).

The player can click on a province, and doing so causes the Information Panel to show additional information about the province: population, current status, political leanings, and a list of Build Buttons. The Build Buttons show their cost, the thing to be built, and whether the player can afford it. The player can press build buttons to expend Build Points, resulting in the Unit being queued for creation.

The player can click on Units on the map, and doing so causes the Information Panel to show additional information about the unit: size, description, strength, loyalty, and some statistics. Units that are being built show the number of turns until they are ready to be used. Units of your own that are 'in-stealth' indicate that they are hidden at the moment as well. Undiscovered units of other players are not shown on the map. A clicked unit belonging to the player also has several Command Buttons available. Clicking on a command button tells the unit what to do: setting mission, disbanding, or even triggering a Move Mode on the interactive map, where you can tell the unit where to move to.

At any given a moment, the player sees the map, known units, and graphical elements indicating what the Units are doing: a military unit marching to an adjacent province shows an arrow; a unit being created shows a progress bar; planned protests/demonstrations show a countdown-timer; investigative units show where they are looking for terrorists; and so on. Any of these units can be clicked on and assigned different orders or even cancel their current order. There is a big shiny toggle for 'Not Done/All Done' near the Timer bar, and the player can press this button to signal that they are done issuing commands.

The Timer bar shows who is still issuing commands. Players can toggle on/off their end-turn-readiness all the way until the Timer elapses or everyone is ready.

When the turn ends, the game map moves forward in time, animating commands' executions: timers tick down, military units move along their route, protests flare up, explosions happen, cheers erupt, etc. That is, between each player turn, players passively see the result of all their commands interacting with each other. It's important for the player's comprehension that the entire game map is shown during this period and there should be zoom-ins of important events.

On some turns, the players are required to vote in an Election. The Election is inserted between normal turns, and presents the player with a dialog to choose from amongst eligible players to become the Regent and who the Incumbent is. When all players have voted, a new screen is shown displaying who has become the new Regent. If the regent had been regent before, the Game Over/Win screen is shown instead. The Regent gets sole command of Military forces on the map.

### Code Perspective

<TODO: Describe main game loop requirements>

## Using Units

### Gameplay Perspective

There are several kinds of Units you can build in Helios, representing different forms of social and military power in Martian society.

#### Government Forces

Mobile, Permanent, Legal. Loyal only to the Regent.

##### Martian Marines

Martian marines are used to put down illegal factional militia and do so very efficiently: a Martian marine will attack all factional militia in its same province, and will almost always win. Martian marines always and only report to the current Regent, however they will still disband factional militia loyal to the Regent. Marines can move freely on the map once per turn. 

##### Martian Gendarme

Martian Gendarmes are used to put down riots in a province and do so very extremely effectively: if a Gendarme unit arrives in a province, they cancel all riots and dramatically reduce the impact of protests and rallies of the Regent's opposition. Gendarmes always and only report to the current Regent, but will stop riots caused by rioters loyal to the current Regent. Martian Gendarmes can move freely on the map once per turn.

##### Martian Counterterrorists

Martian Counterterrorists are used to root out terrorists and are the most effective unit to do so: if a counterterrorist arrives in a province, they disable the growth of terror cells and have a chance of revealing them. Although Martian Counterterrorists are always and only loyal to the current Regent, they perform their duties without predjudice: terror cells loyal to the Regent are just as likely to be discovered, and similarly curtailed. Martian Counterterrorists can move freely on the map once per turn.

#### Local Police Forces & Local Militias

Immobile, Permanent, Legal. Impartial and Factional variants.

##### State Police

State Police are always and only loyal to the current owner of a province, however they will never engage against any Martian government forces. State Police will fight all militia, protests, riots, and terrorists not loyal to the province's owner. State police are confined to a single province.

##### <Faction> Militia

Faction militia are always and only loyal to the player that built them, and are used to publically fight against State Police and Martian government forces. They act just like State Police, but do not switch sides when a province switches controller. Faction militia are confined to a single province. If a protest is scheduled in the militia's provine, the militia can 'join' it to turn it into a Factional Riot.

#### Protests, Riots, Parades, and Terror Attacks

Immobile, Temporary, and buildable in others' territory. Legal and Illegal variants. Take 2+ turns to create.

##### Peaceful Protests/Parades

Peaceful protests take 2 turns to build, and may be built in any province. The player declares a set of voter blocs to appeal to. The more blocs appealed to, the more moderating but reduced the effect of the protest will be. The fewer blocs appealed to, the more polarizing but impactful the protest will be. Protests are built publically, and only have an effect once built. Once built, they impact public opinion (in the area most, nearby less, and globally least). The protest then is 'done' and is removed from the map. 

A peaceful protest that aims at all voter blocs is instead called a Parade and moderates all voter blocs in the province, the most extreme blocs the most effectively.

A protest or parade can be joined on its extra day of building by any forces in the province. Forces that join the parade are locked to the province until the protest is built successfully or cancelled.

A protest can be cancelled on its extra build day at the organizer's prerogative.

##### Factional Riots

If a protest is joined by factional militias, it becomes a Factional Riot. This is not visible to other players until too late. First, a factional riot engages in a battle with any Government or State Police present: militias loyal to the Regent or province controller will side with the government & police, and militia who aren't will fight with the rioters (rioters providing a significant ally). If the riot wins, the province leader loses a great amount of legitimacy, and loses appropriate amounts of public support in the province and nearby: typically such that he loses support to another player. If the riot loses, the militias are generally greatly weakened, and public support for the province leader's faction increases.

##### Protest/Parade Bombing

When a protest is joined by a terrorist cell, it becomes subject to a Terror Attack. This is not visible to other players until too late, with one caveat: State Police and Martian Counterterrorists have an improved chance (lower and higher respectively) of discovering the terrorist cell the turn that it joins the protest. A terrorist caught joining a Parade doubly impacts the reputation of the faction it belongs to.

However, if State Police and Martian Counterterrorists do not detect the terrorist joining the protest, a horrible tragedy befalls the protest: a bomb goes off and kills or maims many people. Such an event strikes fear into the voter blocs the protest was 'for', reducing their support significantly in all provinces sympathetic to the terrorist faction.

If the protest successfully bombed was a Parade, the impact is deeply unsettling. Factional militia costs go down by -10% permanently for the terrorist's faction and parade organizer's faction, and up by +10% permanently for all other factions.

If a terrorist joins their own faction's protest or parade, the bombing becomes a False Flag. If discovered, the faction globally loses huge amounts of support in an all-but-game-losing manner. If undiscovered, in addition to the standard protest or parade bombing effects, terrorist cells grow 25% quicker for the false flagging faction and a single-turn boost of X power points to spend.

#### Terrorist Cells

Immobile, Temporary, and stealthily buildable in other's territory. Can be 'converted' into a powerful ambush attack

##### Insurgents

##### Sleeper Cell

### UX Perspective

<TODO: talk about how each kind of unit is presented on the map to interact with>

### Code Perspective

<TODO: talk about the code requirements for each unit and its internal states>

