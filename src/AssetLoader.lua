require "lib/Tserial"
local anim8 = require "lib/anim8"
local class = require 'lib/30log'

local AssetLoader = class("AssetLoader", {
	assets = {},
	rootPath = "assets/",
	errorPrefix = "ERROR: "
})

function AssetLoader:loadAssets()
	for i,v in ipairs(love.filesystem.getDirectoryItems(self.rootPath)) do
		if self.isAsset(v) then
			local filePath = self.rootPath .. v
			print("loading asset", filePath)
			local asset = Tserial.unpack(love.filesystem.read(filePath),true)
			self:loadAsset(asset)
		end
	end
end

function AssetLoader:loadAsset(asset)
	if(asset.assetId == nil) then print(self.errorPrefix .. " asset is missing assetId") return end
	if(asset.assetType == nil) then print(self.errorPrefix .. " asset is missing assetType") return end
	
	if self.assets[asset.assetId] ~= nil then 
		print(self.errorPrefix.. "assetId " .. asset.assetId .. " is not unique")
		return
	end

	if asset.assetType == "spriteSheet" then 
		self:loadSpriteSheet(asset)
		return
	end
	if asset.assetType == "sprite" then 
		self:loadSprite(asset)
		return
	end
	if asset.assetType == "audio" then 
		self:loadAudio(asset)
		return
	end
	print(self.errorPrefix .. "incorrect asset type " .. asset.assetType " for " .. asset.assetId)
end

function AssetLoader:loadSpriteSheet(spriteSheet)
	self.assets[spriteSheet.assetId] = love.graphics.newImage(self.rootPath .. spriteSheet.assetPath)
	for i,asset in ipairs(spriteSheet.data) do
		if asset.assetType == "sprite" then
			self:loadSprite(asset,spriteSheet.assetId)
		elseif asset.assetType == "animation" then
			self:loadAnimation(asset,spriteSheet.assetId)
		else
			print(self.errorPrefix .. "incorrect asset type " .. asset.assetType " for " .. asset.assetId .. " in spritesheet " .. spriteSheet.assetId)
		end
	end
end

function AssetLoader:loadSprite(sprite,spriteSheetId)
	if(sprite.width == nil) then print(self.errorPrefix .. " sprite width is not defined for " .. sprite.assetId) return end
	if(sprite.height == nil) then print(self.errorPrefix .. " sprite height is not defined for " .. sprite.assetId) return end
	local spriteSheet = self:getAsset(spriteSheetId)
	self.assets[sprite.assetId] = Sprite:new(
		spriteSheet, 
		love.graphics.newQuad(
			sprite.x or 0, 
			sprite.y or 0, 
			sprite.width, 
			sprite.height, 
			spriteSheet:getDimensions()
		)
	)
end

function AssetLoader:loadAnimation(animation,spriteSheetId)
	print("loading animation " .. animation.assetId)

	if(animation.frameWidth == nil) then print(self.errorPrefix .. " animation frameWidth is not defined for " .. animation.assetId) return end
	if(animation.frameHeight == nil) then print(self.errorPrefix .. " animation frameHeight is not defined for " .. animation.assetId) return end
	if(animation.amountOfFrames == nil) then print(self.errorPrefix .. " animation amountOfFrames is not defined for " .. animation.assetId) return end
	if(animation.frameTime == nil) then print(self.errorPrefix .. " animation frameTime is not defined for " .. animation.assetId) return end

	local spriteSheet = self:getAsset(spriteSheetId)

	local grid = anim8.newGrid(animation.frameWidth,animation.frameHeight,spriteSheet:getWidth(), spriteSheet:getHeight(), animation.x or 0, animation.y or 0)
	local anim = anim8.newAnimation(grid('1-'..animation.amountOfFrames, 1),{['1-'..animation.amountOfFrames]=animation.frameTime})
	
	self.assets[animation.assetId] = Animation:new(anim, spriteSheet)
end

function AssetLoader:loadAudio(audio)
	self.assets[audio.assetId] = love.audio.newSource(self.rootPath .. audio.assetPath)
end

function AssetLoader.isAsset(String)
   return ".asset"=='' or string.sub(String,-string.len(".asset"))==".asset"
end

function AssetLoader:getAsset(assetId)
	if self.assets[assetId] == nil then 
		print(self.errorPrefix .. assetId .. " is not loaded or incorrect")
	end

	return self.assets[assetId]
end

function AssetLoader:printAllAssets()
	print("Assets:")
	for k,v in pairs(self.assets) do
		print("\t- \"" .. k .. "\"",v)
	end
end

return AssetLoader