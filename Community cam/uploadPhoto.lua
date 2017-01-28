local M = require('common')
local widget = require('widget')

local tableToPost = M.userTable
local sentData = false

local uploadProgress

local function postToDataBase(userParams)

	local userParams = userParams
	userParams.Lon = userParams.Lon or 0
	userParams.Lat = userParams.Lat or 0
	userParams.Message = userParams.Message
	
	local function postListener(event)
		if ( event.isError ) then
			native.showAlert ("Error", "Error - no connection.", {"OK"} )
		else
			print("postToDataBase")
		end

	end

	local params = {}

	params.body = "usr=" .. userParams.User .. "&pic=" .. userParams.Pic .. "&lat=" .. userParams.Lat .. "&lon=" .. userParams.Lon .. "&message=" .. userParams.Message
	--	print(userParams.Lat, userParams.Pic)
	network.request ( "http://shay.x10.mx/appdata/insert.php", "POST", postListener, params ,"tmp.txt", system.TemporaryDirectory  )
	
end

local function sendText(tableToPost)

	if(sentData==false)then
	
		sentData = true;
			local tableToPost = tableToPost
			
		transition.to(M.textGroup,{ time=600,delay=600, y = -150,onComplete= function()
			postToDataBase(tableToPost);
			native.setKeyboardFocus( nil );
			M.correctMail.isVisible = true ;
		 end })		
		 
	end
	
end

local function addText()


local fieldHandler = function( event )

	if ( "ended" == event.phase or "submitted" == event.phase ) then
		local textContent = M.textField.text
		M.userTable.Message = textContent;
		sendText(M.userTable);
		
	end	
end

transition.to(M.textGroup,{ time=600,delay=600,y = 0 })
 M.textField:addEventListener( "userInput", fieldHandler ) 
 native.setKeyboardFocus( M.textField )
end


local uploadPic = function(picture,grp)

local filename = picture
local baseDirectory = system.DocumentsDirectory 
local contentType = "image/jpeg" 

local lfs = require "lfs"
local file_path = system.pathForFile( filename, baseDirectory )
local file_attr = lfs.attributes( file_path )
local imageSize = file_attr.size


local function uploadListener( event )

	uploadProgress = widget.newProgressView {
		left = 120,
		width = 160,
		isAnimated = true
	}
	uploadProgress.x = M.camera.x
	uploadProgress.y = M.camera.y	
	uploadProgress.isVisible = true
	grp:insert(uploadProgress)
	   if ( event.isError ) then
		  native.showAlert( "Network connection required" , { "OK" } )
	   else
	   local data = event.bytesTransferred
	  
		  if ( event.phase == "began" ) then
			  uploadProgress:setProgress( 0.1 )
		  elseif ( event.phase == "progress" ) then
		  local dataPrint = ((1/imageSize)*data);
		  uploadProgress:setProgress( dataPrint )
		  elseif ( event.phase == "ended" ) then
		  if(type(event.response)=='table')then
			uploadProgress:setProgress( 1 ) 
		  end
				M.correctUp.isVisible = true
				addText()
		  end
	   end
	end

local url = "http://shay.x10.mx/appdata/uploadNew.php"
local method = "PUT"



local params = {
   timeout = 60,
   progress = true,
   bodyType = "binary"
}

local headers = {}
headers.filename = filename
params.headers = headers


network.upload( url , method, uploadListener, params, filename, baseDirectory, contentType )


end

M.uploadPic = uploadPic


