
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local buttonSound
local ismute

-- Handler that gets notified when the alert closes
local function onComplete( event )
    if ( event.action == "clicked" ) 
    then
        local i = event.index
        if ( i == 1 ) then
            os.exit()
        end
    end
end

--bcak button
function scene:key(event)
    
    -- handle the back key press however you choose
    if ( event.keyName == "back" ) then
    	-- Go to the menu screen
		local alert = native.showAlert( "Gg DevOps", "Do you want to exit", { "Yes", "No" }, onComplete )
    end
end

Runtime:addEventListener( "key", scene )

local function changeAudio()
	if(ismute == true) then 
		audio.setVolume( 0.3, { channel=1 } )
		ismute = false 
	else 
		audio.setVolume( 0, { channel=1 } )
		ismute = true
	end
end  

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

	ismute = false 

	local mute_ico = display.newImageRect( sceneGroup, "Image/unmute.png", 35, 35)
	mute_ico.x = display.contentCenterX-120
	mute_ico.y = display.contentCenterY+250

	mute_ico:addEventListener( "tap", changeAudio )

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
