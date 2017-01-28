local composer = require( "composer" )
local M = require('common')
local widget = require('widget')

local scene = composer.newScene()

--fores
local textInfo
local uploadPhoto
local camera
local textGroup
local textField
local screen
local createGrp


local function textWrite(txt)

	textInfo.text = txt

end
M.textWrite = textWrite


local function onPhotoComplete(event)
	if ( event.completed ) then
	textWrite( "Tap to launch Camera")
	local previewImage = display.newImage(M.photoId,system.DocumentsDirectory)
	
	local diff = previewImage.width/previewImage.height
		if(diff>1)then
		  scaleW = M.screen.width / previewImage.width
		  scaleH = 192 / previewImage.height
		else
		  scaleW = 192 / previewImage.width
		  scaleH = M.screen.height / previewImage.height		  
		end
	previewImage:scale( scaleW,scaleH )
	previewImage.x = M.screen.x
	previewImage.y = M.screen.y	
	createGrp:insert(previewImage)
	
			camera.isVisible = false
		local infoBox = display.newGroup()

		local function yesAction(event)
			if ( "ended" == event.phase ) then
			transition.to(infoBox,{alpha=0})
			M.uploadPic(M.photoId,createGrp)
			end
		end

		local function noAction(event)
			if ( "ended" == event.phase ) then
			transition.to(infoBox,{alpha=0})
			camera.isVisible = true
			previewImage.isVisible = false
			end
		end


		local overlayPanel = display.newRoundedRect(0,0, 160, 120,8)
		overlayPanel:setFillColor(203/255,210/255,120/255,1)
		overlayPanel:setStrokeColor(1)
		overlayPanel.strokeWidth = 1
		overlayPanel.x = camera.x
		overlayPanel.y = camera.y
		infoBox:insert(overlayPanel)
		
		local text = display.newText("Send Photo?",0,0,native.systemFont,14)
		text.x = M.centerX
		text.y = overlayPanel.y-40
		infoBox:insert(text)
		
		local yes = widget.newButton{
		defaultFile = 'images/yes.png',
		onRelease = yesAction
		
	}
		yes.x = overlayPanel.x-35
		yes.y = overlayPanel.y
		infoBox:insert(yes)

		local no = widget.newButton{
		defaultFile = 'images/no.png',
		onRelease = noAction
		
	}
		no.x = overlayPanel.x+35
		no.y = overlayPanel.y
		infoBox:insert(no)

			createGrp:insert(infoBox)
	end
end

local function click(event)

	if ( "ended" == event.phase ) then
		audio.play(M.clicker)
		if ( media.hasSource( media.Camera ) ) then
			textWrite( 'Opening camera ...')
		   media.capturePhoto( {
		   listener = onPhotoComplete, 
		   destination = {
			  baseDir = system.DocumentsDirectory,
			  filename = M.photoId,
			  type = "image"
		   }
		} )
		else
		   native.showAlert( "Corona", "This device does not have a camera.", { "OK" } )
		end
	end
end

local function setUpDisplay(grp)
	
	screen = display.newRect(0,0, 256, 192)--192
	screen.x = M.centerX
	screen.y = M.centerY-15
	screen:setFillColor(203/255,210/255,120/255,0.8)
	screen.strokeWidth = 1
	screen:setStrokeColor(76/255,88/255,44/255)	
	grp:insert(screen)		
	M.screen = screen
	
local topRef = screen.y-(screen.height/2)
local topMid = (M.screenTop + topRef)/2
local bottomRef = screen.y+(screen.height/2)
local bottomMid = (M.screenBottom + bottomRef)/2

	
	textInfo = display.newText( "Tap to launch Camera", M.centerX, M.screenHeight-180, nil, 12 )
	textInfo.x =  M.centerX
	textInfo.y = screen.y
	grp:insert(textInfo)
	
	camera = widget.newButton{
	width = 96,
	height = 96,
	defaultFile = 'images/camera1.png',
	overFile  = 'images/camera.png',
	onRelease = click
	
}
	camera.x = M.centerX
	camera.y = bottomMid
	grp:insert(camera)
	M.camera = camera
	
	--- text Input
	
	textGroup = display.newGroup()
	local textBar = display.newRoundedRect(M.centerX,topMid-20, M.screenWidth-20, 140,8)
	textBar.anchorY = 0.5
	textBar:setFillColor(203/255,210/255,120/255)
	textBar.strokeWidth = 1
	textBar:setStrokeColor(76/255,88/255,44/255)
	textGroup:insert(textBar)
	
	textField = native.newTextField( 0, 0, textBar.width-30, 40 )
	textField.x = textBar.x	
	textField.y = textBar.y
	textGroup:insert(textField)
	textGroup.y = -150	
	
	M.textGroup = textGroup
	M.textField = textField
	grp:insert(textGroup)
	local home = widget.newButton{
	width = 36,
	height = 36,
	defaultFile = 'images/home.png',
	onRelease = M.goHome
	
}
	home.x = M.screenLeft+home.contentWidth
	home.y = M.screenBottom-home.contentHeight
	grp:insert(home)
	
	
	
end



function scene:create( event )

    local sceneGroup = self.view
	createGrp = sceneGroup
		setUpDisplay(sceneGroup)
		M.bg:toBack()
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
	
	uploadPhoto = require('uploadPhoto')

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
	
	