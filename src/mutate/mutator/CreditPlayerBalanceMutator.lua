--CreditPlayerBalanceMutator.lua
local class = require 'lib/30log'
local Mutator = require 'src/mutate/Mutator'
local CreditPlayerBalanceMutator = Mutator:extend('CreditPlayerBalanceMutator', {
	target_city = nil,
	new_player_owner = nil,
	old_player_owner = nil
})

function CreditPlayerBalanceMutator:init ( player, amount)
	CreditPlayerBalanceMutator.super:init()
	self.player = player
	self.credit = amount
end

function CreditPlayerBalanceMutator:apply ( registry )

	--Update gsPlayer objects: set only the new player to 'current'
	local player = registry:find("GameInfo",{gs_type="player", player_name=self.player})
	for i, player in ipairs(registry:findAll("GameInfo", {gs_type="player"})) do
		player.cash_balance = player.cash_balance + self.credit
	end

	registry:publish("playerPaid",player,self.credit)

end

function CreditPlayerBalanceMutator:rollback ( registry )
	--Update gsPlayer objects: set only the new player to 'current'
	local player = registry:find("GameInfo",{gs_type="player", player_name=self.player})
	for i, player in ipairs(registry:findAll("GameInfo", {gs_type="player"})) do
		player.cash_balance = player.cash_balance - self.credit
	end

	registry:publish("playerPaid",player,-self.credit)
end

return CreditPlayerBalanceMutator