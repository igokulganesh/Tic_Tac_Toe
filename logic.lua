-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

-- Set up display groups

local game = require("game")

local backGroup = display.newGroup()  -- Display group for the background image, Table
local mainGroup = display.newGroup()  -- Display group for the X and O 

local bg = display.newImageRect( backGroup,"Image/Orange_BG.jpg", 444, 794)
bg.x = display.contentCenterX
bg.y = display.contentCenterY

local function drawLine( x1, y1, x2, y2)
	local line = display.newLine( backGroup,
		display.contentCenterX + x1,  display.contentCenterY + y1, 
		display.contentCenterX + x2,  display.contentCenterY + y2 
	)
	line:setStrokeColor( 0, 0, 0, 1 )
	line.strokeWidth = 8
end

drawLine(-45, -130, -45, 130)
drawLine(45, -130, 45, 130)
drawLine(-130, -45, 130, -45)
drawLine(-130, 45, 130, 45)

local square = {}
for i = 1, 9, 1 do 
	square[i] = {val = 0, id = i }
end 

local function DrawXO(s, player)
	local xo 
	if(player == 1) then -- x
		xo = display.newImageRect( mainGroup, "Image/X_shape.png", 75, 75)
	else -- O
		xo = display.newImageRect( mainGroup, "Image/X.png", 75, 75)
	end
	xo.x = s.img.x
	xo.y = s.img.y
	
	local i =  math.floor((s.id-1)/3)
	local j = (s.id-1)%3 
	game.board[i][j] = player
	s.val = player
	game.move = game.move + 1
end

local function makeManMove(s)
		if( game.isP1Move and s.val == 0 )
		then 
			DrawXO(s, game.player1)
			game.isP1Move = false
		end

		if(game.isP1Move == false) 
		then
			local pos = game.getBestMove( game.player2, game.player1) + 1 
			DrawXO(square[pos], game.player2)
			game.isP1Move = true 	
		end
	return true
end

local function setSquare( x, y, s)
	s.img = display.newRect( display.contentCenterX + x, display.contentCenterY + y, 75, 75)
	s.img.alpha = 0.1
	s.img:addEventListener( "tap", function() makeManMove(s) end )
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



if( 3 < game.move and (game.isWinMove((game.isP1Move and game.player1 or game.player2 ))))
then
	game.status = (game.isP1Move and game.player1 or game.player2 ) 
end

if(game.status or game.move >= 9)
then
	local statusText = display.newText( game.status .. "wins", 1,  20 )
	statusText:setFillColor( 0, 0, 0 )
	statusText.x = display.contentCenterX
	statusText.y = display.contentCenterY
	mainGroup:insert( statusText )
end