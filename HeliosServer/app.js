var express = require('express')
var app = express()

var State = {
	'default' : {
		current_turn : 0,
		turns : [
			{
				init_state : {
					players : {
						player_1 : {
							name : "Edward",
							is_regent : true,
							bloc_affinity: "bloc_1"
						},
						player_2 : {
							name : "Ian",
							is_regent : false,
							bloc_affinity: "bloc_2"
						}
					},
					provinces : {
						province_1 : {
							name : "Marianis",
							blocs : {
								bloc_1 : {
									population : 100,
									morale : 0.85
								},
								bloc_2 : {
									population : 3,
									morale : 0.25
								}
							},
							units : [
									/*
										Type:
											FACTION_PROTEST = 1
											FACTION_TERRORIST = 2
											FACTION_MILITIA = 3
											PROVINCE_TROOPERS = 4
											REGENT_GENDARME = 5
											REGENT_COUNTERTERRORIST = 6
											REGENT_MARINES = 7
										Controller:
											DYNAMIC = 0
											PLAYER_1 = 1
											PLAYER_2 = 2
											PLAYER_3 = 3
											...
											PLAYER_7 = 7
										Province: 0x00-0xFF
										State: 
											DEAD = 0
											BEING_BUILT = 1
											IDLE = 2
										Size:
											0 - 1024
									*/
								{
									//0x31011064
									type : "FACTION_MILITIA",
									player : "player_1",
									number : 100,
									state : "BEING_BUILT",
									location : "province_1"
								},
								{
									//0x500123E8
									type : "MARTIAN_GENDARME",
									player : "Regent",
									number : 1000,
									state : "IDLE",
									location : "province_1"
								},
								{
									//0x22012003
									type : "FACTION_TERRORIST",
									player : "player 2",
									number : 3,
									state : "IDLE",
									location : "province_1"
								}
							]
						}
					}
				},
				commands : {
					player_1 : ["BUILD_PROTEST IN PROVINCE_1 FOR BLOC_1 AND BLOC_2 PAY 10PP"],
					player_2 : []
				}
			}
		]
	}
}
State.getGame = function(game_id){
	return State[game_id]
}
State.setState = function(game_id, state){
	State[game_id] = state
}

app.post('/game/new', function (req, res) {
	res.send('Hosting a new game with id \'default\'')
})

app.post('/game/:game_id/end_game', function (req, res) {
	var gameID = req.params.game_id
	res.send('Closing game with id ' + gameID)
})

app.post('/game/:game_id/turn/:turn_id/unend_turn', function (req, res){
	var turnID = req.params.turn_id
	var gameID = req.params.game_id
	if(turnID == State.getGame(gameID).current_turn)
	{
		res.send('Your end-turn has been repealed.')
	}
	else
	{
		res.send('Sorry, but the turn you are trying to stay in has been completed already. Current turn is ' + turnID)
	}
})
app.post('/game/:game_id/turn/:turn_id/end_turn', function (req, res) {
	var turnID = req.params.turn_id
	var gameID = req.params.game_id
	if(turnID == State.getGame(gameID).current_turn)
	{
		res.send('Your end-turn has been signalled.')
	}
	else
	{
		res.send('Sorry, but you are signalling an end turn for a turn that has been completed already. Current turn is ' + turnID)
	}
})

app.post('/game/:game_id/turn/:turn_id/issue_command', function (req, res) {
	var turnID = req.params.turn_id
	var gameID = req.params.game_id
	if(turnID == State.getGame(gameID).current_turn)
	{
		res.send('Thanks for your posted commands. You may repost (overriding) until the turn compiles')
	}
	else
	{
		res.send('Sorry, but you have issued commands for a turn that has been completed already. Current turn is ' + turnID)
	}
})

app.get('/game/:game_id/current_turn', function (req, res) {
	var gameID = req.params.game_id
	res.send('The game is currently on turn ' + State.getGame(gameID).current_turn)
})

app.get('/game/:game_id/turn/:turn_id/state', function (req, res) {
	var turnID = req.params.turn_id
	var gameID = req.params.game_id
	res.send('Game state for turn ' + turnID + ' is {}')
})

app.get('/game/:game_id/turn/:turn_id/commands', function (req, res) {
	var turnID = req.params.turn_id
	var gameID = req.params.game_id
	if(turnID == State.getGame(gameID).current_turn)
	{
		res.send('Commands for turn ' + turnID + ' are not published yet')
	}
	else
	{
		res.send('The commands for turn ' + turnID + ' were [].')
	}
})

app.listen(3000, function() {
	console.log('HeliosServer listening on port 3000!')
})
