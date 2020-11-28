
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local game = require("game")

-- initilize variables
local backGroup -- Display group for the background image, Table
local mainGroup -- Display group for the X and O 

local square

-- Handler that gets notified when the alert closes
local function onComplete( event )
    if ( event.action == "clicked" ) then
        local i = event.index
        if ( i == 1 ) then
            -- Restart
            composer.gotoScene( "playWithAi" )
        elseif ( i == 2 ) then
            -- Exit
            composer.gotoScene( "menu" )
        end
    end
end

local function gmaeOver()

--  local status = display.newText("", display.contentCenterX, display.contentCenterY, native.systemFont, 30)
-- 	status:setFillColor( 0, 0, 0 )

	local status 
	if(game.status == 1) then 
		status = "Your Won"
	elseif(game.status == 2) then
		status = "Computer Won"
	else
		status = "Match Tied"
	end

	local alert = native.showAlert( "Game Status", status, { "Restart", "Exit" }, onComplete )

end


local function makeManMove(s)

	if( game.isP1Move and s.val == 0 )
	then 
		game.drawXO(s, game.player1)
		game.isP1Move = false
	end

	if( game.isGameOver() ) then 
		gmaeOver()
	end

	if( game.isP1Move == false ) 
	then
		local pos = game.getBestMove( game.player2, game.player1) + 1 
		if(square[pos].val == 0) then 
			game.drawXO(square[pos], game.player2)
			game.isP1Move = true 
		end
	end

	if( game.isGameOver() ) then 
		gmaeOver()
	end

	return true
end

local function start()
	if(game.isP1Move == false) 
	then
		local pos = game.getBestMove( game.player2, game.player1) + 1 
		game.drawXO(square[pos], game.player2)
		game.isP1Move = true 	
	end
end 

function setSquare( x, y, s)
	s.img = display.newRect( backGroup,display.contentCenterX + x, display.contentCenterY + y, 75, 75)
	s.img.alpha = 0.1
	s.img:addEventListener( "tap", function() makeManMove(s) end )
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	backGroup = display.newGroup()  -- Display group for the background image, Table
    sceneGroup:insert( backGroup )  -- Insert into the scene's view group
 
    mainGroup = display.newGroup()  -- Display group for the X and O etc.
    sceneGroup:insert( mainGroup )  -- Insert into the scene's view group

    game.gameGroup = display.newGroup()
    sceneGroup:insert( game.gameGroup )

    -- Load the background
    local bg = display.newImageRect( backGroup,"Image/Orange_BG.jpg", 444, 794)
	bg.x = display.contentCenterX
	bg.y = display.contentCenterY

	-- drawing the board lines 
	game.drawLine(-45, -130, -45, 130)
	game.drawLine(45, -130, 45, 130)
	game.drawLine(-130, -45, 130, -45)
	game.drawLine(-130, 45, 130, 45)

	square = {}
	for i = 1, 9, 1 do
		square[i] = {val = 0, id = i }
	end 

	setSquare(-90, -90, square[1])
	setSquare(  0, -90, square[2])
	setSquare( 90, -90, square[3])
	setSquare(-90,   0, square[4])
	setSquare(  0,   0, square[5])
	setSquare( 90,   0, square[6])
	setSquare(-90,  90, square[7])
	setSquare(  0,  90, square[8])
	setSquare( 90,  90, square[9])

	game.move = 0 --Number of move currently 
	game.status = 0 -- Game game.status -- 0 means not completed -- 1 means game.player1 wins -- 2 means game.player2 wins -- 3 means tied
	game.player1 = 1
	game.player2 = 2 --here game.player2 is computer
	game.isP1Move = true -- is player 1 move -- TRUE
	game.board = {} -- 3x3 Board 

	for i = 0, 2, 1
	do
		game.board[i] = {} 
		for j = 0, 2, 1 do
			game.board[i][j] = 0
		end
	end
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		start()
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		backGroup:removeSelf()
		mainGroup:removeSelf()
		game.gameGroup:removeSelf()

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		

		composer.removeScene( "playWithAi" )


	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
