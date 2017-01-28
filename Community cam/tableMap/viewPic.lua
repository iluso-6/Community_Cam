local M = require('tableMap.common')
local widget = require( "widget" )
local composer = require( "composer" )

local scene = composer.newScene()

local zoomButton
local backButton
local myTempDetails

local function showDetails(grp,details)
	
	myTempDetails = details

	local notepad = display.newRect(M.screenLeft+40,M.screenTop+30,240,160)
	notepad.anchorX = 0	
	notepad.anchorY = 0
	grp:insert(notepad)
	
	local title = display.newText(M.myTempDetails.UserId,M.centerX,notepad.y+20,system.defaultFont,16)
	title:setFillColor(0)
	grp:insert(title)
	
	local message = display.newText(M.myTempDetails.Message,notepad.x+14,notepad.y+40,200,80,system.defaultFont,14)
	message.anchorX = 0
	message.anchorY = 0
	message:setFillColor(0,0,0,0.8)
	grp:insert(message)
end

local function showPic(grp)
	local pic = M.myTempName

		local function networkListener2( event )
			if ( event.isError ) then
				print ( "Network error - download failed" )
			else
				event.target.alpha = 0
				transition.to( event.target, { alpha = 1.0 } )
				M.myTemp = event.target
				grp:insert( M.myTemp )
			end
			
		--	print ( "RESPONSE: ", event.response.filename )
		end

			display.loadRemoteImage( 
			"http://shay.x10.mx/appdata/photoUploads/thumbs/".. pic, 
			"GET", 
			networkListener2, 
			"tempLarge.jpg", 
			system.TemporaryDirectory, 
			M.centerX, M.screenHeight-180 )	
	end

local function showButtons(grp)

	local function zoom( event )

		composer.gotoScene( "tableMap.zoom" ,"slideLeft", 800  )
		
	end


	
		local function goBack( event )
			
			composer.gotoScene( "tableMap.list" ,"slideRight", 800  )

		end
	
		zoomButton = widget.newButton {
		width = 48,
		height = 48,
		defaultFile = "images/zoom.png",
		onRelease = zoom
	}
	zoomButton.x = M.screenWidth-zoomButton.contentWidth
	zoomButton.y = M.screenHeight-34
	grp:insert( zoomButton )


	-- Back button
	backButton = widget.newButton {
		width = 48,
		height = 48,
		defaultFile = "tableMap/images/back.png",
		onRelease = goBack
	}
	backButton.x = M.screenLeft+backButton.contentWidth
	backButton.y = M.screenHeight-34
	grp:insert( backButton )

end

function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
	showPic(sceneGroup)
	transition.to(M.home,{alpha=0})

	showDetails(sceneGroup,M.myTempDetails)
    elseif ( phase == "did" ) then
	
	
    end
end

-- Create scene
function scene:create( event )

	local sceneGroup = self.view
	showButtons(sceneGroup)

end

function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).

    elseif ( phase == "did" ) then

    end
end



scene:addEventListener( "create" )
scene:addEventListener( "show" )
scene:addEventListener( "hide" )

return scene