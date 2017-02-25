# Helios: Game Design Document (version B)

This document presents the main design of the game Helios.

## Elevator Pitch

Helios is basically a game of RISK where, instead of just being able to place units on your own zones, you can secretly and overtly build units over several turns in enemy provinces. To speed up the game, a voting system is in place to elect a winner, and turns are taken simultaneously. The game is made for 2-8 players, and is designed to last 30 minutes to 2 hours.

## The Objective

To win a game of Helios, you must win an Election to become the Ruler of Mars. This is done simply by winning an Election twice in a row. An Election is held every few turns, and counts votes cast by the players. Players get votes in proportion to their map control, which itself is gained via popular support, military action, and insurrection.

## Game Setup

To begin a game of Helios, 2-8 people open up a Helios client program on their device. One person needs to run the Helios server program and tell the other players the online address of the hosted game.

When players boot up a Helios client, they are greeted with a title screen and a prompt to connect to a game. The player puts in the address of the hosted game here, a username, and enters a lobby with other players waiting for the game to begin.

The lobby screen allows players to choose from among the factions they will play as in the game, a chatbox to converse in, a panel showing the game settings, a 'Quit' button, and a 'Ready' button. When all players have selected a unique faction to play and marked themselves as 'Ready', the game begins. 

When the host player boots up the Helios server, they are prompted to set the scenario, choose from some option toggles, set the game turn timer length, and a few other configuration details. The server should have sensible defaults for a typical 'I have friends at my house' social situation as well as a 'I am only playing with people on the internet' situation. The server will then run a Helios host, and tell the host player the online address of the hosted game, to share with others.

## The Gameplay Loop

Once the game is setup and hosted, the game scenario is loaded and the players are ready to play.

A map is presented to the player of Mars, which is divided up into provinces clearly labelled and outlined. The outlines of these provinces indicate which player controls it, and the player's own provinces are evident. Each province shows known Units and Units that are being recruited in the province, as well as an indicator of how strongly the player controls the province. At a glance from the map, the player can see the Turn Timer, an Information Panel, and a means by which to open up the main options menu (for adjusting graphics, sound, and save/load/exit functions).

The player can click on a province, and doing so causes the Information Panel to show additional information about the province: population, current status (peaceful/tense/riotous/revolt/rebellion), and a list of Build Buttons. The Build Buttons show their cost, the thing to be built, and whether the player can afford it. The player can press build buttons to expend Build Points, resulting in the Unit being queued for creation.

The player can click on Units on the map, and doing so causes the Information Panel to show additional information about the unit: size, description, strength, loyalty, and some statistics. Units that are being built show the number of turns until they are ready to be used. Units of your own that are 'in-stealth' indicate that they are hidden at the moment as well. Undiscovered units of other players are not shown on the map. A clicked unit belonging to the player also has several Command Buttons available. Clicking on a command button tells the unit what to do: setting mission, disbanding, or even triggering a Move Mode on the interactive map, where you can tell the unit where to move to.

At any given a moment, the player sees the map, known units, and graphical elements indicating what the Units are doing: a military unit marching to an adjacent province shows an arrow; a unit being created shows a progress bar; planned protests/demonstrations show a countdown-timer; investigative units show where they are looking for terrorists; and so on. Any of these units can be clicked on and assigned different orders or even cancel their current order. There is a big shiny toggle for 'Not Done/All Done' near the Timer bar, and the player can press this button to signal that they are done issuing commands.

The Timer bar shows who is still issuing commands. Players can toggle on/off their end-turn-readiness all the way until the Timer elapses or everyone is ready.

When the turn ends, the game map moves forward in time, animating commands' executions: timers tick down, military units move along their route, protests flare up, explosions happen, cheers erupt, etc. That is, between each player turn, players passively see the result of all their commands interacting with each other. It's important for the player's comprehension that the entire game map is shown during this period and there should be zoom-ins of important events.

On some turns, the players are required to vote in an Election. The Election is inserted between normal turns, and presents the player with a dialog to choose from amongst eligible players to become the Regent and who the Incumbent is. When all players have voted, a new screen is shown displaying who has become the new Regent. If the regent had been regent before, the Game Over/Win screen is shown instead. The Regent gets sole command of Military forces on the map.

## Helios Unit Types

There are several kinds of Units you can build in Helios, representing different forms of social and military power in Martian society.

### Government Forces

Mobile, Permanent, Legal. Loyal only to the Regent

### Local Police Forces & Local Militias

Immobile, Permanent, Legal. Impartial and Factional variants.

### Protests & Riots

Immobile, Temporary, and buildable in others' territory. Legal and Illegal variants.

### Terrorist cells

Immobile, Temporary, and stealthily buildable in other's territory. Can be 'converted' into a powerful ambush attack