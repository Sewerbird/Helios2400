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
		x = 2,
		y = 2
	} 
end

love.graphics.newImage = function() return 
	{
		getDimensions = function() 
			return 354, 292
		end,
		getWidth = function() 
			return 2
		end,
		getHeight = function() 
			return 2
		end
	}
end
