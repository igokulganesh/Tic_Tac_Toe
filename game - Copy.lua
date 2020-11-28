local game = {}

game.move = 0 --Number of move currently 
game.status = 0 -- Game game.status -- 0 means not completed -- 1 means game.player1 wins -- 2 means game.player2 wins -- 3 means tied
game.player1 = 1
game.player2 = 2 --here game.player2 is computer
game.isP1Move = true -- is player 1 move -- TRUE
game.board = {} -- it is 2D array 3x3 matrix each 

function game.drawXO(s, player)
	local xo 
	if(player == 1) then -- x
		xo = display.newImageRect("Image/X_shape.png", 75, 75)
	else -- O
		xo = display.newImageRect("Image/X.png", 75, 75)
	end
	xo.x = s.img.x
	xo.y = s.img.y
	
	local i =  math.floor((s.id-1)/3)
	local j = (s.id-1)%3 
	game.board[i][j] = player
	s.val = player
	game.move = game.move + 1
end

function game.drawLine( x1, y1, x2, y2)
	local line = display.newLine(
		display.contentCenterX + x1,  display.contentCenterY + y1, 
		display.contentCenterX + x2,  display.contentCenterY + y2 
	)
	line:setStrokeColor( 0, 0, 0, 1 )
	line.strokeWidth = 8
end


local function isRowWin(val)
	for i = 0, 2, 1
	do
		if(game.board[i][0] == val and game.board[i][1] == val and game.board[i][2] == val)
		then 
			return true 
		end
	end
	return false
end

local function isColumnWin(val)
	for i = 0, 2, 1
	do 
		if(game.board[0][i] == val and game.board[1][i] == val and game.board[2][i] == val ) 
		then
			return true 
		end
	end
	return false
end

local function isDiagonalWin(val)
	if(game.board[0][0] == val and game.board[1][1] == val and game.board[2][2] == val) then
		return true
	end 

	if(game.board[0][2] == val and game.board[1][1] == val and game.board[2][0] == val) then 
		return true 
	end

	return false ; 
end

function game.isWinMove(val)
	return (isRowWin(val) or isColumnWin(val) or isDiagonalWin(val))
end

function game.isGameOver()

	if(game.move >= 9) then
		game.status = 3
	elseif(game.isP1Move == true and game.isWinMove(game.player2) ) then -- player2 is winner 
		game.status = game.player2
	elseif(game.isWinMove(game.player1)) then
		game.status = game.player1
	else
		return false 
	end

	return true 

end

local function makeWinMove(val, last)
	
	if(game.move < 3) then 
		return false 
	end

	for i = 0, 2, 1
	do
		for j = 0, 2, 1
		do
			if(game.board[i][j] == 0)
			then
				game.board[i][j] = val 
				if(isDiagonalWin(val) or isColumnWin(val) or isRowWin(val))
				then
					last[1] = (i*3)+j 
					return true 
				end
				game.board[i][j] = 0 
			end
		end
	end

	return false
end

local function makeDefenceMove(ours, opp, last)

	if(game.move < 3) then
		return false 
	end 

	for i = 0, 2, 1
	do 
		for j = 0, 2, 1
		do
			if(game.board[i][j] == 0)
			then
				game.board[i][j] = opp  
				if(isDiagonalWin(opp) or isColumnWin(opp) or isRowWin(opp))
				then
					last[1] = (i*3)+j 
					game.board[i][j] = ours  
					return true 
				end
				game.board[i][j] = 0  
			end
		end
	end
	return false 
end

local function attack(ours, opp, last)

	for i = 0, 2, 1
	do
		if(game.board[i][0] + game.board[i][1] + game.board[i][2] == ours and (game.board[i][0] == ours or game.board[i][1] == ours or game.board[i][2] == ours)) 
			-- row wise check if it contains 1 ours then make it 2 in row 
		then
			for j = 0, 2, 1
			do 
				if(game.board[i][j] == 0)
				then
					game.board[i][j] = ours 
					last[1] = (i*3)+j
					return true 
				end
			end
		end

		--same as above in column
		if(game.board[0][i] + game.board[1][i] + game.board[2][i] == ours and (game.board[0][i] == ours or game.board[1][i] == ours or game.board[2][i] == ours)) 
		then
			for j = 0, 2, 1
			do
				if(game.board[j][i] == 0)
				then
					game.board[j][i] = ours
					last[1] = (j*3)+i 
					return true 
				end
 			end
		end
	end

	-- again in diagonal 
	if(game.board[0][0] + game.board[1][1] + game.board[2][2] == ours and (game.board[0][0] == ours or game.board[1][1] == ours or game.board[2][2] == ours))
	then
		local i = 0
		local j = 0
		while (i < 3) and (j < 3)
		do
			if(game.board[i][j] == 0)
			then
				game.board[i][j] = ours
				last[1] = (i*3)+j
				return true 
			end
			i = i+1 
			j = j+1 
		end
	end

	if(game.board[0][2] + game.board[1][1] + game.board[2][0] == ours and (game.board[0][2] == ours or game.board[1][1] == ours or game.board[2][0] == ours))
	then
		local i = 0
		local j = 2
		while (i < 3) and (j >= 0)
		do
			if(game.board[i][j] == 0)
			then
				game.board[i][j] = ours  
				last[1] = (i*3)+j 
				return true 
			end
			i = i+1 
			j = j-1 
		end
	end

	return false ; 
end

function game.getBestMove(ours, opp)
	
	if(game.move == 0) -- random move
	then
		local i = math.random(0, 2)
		local j = math.random(0, 2)
		game.board[i][j] = ours
		return (i*3)+j ; 
	end

	local last = {0}

	if(makeWinMove(ours, last) == false) --check ours winning position and make it happen 
	then
		if(makeDefenceMove(ours, opp, last) == false) --check opponent's winning position then block them if any.
		then
			local corner =  game.board[0][0] + game.board[0][2] + game.board[2][0] + game.board[2][2]

			if(corner == ours+opp or corner == opp+(ours*2) and game.board[1][1] == 0)
			then
				for i = 0, 2, 2 -- trying to place any four corner
				do
					for j = 0, 2, 2
					do
						if(game.board[i][j] == 0)
						then
							game.board[i][j] = ours 
							return (i*3)+j ;
						end
					end
				end
			end

			if(game.board[1][1] == 0) -- trying to place centre 
			then
				game.board[1][1] = ours 
				return 4
			end

			if(attack(ours, opp, last) == false) -- trying to attack move 
			then
				for i = 0, 2, 1 -- trying to place anywhere possible
				do
					for j = 0, 2, 1
					do
						if(game.board[i][j] == 0)
						then
							game.board[i][j] = ours 
							return (i*3)+j
						end
					end
				end		
			end
		end
	end

	return last[1] 
end

return game 