//GameState.js
var _ = require('lodash');

var terran_player = 0;

var game_commands = [
	{ 
		name: 'DO_NOTHING', 
		order: 0, 
		isLegal : function(command, currentTurnState, writeState){
			return true
		}, 
		execute: function(command, currentTurnState, writeState){
			console.log("Performing");
			return writeState;
		}
	},
	{ 
		name: 'BUILD_CITIZEN', 
		order: 1, 
		isLegal : function(command, currentTurnState, writeState){
			var terran_player = _.find(writeState.players, function(x){x.stats.faction == 'TERRAN_AI'});
			
			return writeState.players[command.player_id].stats.action_points >= 1 &&
			!_.some(currentTurnState.players[terran_player.player_id].pieces, function(x) { x.province_id == command.province_id}) &&
			command.turn_id == currentTurnState.turn;
		}, 
		execute: function(command, currentTurnState, writeState){
			console.log("Performing");
			return writeState;
		}
	},
	{ 
		name: 'PLAN_PROTEST', 
		order: 1, 
		isLegal : function(command, currentTurnState, writeState){
			var terran_player = _.find(writeState.players, function(x){x.stats.faction == 'TERRAN_AI'});

			return writeState.players[command.player_id].stats.action_points >= 1 &&
			!_.some(currentTurnState.players[terran_player.player_id].pieces, function(x) { x.province_id == command.province_id}) &&
			command.turn_id == currentTurnState.turn;
		}, 
		execute: function(command, currentTurnState, writeState){
			console.log("Performing");
			return writeState;
		}
	},
	{ 
		name: 'BUILD_MILITIA', 
		order: 1, 
		isLegal : function(command, currentTurnState, writeState){
			var terran_player = _.find(writeState.players, function(x){x.stats.faction == 'TERRAN_AI'});

			return writeState.players[command.player_id].stats.action_points >= 1 &&
			!_.some(currentTurnState.players[terran_player.player_id].pieces, function(x) { x.province_id == command.province_id}) &&
			command.turn_id == currentTurnState.turn;
		}, 
		execute: function(command, currentTurnState, writeState){
			console.log("Performing");
			return writeState;
		}
	},
	{ 
		name: 'BUILD_TERRORIST', 
		order: 2, 
		isLegal : function(command, currentTurnState, writeState){
			var terran_player = _.find(writeState.players, function(x){x.stats.faction == 'TERRAN_AI'});

			return writeState.players[command.player_id].stats.action_points >= 1 &&
			!_.some(currentTurnState.players[terran_player.player_id].pieces, function(x) { x.province_id == command.province_id}) &&
			command.turn_id == currentTurnState.turn;
		}, 
		execute: function(command, currentTurnState, writeState){
			console.log("Performing");
			return writeState;
		}
	},
	{ 
		name: 'BUILD_POLICE', 
		order: 2, 
		isLegal : function(command, currentTurnState, writeState){
			return writeState.players[command.player_id].stats.action_points >= 1 &&
			!_.some(currentTurnState.players[terran_player.player_id].pieces, function(x) { x.province_id == command.province_id}) &&
			command.turn_id == currentTurnState.turn
			return true
		}, 
		execute: function(command, currentTurnState, writeState){
			console.log("Performing");
			return writeState;
		}
	},
	{ 
		name: 'POLICE_MOVE', 
		order: 2, 
		isLegal : function(command, currentTurnState, writeState){
			return true
		}, 
		execute: function(command, currentTurnState, writeState){
			console.log("Performing");
			return writeState;
		}
	},
	{ 
		name: 'TERROR_ATTACK', 
		order: 3, 
		isLegal : function(command, currentTurnState, writeState){
			return true
		}, 
		execute: function(command, currentTurnState, writeState){
			console.log("Performing");
			return writeState;
		}
	},
	{ 
		name: 'MARTIAL_LAW', 
		order: 4, 
		isLegal : function(command, currentTurnState, writeState){
			return true
		}, 
		execute: function(command, currentTurnState, writeState){
			console.log("Performing");
			return writeState;
		}
	},
	{ 
		name: 'PERSECUTE', 
		order: 5, 
		isLegal : function(command, currentTurnState, writeState){
			return true
		}, 
		execute: function(command, currentTurnState, writeState){
			console.log("Performing");
			return writeState;
		}
	},
	{ 
		name: 'ARMY_INVADE', 
		order: 10, 
		isLegal : function(command, currentTurnState, writeState){
			return true
		}, 
		execute: function(command, currentTurnState, writeState){
			console.log("Performing");
			return writeState;
		}
	},
	{ 
		name: 'ARMY_PACIFY', 
		order: 11, 
		isLegal : function(command, currentTurnState, writeState){
			return true
		}, 
		execute: function(command, currentTurnState, writeState){
			console.log("Performing");
			return writeState;
		}
	},
	{ 
		name: 'ARMY_SUBJUGATE', 
		order: 12, 
		isLegal : function(command, currentTurnState, writeState){
			return true
		}, 
		execute: function(command, currentTurnState, writeState){
			console.log("Performing");
			return writeState;
		}
	},
	{ 
		name: 'ARMY_MOVE', 
		order: 13, 
		isLegal : function(command, currentTurnState, writeState){
			return true
		}, 
		execute: function(command, currentTurnState, writeState){
			console.log("Performing");
			return writeState;
		}
	},
	{ 
		name: 'VOTE', 
		order: 14, 
		isLegal : function(command, currentTurnState, writeState){
			return true
		}, 
		execute: function(command, currentTurnState, writeState){
			console.log("Performing");
			return writeState;
		}
	}
]

var a_sample_gamestate = {
	players : [
		{
			player_id : 0
			player_name : 'Edward',
			player_email : 'sewerbird@gmail.com',
			player_password : 'somepassword',
			stats : {
				faction_id : 0-8,
				action_points : 0-15
			},
			pieces : [
				{
					province_id : 0-15,
					citizens : 0-15,
					militia : 0-15,
					terrorist : 0-15,
					protest : 0-2,
					police : 0-15,
					army : 0-1
				}
				//, ...
			],
			pending_orders : [
				{
					turn_id : 0,
					command_id : 0-15,
					province_id : 0-15
				}
				//, ...
			]
		}
		//, ...
	]
}

function processTurn ( currentTurnState ) {

	//Process commands
	var afterCommandsState = _.chain(currentTurnState.players)
		.reduce(function(collation, x){
			var standalone_orders = _.map(x.pending_orders, function(y){
				y.player_id = x.player_id;
				y.stats = x.stats;
			})
			return collation.push(x.pending_orders);
		}, [])
		.flatten()
		.sortBy(function(x){
			return game_commands[x.command_id].resolution_order;
		})
		.tap(function handle_protests(state){
			return state
		})
		.tap(function handle_ai_move(state){
			return state
		})
		.reduce(function(newState, x){
			var rule = game_commands[x.command_id]

			if(rule.isLegal(x, currentTurnState, newState)){
				return rule.execute(x, currentTurnState, newState)
			}
			else return newState

		}, _.cloneDeep(currentTurnState))
		.tap(function handle_vote(state){
			return state
		})
		.value();


	return finalState;
}