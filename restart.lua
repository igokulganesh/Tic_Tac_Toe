
local composer = require( "composer" )
local scene = composer.newScene()

local background = display.newImageRect("Image/Orange_BG.jpg", 444, 794)
background.x = display.contentCenterX
background.y = display.contentCenterY

local text = display.newText(gameStatus, display.contentCenterX, display.contentCenterY-200, "Text/Bangers.ttf", 24) 
text:setFillColor( 0, 0, 0 )