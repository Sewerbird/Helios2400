var players = []
var turnFinished = []

var turn = 0

function addPlayer(playerId) {
	players.push(playerId)
}

function finishTurn(playerId,changes,broadcast) {
	turnFinished.push({id: playerId, changes: changes})
	console.log("now %d out of %d have finished their turn",turnFinished.length, players.length)
	if(turnFinished.length == players.length){
		broadcast("SERVER\tTURN\t{turn: " + turn + "{" + turnFinished.join() + "}}");
		turn ++;
		turnFinished = [];
	}
}

module.exports = {
	finishTurn: finishTurn,
	addPlayer: addPlayer
}