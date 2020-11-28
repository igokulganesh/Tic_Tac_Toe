
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local buttonSound

local function gotoPlayWithAi()
	audio.play( buttonSound )
	composer.gotoScene( "playWithAi", { time=800, effect="crossFade" } )
end

local function gotoPlayWithFriend()
	audio.play( buttonSound )
	composer.gotoScene( "playWithFriend", { time=800, effect="crossFade" } )
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	local background = display.newImageRect( sceneGroup, "Image/Orange_BG.jpg", 444, 794)
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	
	local title = display.newText(sceneGroup, "Tic Tac Toe", display.contentCenterX, 100, "Text/Bangers.ttf", 50)
	title:setFillColor( 0.82, 0.86, 1 )

	local playWithAi = display.newText( sceneGroup, "Play with Computer", display.contentCenterX, 200, "Text/Bangers.ttf", 24)
	playWithAi:setFillColor( 0, 0, 0 )

	local playWithFriend = display.newText( sceneGroup, "Play with Friend", display.contentCenterX, 250, "Text/Bangers.ttf", 24 )
	playWithFriend:setFillColor( 0, 0, 0 )


    buttonSound = audio.loadSound( "audio/buttonSound.mp3" ) 

	playWithAi:addEventListener( "tap", gotoPlayWithAi )
	playWithFriend:addEventListener( "tap", gotoPlayWithFriend )
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
        --audio.play( musicTrack, { channel=1, loops=-1 } )
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

		-- Stop the music!
        --audio.stop( 1 )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

	--audio.dispose( musicTrack )
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
