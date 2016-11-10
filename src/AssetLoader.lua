require "lib/Tserial"
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
	for i,v in ipairs(spriteSheet.data) do
		self:loadSprite(v,spriteSheet.assetId)
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