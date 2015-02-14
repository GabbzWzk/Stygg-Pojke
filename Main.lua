---------------------
-- Main handler of the bot
--		This handler will be the Rotation handler and the main function for each pulse of the bot.
--		It is called by the core:BadRobotUpdate(self) every 10 ms
--		This is for all purpose the bot hearth where we define what we do each time it ticks
--------------------
main = {}
print("Main Handler Loaded")

function main:init()
	--should create and init all objects that should be used
	player.init()
	targets.init()
end	

function main:update()
	--should create and init all objects that should be used
	player.update()
	targets.update()
	
end	
	

function main:close()
	--should release all objects created by the main handler
	--player.close()
	--targets.close()
	
end	