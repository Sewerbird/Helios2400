var NewGame = {
	current_turn: 0,
	players: [], // holds basic info about the users
	lobbyName: 'TEST_LOBBY',
	scenarioName: 'TEST_SCENARIO',
	game: {}, 		// info about the gamestate
	turnFinished: [] // list of all changes the players are going to make this turn.
}

function getGameSummary(){
	return JSON.stringify(NewGame)
}

function removePlayer(playerId, broadcast) {
	for(var i = 0; i < NewGame.players.length ; i++){
		if(NewGame.players[i].id != playerId){
			continue;
		}
		NewGame.players.splice(i,1);
		broadcast('SERVER\tLOBBY\t' + getGameSummary())
		return
	}
}

function addPlayer(playerId,broadcast) {
	NewGame.players.push({
		id: playerId,
		ready: false,
		color: {r: 255,g: 0,b: 0},
		team: 'RED'
	})
	broadcast('SERVER\tLOBBY\t' + getGameSummary())
}

function finishTurn(playerId,changes,broadcast) {
	NewGame.turnFinished.push({id: playerId, changes: changes})
	console.log("now %d out of %d have finished their turn",NewGame.turnFinished.length, players.length)
	if(NewGame.turnFinished.length == players.length){
		broadcast("SERVER\tTURN\t{turn: " + turn + "{" + NewGame.turnFinished.join() + "}}");
		turn ++;
		NewGame.turnFinished = [];
	}
}

module.exports = {
	finishTurn: finishTurn,
	addPlayer: addPlayer,
	removePlayer: removePlayer
}