love = {}

love.filesystem = {}

love.filesystem.getDirectoryItems = function(filePath)
	local result = {}
	table.insert(result,"asset.asset")
	return result
end

love.filesystem.read = function(filePath)
	local f = io.open(filePath, "rb")
    local content = f:read("*all")
    f:close()
    return content
end

love.graphics = {}

love.graphics.newQuad = function() 
	return {
		x = 354,
		y = 292
	} 
end

love.graphics.newImage = function() return 
	{
		getDimensions = function() 
			return 354, 292
		end,
		getWidth = function() 
			return 354
		end,
		getHeight = function() 
			return 292
		end
	}
end
