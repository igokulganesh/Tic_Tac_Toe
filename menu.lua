
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local buttonSound

local musicText
local soundText

local function setMusic()
	audio.play( buttonSound, { channel=2}  )
	if(audio.getVolume( { channel=1 } ) == 0) 
	then
		audio.setVolume( 0.4, { channel=1 } )
		musicText.text = "Music ON"
	else 
		audio.setVolume( 0, { channel=1 } )
		musicText.text = "Music OFF"
	end
	return true
end  

local function setAudio()
	audio.play( buttonSound, { channel=2}  )
	if(audio.getVolume({channel=2}) == 0 ) then 
		audio.setVolume( 0.8, { channel=2 } )
		audio.setVolume( 0.9, { channel=3 } )
		soundText.text = "Audio ON"
	else 
		audio.setVolume( 0, { channel=2 } )
		audio.setVolume( 0, { channel=3 } )
		soundText.text = "Audio OFF"
	end
	return true
end  


local function gotoPlayWithAi()
	audio.play( buttonSound, { channel=2} )
	composer.gotoScene( "playWithAi", { time=800, effect="crossFade" } )
end

local function gotoPlayWithFriend()
	audio.play( buttonSound, { channel=2} )
	composer.gotoScene( "playWithFriend", { time=800, effect="crossFade" } )
end

-- Handler that gets notified when the alert closes
local function onComplete( event )
	audio.play( buttonSound, { channel=2}  )
    if ( event.action == "clicked" ) 
    then
        local i = event.index
        if ( i == 1 ) then
        	native.requestExit()
        end
    end
end

--bcak button
function scene:key(event)
    audio.play( buttonSound, { channel=2}  )
    -- handle the back key press however you choose
    if ( event.keyName == "back" ) then
    	-- Go to the menu screen
		local alert = native.showAlert( "Gg DevOps", "Are you sure you want quit?", { "No", "Yes" }, onComplete )
    end
end

Runtime:addEventListener( "key", scene )



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
 

	local sound = display.newImageRect( sceneGroup, "Image/unmute.png", 35, 35)
	sound.x = display.contentCenterX+120
	sound.y = display.contentCenterY+230

	soundText = display.newText( sceneGroup, 'Audio ON', 
		display.contentCenterX+120, display.contentCenterY+260, 
		native.systemFont, 12
	)
	soundText:setFillColor( 0, 0, 0 )

	sound:addEventListener( "tap", setAudio )
	soundText:addEventListener( "tap", setAudio )

	local music = display.newImageRect( sceneGroup, "Image/music.png", 35, 35)
	music.x = display.contentCenterX-120
	music.y = display.contentCenterY+230
	
	musicText = display.newText( sceneGroup, 'Music ON', 
		display.contentCenterX-120, display.contentCenterY+260, 
		native.systemFont, 12
	)
	musicText:setFillColor( 0, 0, 0 )
	
	music:addEventListener( "tap", setMusic )
	musicText:addEventListener( "tap", setMusic )

	setAudio()
	setMusic()
	setAudio()
	setMusic()
	
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
        local prevScene = composer.getSceneName( "previous" ) -- get the previous scene name, i.e. scene_game
        if(prevScene) then -- if the prevScene exists, then do something. This is only true when the player has went to the game scene
            composer.removeScene(prevScene) -- remove the previous scene so the player can play again
        end

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
		composer.removeScene( "menu" )
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
