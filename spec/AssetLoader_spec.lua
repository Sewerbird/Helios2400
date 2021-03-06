inspect = require 'lib/inspect'
require 'spec/lovemock'
AssetLoader = require 'src/AssetLoader'

describe('AssetLoader', function ()

	it('should initialize correctly', function ()
		AssetLoader = AssetLoader:new()
		assert.truthy(AssetLoader)
	end)

	it('should load all correct assets', function ()
		AssetLoader = AssetLoader:new()
		AssetLoader:loadAssets("assets/spec/correct/")
	end)

	it('it can load correct assets', function ()
		AssetLoader = AssetLoader:new()
		assert.has_no.errors(function() 
			AssetLoader:loadAssets("assets/spec/correct/")
		end)
	end)

	it('it can retrieve an image', function ()
		AssetLoader = AssetLoader:new()
		AssetLoader:loadAssets("assets/spec/correct/")
		assert.has_no.errors(function() 
			local ast = AssetLoader:getAsset("TEST_ASSET_CORRECT_IMAGE")
			assert.True(ast ~= nil)
		end)
	end)

	it('it can retrieve an animation', function ()
		AssetLoader = AssetLoader:new()
		AssetLoader:loadAssets("assets/spec/correct/")
		assert.has_no.errors(function() 
			local ast = AssetLoader:getAsset("TEST_ASSET_CORRECT_ANIMATION")
			assert.True(ast ~= nil)
		end)
	end)

	it('it can retrieve an image sheet', function ()
		AssetLoader = AssetLoader:new()
		AssetLoader:loadAssets("assets/spec/correct/")
		assert.has_no.errors(function() 
			local ast = AssetLoader:getAsset("TEST_ASSET_CORRECT")
			assert.True(ast ~= nil)
		end)
	end)

	it('gives errors when image data is incorrect', function ()
		AssetLoader = AssetLoader:new()
		assert.has_error(function() 
			AssetLoader:loadAssets("assets/spec/wrongImage/") 
		end)
		
	end)

	it('gives errors when image sheet data is incorrect', function ()
		AssetLoader = AssetLoader:new()
		assert.has_error(function() 
			AssetLoader:loadAssets("assets/spec/wrongImageSheet/")
		end)
	end)

	it('gives errors when animation data is incorrect', function ()
		AssetLoader = AssetLoader:new()
		assert.has_error(function() 
			AssetLoader:loadAssets("assets/spec/wrongAnimation/")
		end)
	end)

	it('gives errors when asset id is not unique', function ()
		AssetLoader = AssetLoader:new()
		assert.has_error(function() 
			AssetLoader:loadAssets("assets/spec/wrongAssetId/")
		end)
	end)
end)