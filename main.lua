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
audio.reserveChannels( 1 )
-- Reduce the overall volume of the channel
local bgMusic = audio.loadStream( "audio/bgMusic.mp3" )
audio.setVolume( 0.3, { channel=1 } )
audio.play( bgMusic, { channel=1, loops=-1 } )
 
-- Go to the menu screen
composer.gotoScene( "menu" )