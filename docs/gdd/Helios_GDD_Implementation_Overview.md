# Helios Implementational Overview

## Server

The server is responsible for maintaining a compressed GameState and a list of Orders issued by each player. After an expired time, the server halts Order issuing, processes the turn according to the game rules and the commands given, and then emits a renewed GameState to clients. The server is also used to coordinate the creation and closing of a game, and loading/saving state to disk for use later.

- [ ] Implemented with Node.js as a REST endpoint server
- [ ] Can keep track of a game session
	- [ ] Maintains a unique id for each player in a game session, and only allows them to submit requests
	- [ ] Saves gamestate to database
	- [ ] Can issue a secret-key to each player in the game to authenticate that their commands are *their* commands
	- [ ] Can emit a censored GameState to each player (hides secret information of other players')
	- [ ] Can accept authenticated Commands from each player for the current turn
	- [ ] Can emit a 'Turn End' event to each player so clients know a new turn has begun
	- [ ] Can emit a 'Turn End Resolution' event to each player so clients know what changes resulted from their commands
	- [ ] Can process a Turn End according to game rules
	- [ ] Can close out a game once completed
- [ ] Can keep track of clients' connection status and notify other players of dropout

## Client

The game client is responsible for displaying the GameState and currently-issued Orders to the player, and allowing the user to inspect, explore, and interact with the environment. The client emits order-queues to the Server, which can be undone/changed until the Turn has ended, at which point the client shows the new turn's state. The client is also responsible for replaying the resolution of last Turn's actions (unit conflicts, loyalty changes, etc).

- [ ] Can show a title screen with the option of hosting or joining a Helios Server, purchasing Premium, and showing Credits
- [ ] Can show a game lobby for a given game, allowing you change settings, chat with other players, and see who is 'ready'. Age of Empires III/90's old-school game lobby.
- [ ] Can present an in-game view
	- [ ] Can show a map of Mars, showing provinces, pieces, and their statuses and current commands. Also shows the levels of voter bloc support in each province. The map is pannable and can be clicked on to bring up extra information & commands.
	- [ ] Can show a status bar, which lets you see how much time is left in the turn, signal 'ready', or open up other views
	- [ ] Can show an inspector, which shows extra information about something clicked on the map
	- [ ] Can show a ledger, which shows extra information about the game as a whole (current electee, voting blocs, countdown, etc)
	- [ ] Can show a messenger, which lets you propose secret agreements to other players
	- [ ] Can show an electoral panel, which lets you vote in elections
	- [ ] Can show a main menu, for exiting/saving the game and changing your client settings
	- [ ] Can display the 'Turn End Resolution' changes on the map, using animations and movements of units & province re-coloring
- [ ] Can recover from a crash or disconnection and rejoin the game in-progress
