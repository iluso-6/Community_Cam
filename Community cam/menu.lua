local composer = require( "composer" )
local M = require('common')
local widget = require('widget')

local scene = composer.newScene()



local function gotoCam(event)
	if(event.phase=='ended')then
	
	composer.gotoScene('start','slideLeft',1000)

	end
end


local function gotoList(event)
	if(event.phase=='ended')then
	transition.to(M.displayBar,{time=800,x = (M.screenWidth+40)*-1,transition=easing.inOutQuad,onComplete=function()   
	composer.gotoScene('tableMap.list','slideLeft',1000);
	end })
	end
end

local function gotoSearch(event)
	if(event.phase=='ended')then


	
	end
end



function scene:create( event )

    local sceneGroup = self.view

	local menuCam = widget.newButton{
	width = 72,
	height = 72,
	defaultFile = 'images/cam.png',
	overFile = 'images/cam1.png',
	onRelease = gotoCam
	
}
	menuCam.x = M.centerX
	menuCam.y = M.centerY-50
	sceneGroup:insert(menuCam)
	
	local menuList = widget.newButton{
	width = 72,
	height = 72,
	defaultFile = 'images/list.png',
	overFile = 'images/list1.png',	
	onRelease = gotoList
	
}
	menuList.x = M.centerX
	menuList.y = M.centerY+60
	sceneGroup:insert(menuList)	
	
	local menuSearch = widget.newButton{
	width = 72,
	height = 72,
	defaultFile = 'images/search.png',
	overFile = 'images/search1.png',	
	onRelease = gotoSearch
	
}
	menuSearch.x = M.centerX
	menuSearch.y = M.centerY+170
	sceneGroup:insert(menuSearch)
	
	
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
		transition.to(M.displayBar,{time=1000,x = 0,transition=easing.inOutQuad })
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
		if( composer.getSceneName('previous')=='start' )then
		composer.removeScene( "start" )
		end

    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
		
	end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene