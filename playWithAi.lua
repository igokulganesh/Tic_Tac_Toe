
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- initilize variables
local backGroup -- Display group for the background image, Table
local mainGroup -- Display group for the X and O 
local boxGroup -- for square


local move = 0 --Number of move currently 
local status = 0 -- Game status -- 0 means not completed -- 1 means player1 wins -- 2 means player2 wins -- 3 means tied
local player1 = 1
local player2 = 2 --here player2 is computer
local board = {} -- it is 2D array 3x3 matrix each 
local square = {} -- it is a 1D array 1-9 matrix 
local scoreP1 = 0
local scoreP2 = 0
local startPlayer = false -- is player 1 move 
local isP1Move = false -- is player 1 move -- TRUE
local turnText -- Turn text 

local tapSound 
local winSound 
local buttonSound
local backButton
local restartButton


-- function 
local restart 
local removelistener

local function gotoMenu()  
	audio.play( buttonSound, { channel=2}  )
	composer.gotoScene( "menu" )
end 


local function gotoRestart()
	audio.play( buttonSound, { channel=2}  )
	removelistener()
	scene:create()
end

--bcak button
function scene:key(event)
    
    -- handle the back key press however you choose
    if ( event.keyName == "back" ) then
    	-- Go to the menu screen
		if ( system.getInfo("platform") == "android" ) then
            return true
        end
    end
end


--util function 
local function setTurn(var) -- true means 1st player 
	if(var == true)
	then
		turnText.text = "Your Turn"
		turnText.x = display.contentCenterX-90
		turnText.y = display.contentCenterY+230
	else
		turnText.text = "Computer Turn"
		turnText.x = display.contentCenterX+90
		turnText.y = display.contentCenterY+230
	end
end

local function drawXO(s, player)

	local xo 
	if(player == 1) then -- x
		xo = display.newImageRect( mainGroup, "Image/xBlue.png", 75, 75)
	else -- O
		xo = display.newImageRect( mainGroup, "Image/xPink.png", 75, 75)
	end
	xo.x = s.img.x
	xo.y = s.img.y
	
	local i =  math.floor((s.img.id-1)/3)
	local j = (s.img.id-1)%3 
	board[i][j] = player
	s.val = player
	move = move + 1
end

local function drawLine( x1, y1, x2, y2)
	local line = display.newLine( backGroup, 
		display.contentCenterX + x1,  display.contentCenterY + y1, 
		display.contentCenterX + x2,  display.contentCenterY + y2 
	)
	line:setStrokeColor( 0, 0, 0, 1 )
	line.strokeWidth = 8
end

-- logic funtion
local function isRowWin(val)
	for i = 0, 2, 1
	do
		if(board[i][0] == val and board[i][1] == val and board[i][2] == val)
		then 
			return true 
		end
	end
	return false
end

local function isColumnWin(val)
	for i = 0, 2, 1
	do 
		if(board[0][i] == val and board[1][i] == val and board[2][i] == val ) 
		then
			return true 
		end
	end
	return false
end

local function isDiagonalWin(val)
	if(board[0][0] == val and board[1][1] == val and board[2][2] == val) then
		return true
	end 

	if(board[0][2] == val and board[1][1] == val and board[2][0] == val) then 
		return true 
	end

	return false ; 
end

local function isWinMove(val)
	return (isRowWin(val) or isColumnWin(val) or isDiagonalWin(val))
end

local function isGameOver()

	if(isP1Move == true and isWinMove(player2) ) then -- player2 is winner 
		status = player2
	elseif(isWinMove(player1)) then
		status = player1
	elseif(move >= 9) then
		status = 3
	else
		return false 
	end

	return true 
end

local function makeWinMove(val, last)
	
	if(move < 3) then 
		return false 
	end

	for i = 0, 2, 1
	do
		for j = 0, 2, 1
		do
			if(board[i][j] == 0)
			then
				board[i][j] = val 
				if(isDiagonalWin(val) or isColumnWin(val) or isRowWin(val))
				then
					last[1] = (i*3)+j 
					return true 
				end
				board[i][j] = 0 
			end
		end
	end

	return false
end

local function makeDefenceMove(ours, opp, last)

	if(move < 3) then
		return false 
	end 

	for i = 0, 2, 1
	do 
		for j = 0, 2, 1
		do
			if(board[i][j] == 0)
			then
				board[i][j] = opp  
				if(isDiagonalWin(opp) or isColumnWin(opp) or isRowWin(opp))
				then
					last[1] = (i*3)+j 
					board[i][j] = ours  
					return true 
				end
				board[i][j] = 0  
			end
		end
	end
	return false 
end

local function attack(ours, opp, last)

	for i = 0, 2, 1
	do
		if(board[i][0] + board[i][1] + board[i][2] == ours and (board[i][0] == ours or board[i][1] == ours or board[i][2] == ours)) 
			-- row wise check if it contains 1 ours then make it 2 in row 
		then
			for j = 0, 2, 1
			do 
				if(board[i][j] == 0)
				then
					board[i][j] = ours 
					last[1] = (i*3)+j
					return true 
				end
			end
		end

		--same as above in column
		if(board[0][i] + board[1][i] + board[2][i] == ours and (board[0][i] == ours or board[1][i] == ours or board[2][i] == ours)) 
		then
			for j = 0, 2, 1
			do
				if(board[j][i] == 0)
				then
					board[j][i] = ours
					last[1] = (j*3)+i 
					return true 
				end
 			end
		end
	end

	-- again in diagonal 
	if(board[0][0] + board[1][1] + board[2][2] == ours and (board[0][0] == ours or board[1][1] == ours or board[2][2] == ours))
	then
		local i = 0
		local j = 0
		while (i < 3) and (j < 3)
		do
			if(board[i][j] == 0)
			then
				board[i][j] = ours
				last[1] = (i*3)+j
				return true 
			end
			i = i+1 
			j = j+1 
		end
	end

	if(board[0][2] + board[1][1] + board[2][0] == ours and (board[0][2] == ours or board[1][1] == ours or board[2][0] == ours))
	then
		local i = 0
		local j = 2
		while (i < 3) and (j >= 0)
		do
			if(board[i][j] == 0)
			then
				board[i][j] = ours  
				last[1] = (i*3)+j 
				return true 
			end
			i = i+1 
			j = j-1 
		end
	end

	return false ; 
end

local function getBestMove(ours, opp)
	
	if(move == 0) -- random move
	then
		local i = math.random(0, 2)
		local j = math.random(0, 2)
		board[i][j] = ours
		return (i*3)+j ; 
	end

	local last = {0}

	if(makeWinMove(ours, last) == false) --check ours winning position and make it happen 
	then
		if(makeDefenceMove(ours, opp, last) == false) --check opponent's winning position then block them if any.
		then
			local corner =  board[0][0] + board[0][2] + board[2][0] + board[2][2]

			if(corner == ours+opp or corner == opp+(ours*2) and board[1][1] == 0)
			then
				for i = 0, 2, 2 -- trying to place any four corner
				do
					for j = 0, 2, 2
					do
						if(board[i][j] == 0)
						then
							board[i][j] = ours 
							return (i*3)+j ;
						end
					end
				end
			end

			if(board[1][1] == 0) -- trying to place centre 
			then
				board[1][1] = ours 
				return 4
			end

			if(attack(ours, opp, last) == false) -- trying to attack move 
			then
				for i = 0, 2, 1 -- trying to place anywhere possible
				do
					for j = 0, 2, 1
					do
						if(board[i][j] == 0)
						then
							board[i][j] = ours 
							return (i*3)+j
						end
					end
				end		
			end
		end
	end

	return last[1] 
end

restart = function()
	removelistener()
	scene:create()
end

local function option(title)

	local gameOverBackground = display.newRect(mainGroup, 0, 0, display.actualContentWidth, display.actualContentHeight) -- display an opaque background graphic for some game over polish
    gameOverBackground.x = display.contentCenterX
    gameOverBackground.y = display.contentCenterY
    gameOverBackground:setFillColor(0)
    gameOverBackground.alpha = 0.5

    -- Create a text object that will display game over text
    local gameOverText = display.newText( mainGroup, title, 100, 200, "Text/Bangers.ttf", 40 )
    gameOverText.x = display.contentCenterX
    gameOverText.y = display.contentCenterY-200
    gameOverText:setFillColor( 1, 1, 1 ) 

    timer.performWithDelay( 2500, restart )

end

local function restart()
	
	if(backGroup) then 
		backGroup:removeSelf()
	end 
	
	if(mainGroup) then 
		mainGroup:removeSelf()
	end 
		
	if(boxGroup) then 
		boxGroup:removeSelf()
	end 

	scene:create()
end

local function gameOver()

	removelistener()

	local gameStatus 
	if(status == 1) then 
		scoreP1 = scoreP1 + 1 
		gameStatus = "Congrats, You Won"
	elseif(status == 2) then
		scoreP2 = scoreP2 + 1 
		gameStatus = "Computer Won"
	else 
		gameStatus = "Match Tied"
	end

	audio.play( winSound, { channel=3} )

	option(gameStatus)
end

local function makeManMove(event)
	
	local s = square[event.target.id] 
	setTurn(isP1Move)

	if( isP1Move and s.val == 0 )
	then 
		audio.play( tapSound, { channel=2} )
		drawXO(s, player1)
		isP1Move = false
	end

	if( isGameOver() ) then 
		gameOver()
	end

	setTurn(false)
	if( isP1Move == false ) 
	then
		local pos = getBestMove( player2, player1) + 1 
		if(square[pos].val == 0) then 
			drawXO(square[pos], player2)
			isP1Move = true 
		end
	end

	setTurn(true)

	if( isGameOver() ) then 
		gameOver()
	end

	return true
end

local function start()
	setTurn(isP1Move)
	if(isP1Move == false) 
	then
		local pos = getBestMove( player2, player1) + 1 
		drawXO(square[pos], player2)
		isP1Move = true 	
	end
end 

removelistener = function ()

	for i=1, 9, 1 do                
		square[i].img:removeEventListener("tap", makeManMove)               
    end

	backButton:removeEventListener( "tap", gotoMenu)
	restartButton:removeEventListener( "tap", gotoRestart )

end

local function setSquare( x, y, s, i)
	s.img = display.newRect( boxGroup, display.contentCenterX + x, display.contentCenterY + y, 75, 75)
	s.img.id = i
	s.val = 0
	s.img.alpha = 0.01
	s.img:addEventListener( "tap", makeManMove )
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
 
    boxGroup = display.newGroup()  -- Display group for sqaure
    sceneGroup:insert( boxGroup )  -- Insert into the scene's view group

    mainGroup = display.newGroup()  -- Display group for the X and O etc.
    sceneGroup:insert( mainGroup )  -- Insert into the scene's view group

    -- Load the background
    local bg = display.newImageRect( backGroup,"Image/Orange_BG.jpg", 444, 794)
	bg.x = display.contentCenterX
	bg.y = display.contentCenterY

	backButton = display.newImageRect( backGroup,"Image/back.png", 30, 30)
	backButton.x = display.contentCenterX - 140
	backButton.y = display.contentCenterY - 250
	
	restartButton = display.newImageRect( backGroup,"Image/restart.png", 35, 35)
	restartButton.x = display.contentCenterX + 140
	restartButton.y = display.contentCenterY - 250

	backButton:addEventListener( "tap", gotoMenu ) 
	restartButton:addEventListener( "tap", gotoRestart )

	-- drawing the board lines 
	drawLine(-45, -150, -45, 110)
	drawLine(45, -150, 45, 110)
	drawLine(-130, -65, 130, -65)
	drawLine(-130, 25, 130, 25)

	square = {}
	for i = 1, 9, 1 do
		square[i] = {val = 0}
	end 

	setSquare(-90, -110, square[1], 1)
	setSquare(  0, -110, square[2], 2)
	setSquare( 90, -110, square[3], 3)
	setSquare(-90, -20, square[4],  4)
	setSquare(  0, -20, square[5],  5)
	setSquare( 90, -20, square[6],  6)
	setSquare(-90,  70, square[7],  7)
	setSquare(  0,  70, square[8],  8)
	setSquare( 90,  70, square[9],  9)

	local p1 = display.newImageRect( backGroup,"Image/BlueMan.png", 80, 80)
	p1.x = display.contentCenterX - 90  
	p1.y = display.contentCenterY + 180


	local p2 = display.newImageRect( backGroup,"Image/PinkMan.png", 80, 80)
	p2.x = display.contentCenterX + 90  
	p2.y = display.contentCenterY + 180

	local scoreP1Text = display.newText( mainGroup, scoreP1, display.contentCenterX - 90,display.contentCenterY+200, "Text/Bangers.ttf", 24)
	scoreP1Text:setFillColor( 0, 0, 0 )
	local scoreP2Text = display.newText( mainGroup, scoreP2, display.contentCenterX + 90, display.contentCenterY+200, "Text/Bangers.ttf", 24)
	scoreP2Text:setFillColor( 0, 0, 0 )

	turnText = display.newText( mainGroup, "", 0, 0, "Text/Bangers.ttf", 24)
	turnText:setFillColor( 0, 0, 0 )


	move = 0 --Number of move currently 
	status = 0 -- Game status -- 0 means not completed -- 1 means player1 wins -- 2 means player2 wins -- 3 means tied
	player1 = 1
	player2 = 2 --here player2 is computer
	board = {} -- 3x3 Board 

	for i = 0, 2, 1
	do
		board[i] = {} 
		for j = 0, 2, 1 do
			board[i][j] = 0
		end
	end

	if(startPlayer) then 
		isP1Move = false 
		startPlayer = false
	else 
		isP1Move = true
		startPlayer = true
	end

    tapSound = audio.loadSound( "audio/tapSound.mp3" ) 
    buttonSound = audio.loadSound( "audio/buttonSound.mp3" ) 
    winSound = audio.loadSound( "audio/winSound.mp3" ) 

	setTurn(isP1Move)
	Runtime:addEventListener( "key", scene )	

	start()

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		-- Start the music!
	    local prevScene = composer.getSceneName( "previous" ) -- get the previous scene name, i.e. scene_game
        if(prevScene) then -- if the prevScene exists, then do something. This is only true when the player has went to the game scene
            composer.removeScene(prevScene) -- remove the previous scene so the player can play again
        end
		start()
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

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
