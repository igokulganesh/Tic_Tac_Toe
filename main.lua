-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
 
-- Hide status bar
display.setStatusBar( display.HiddenStatusBar )
 
-- Seed the random number generator
math.randomseed( os.time() )

-- Reserve channel 1 for background music
audio.reserveChannels( 3 )
-- Reduce the overall volume of the channel
local bgMusic = audio.loadStream( "audio/bgMusic.mp3" )
audio.setVolume( 0.4, { channel=1 } )
audio.setVolume( 0.8, { channel=2 } )
audio.setVolume( 0.9, { channel=3 } )
audio.play( bgMusic, { channel=1, loops=-1 } )
 
-- Go to the menu screen
composer.gotoScene( "menu" )