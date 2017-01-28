local M = require('tableMap.common')
local widget = require( "widget" )
local composer = require( "composer" )
local lfs = require "lfs"

local scene = composer.newScene()

--forewards

local thumbNav
local scrollView
local diffW
local diffH
local myTemp = M.myTemp
local thumbPic
local myImage

local function createPage(grp)

	local function goBack( event )

	composer.gotoScene( "tableMap.list" ,"slideRight", 800  )

	end


	local background = display.newRect(M.screenLeft,M.screenTop,M.screenWidth,M.screenHeight)
	background.anchorX = 0
	background.anchorY = 0
	background:setFillColor(45/255,45/255,40/255,1)
	grp:insert(background)

	thumbPic = display.newImageRect("tempLarge.jpg",system.TemporaryDirectory,125,96)
	thumbPic.anchorX = 0
	thumbPic.anchorY = 0
	thumbPic.x = 20
	thumbPic.y = 20
	thumbPic.alpha = 1
	--thumbPic:scale(0.5,0.5)
	grp:insert(thumbPic)

	local backButton = widget.newButton {
	width = 48,
	height = 48,
	defaultFile = "tableMap/images/back.png",
	onRelease = goBack
	}
	backButton.anchorX = 0
	backButton.anchorY = 0
	backButton.x = M.screenWidth-20-backButton.contentWidth
	backButton.y = 20
	grp:insert( backButton )	
	
end

local function createView(grp)

local sceneGroup = grp
	
	local function scrollListener( event )
		local phase = event.phase
		local direction = event.direction

		local xStart = event.x
		local target = event.target
		local xS, yS = scrollView:getContentPosition()
			thumbNav.x = 20-xS/diffW
			thumbNav.y = 20-yS/diffH
		if "began" == phase then
			--print( "Began" )
			thumbNav.x = 20-xS/diffW
			thumbNav.y = 20-yS/diffH
		elseif "moved" == phase then
			--print( "Moved" )
			--thumbNav.x
			thumbNav.x = 20-xS/diffW
			thumbNav.y = 20-yS/diffH
		elseif "ended" == phase then
			--print( "Ended" )
			thumbNav.x = 20-xS/diffW
			thumbNav.y = 20-yS/diffH

		end
		
		-- If the scrollView has reached its scroll limit
		if event.limitReached then
			if "up" == direction then
				--print( "Reached Top Limit" )
			elseif "down" == direction then
				--print( "Reached Bottom Limit" )
			elseif "left" == direction then
				--print( "Reached Left Limit" )
			elseif "right" == direction then
				--print( "Reached Right Limit" )
			end
		end

		return true
	end

	-- Create a scrollView
		scrollView = widget.newScrollView {
		left = 20,
		top = 140,
		width = display.contentWidth-40,
		height = display.contentHeight-160,
		isBounceEnabled = false,
		horizontalScrollingDisabled = false,
		verticalScrollingDisabled = false,
		listener = scrollListener
	}
	
	-- Insert an image into the scrollView
	local scrollPic = myImage
	scrollPic.x = scrollPic.contentWidth * 0.5
	scrollPic.y = scrollPic.contentHeight * 0.5
	scrollView:insert( scrollPic )

	sceneGroup:insert(scrollView)


	diffW = scrollPic.width/thumbPic.width
	diffH = scrollPic.height/thumbPic.height

	thumbNav = display.newRect(thumbPic.x,thumbPic.y,scrollView.width/diffW,scrollView.height/diffH)
	thumbNav.anchorX = 0
	thumbNav.anchorY = 0
    thumbNav:setFillColor( 0,0,0,0.3 ) 
 	thumbNav:setStrokeColor(1,0,0,0.5)
	thumbNav.strokeWidth = 1

	sceneGroup:insert(thumbNav)	
end

local function getImage(grp,img)
local grp = grp
local image = img

	local progressView = widget.newProgressView {
		left = 120,
		width = 130,
		isAnimated = true
	}
	progressView.x = M.centerX
	progressView.y = M.centerY+80
	grp:insert( progressView )

local function networkListener( event )

local file_path = system.pathForFile( image,system.TemporaryDirectory )
local file_attr = lfs.attributes( file_path )
local imageSize = file_attr.size
local data

    if ( event.isError ) then
        print( "Network error - download failed")
    elseif ( event.phase == "began" ) then
        print( "Progress Phase: began" )
		progressView:setProgress( 0.1 )
	elseif ( event.phase == "progress" ) then	
	  data = event.bytesTransferred
	local dataPrint = ((1/imageSize)*data);
	  progressView:setProgress( dataPrint )
    elseif ( event.phase == "ended" ) then
		if(type(event.response)=='table')then
      progressView:setProgress( 1 ) 	  
        myImage = display.newImage( event.response.filename, event.response.baseDirectory)
        myImage.alpha = 0
        transition.to( myImage, { alpha = 0 ,onComplete= function()		
		createView(grp);
		myImage.alpha=1.0
		end	} )
		else
		native.showAlert( "No Image", "No larger image found", { "OK" } )
		return
		end
    end
end



local params = {}
params.progress = true
--1591948.jpg
network.download(
    "http://shay.x10.mx/appdata/photoUploads/".. image,
    "GET",
    networkListener,
    params,
    "tempXL.jpg",
    system.TemporaryDirectory
)

end

function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then


    elseif ( phase == "did" ) then

	
    end
end


-- Create scene
function scene:create( event )

	local sceneGroup = self.view
	createPage(sceneGroup)
	getImage(sceneGroup,M.myTempName)
	--createView(sceneGroup)
	
end

function scene:destroy( event )

   local sceneGroup = self.view
	--sceneGroup:removeSelf()
   -- Called prior to the removal of scene's view ("sceneGroup").
   -- Insert code here to clean up the scene.
   -- Example: remove display objects, save state, etc.
end


scene:addEventListener( "create" )
scene:addEventListener( "show" )
scene:addEventListener( "destroy" )

return scene
