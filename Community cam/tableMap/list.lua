local M = require('tableMap.common')
local widget = require( "widget" )
local composer = require( "composer" )
local json = require ( "json" )

local scene = composer.newScene()
local environment = system.getInfo( "environment" )
-----
local recordList={}
M.recordList = recordList
local rowMessage = {}
local myMap
local myTemp = M.myTemp
local myTempName = M.myTempName
local numberOfRecords = 10
local GETdbURL = "http://shay.x10.mx/appdata/photo_latest.php"
local notesContent
local tableView

local tableViewColors = {
	rowColor = { default = {1,1,1}, over = {94/255,163/255,76/255,0.6} },
	lineColor = { 220/255 },
	defaultLabelColor = { 0, 0, 0, 0.6 }
}

local function fileExists(fileName, base)
  assert(fileName, "fileName does not exist")
  local base = base or system.TemporaryDirectory
  local filePath = system.pathForFile( fileName, base )
  local exists = false
 
  if (filePath) then
    local fileHandle = io.open( filePath, "r" )
    if (fileHandle) then
      exists = true
      io.close(fileHandle)
    end
  end
 
  return(exists)
end

local function loadTextFile( filename, base )
	-- set default base dir if none specified
	if not base then base = system.ResourceDirectory; end
	local path = system.pathForFile( filename, base )
	local contents
	-- io.open opens a file at path. returns nil if no file found
	local file = io.open( path, "r" )
	if file then
	   -- read all contents of file into a string
	   contents = file:read( "*a" )
	   io.close( file )	-- close the file after using it
	end
	return contents
end


local function createMap(grp)

	local sceneGroup = grp
	
	if environment == "simulator" then
		myMap = display.newRect(M.screenLeft+10,M.screenTop+5,300,180)
		myMap.anchorX = 0	
		myMap.anchorY = 0
	else
		myMap = native.newMapView(M.screenLeft+10,M.screenTop+5,300,180)
		myMap.anchorX = 0	
		myMap.anchorY = 0

		if myMap then

			myMap.mapType = "normal"

			myMap:setCenter( 53.2661978, -6.143394700000044 )
		end
	end
	
	M.myMap = myMap
	
	sceneGroup:insert(M.myMap)

	
end

local function showData(grp)		
	
	
	local function tableViewListener( event )
		local phase = event.phase
	end

	local function onRowRender( event )
		local phase = event.phase
		local row = event.row
		local idx = row.index
		local groupContentHeight = row.contentHeight

		local rowTitle = display.newText( row, recordList[idx].UserId, 0, 0, nil, 14 )
		rowTitle.x = 10
		rowTitle.anchorX = 0
		rowTitle.y = groupContentHeight * 0.3
		rowTitle:setFillColor(0,0,0,0.8)
		
		local rowTime = display.newText( row, recordList[idx].Time, 0, 0, nil, 10 )
		rowTime.x = 10
		rowTime.anchorX = 0
		rowTime.y = groupContentHeight * 0.6
		rowTime:setFillColor(0,0,0,0.6)
		
		local rowDate = display.newText( row, recordList[idx].Date, 0, 0, nil, 10 )
		rowDate.x = 10
		rowDate.anchorX = 0
		rowDate.y = groupContentHeight * 0.8
		rowDate:setFillColor(0,0,0,0.6)

		rowMessage[idx] = display.newText( row,'', 0, 0,150,50,  native.systemFont, 12 )
		rowMessage[idx].text = ( recordList[idx].Message:sub(1, 24) ) .. ' ...'
		rowMessage[idx].x = row.contentWidth * 0.24
		rowMessage[idx].anchorX = 0
		rowMessage[idx].y = groupContentHeight * 0.5
		rowMessage[idx]:setFillColor(0)
		local rowImage
		local imageToShow =  fileExists( recordList[idx].PhotoId )
		if(imageToShow==true)then
		rowImage = display.newImageRect( row ,recordList[idx].PhotoId,system.TemporaryDirectory,48 ,48 )
		else
		rowImage = display.newImageRect( row ,'tableMap/images/blank.png',48 ,48 )
		end
		rowImage.anchorX = 1
		rowImage.x = row.contentWidth-60
		rowImage.y = groupContentHeight * 0.5
		
	end


	local function onRowUpdate( event )
		local phase = event.phase
		local row = event.row
	end	

	local function onRowTouch( event )
		local phase = event.phase--press, release, swipeLeft ect..
		local row = event.target
		local idx = row.index

		if ( "release" == phase ) then
		local textMessage = recordList[row.index].Message
		if(tonumber(string.len(textMessage))<1)then textMessage='No notes added' end;
		rowMessage[row.index].text = textMessage
		if environment == "simulator" then
		else
			local options =
{ 
    title = recordList[row.index].UserId, 
    subtitle = recordList[row.index].Date, 
    imageFile =  "tableMap/images/pin.png",
}
			local thisLat = tonumber( recordList[row.index].Latitude )
			local thisLon = tonumber( recordList[row.index].Longitude )
			myMap:setRegion(thisLat, thisLon, 0.0008, 0.0008)
			myMap:addMarker(thisLat, thisLon,options);
		end
		elseif ( "swipeLeft" == phase ) then
		
		M.myTempName = recordList[idx].PhotoId
		M.myTempDetails = recordList[idx]
		composer.gotoScene( "tableMap.viewPic","slideLeft", 800  )
		elseif ( "swipeRight" == phase ) then
		composer.gotoScene( "menu","slideRight", 800  )
		end
	end
	
	-- Create a tableView
	tableView = widget.newTableView
	{
		top = M.screenTop+200,
		left = 10,
		width = M.screenWidth-20, 
		height =275,
		hideBackground = false,
		listener = tableViewListener,
		onRowRender = onRowRender,
		onRowUpdate = onRowUpdate,
		onRowTouch = onRowTouch,
	}
	

	for i = 1,numberOfRecords do
		local isCategory = false
		local rowHeight = 70
		local rowColor = { 
			default = tableViewColors.rowColor.default,
			over = tableViewColors.rowColor.over,
		}

		tableView:insertRow
		{
			rowHeight = rowHeight,
			rowColor = rowColor,
			lineColor = tableViewColors.lineColor
		}

	end
	
		grp:insert( tableView )
end

local function getImages()
	local i=1
	local callNet={}

	local function networkListener( event )
		if ( event.isError ) then
			i=i+1
		else
			i=i+1
			if( i <= numberOfRecords)then
			callNet(i)
			else
			tableView:reloadData()
			end
		end
	end


	function callNet(idx)
		local i = idx
	 network.download( 
		"http://shay.x10.mx/appdata/photoUploads/thumbs/small-96x96/".. recordList[i].PhotoId, 
		"GET", 
		networkListener, 
		recordList[i].PhotoId, 
		system.TemporaryDirectory )
		
	end
	callNet(1)

end


local function getNewData(group)

	local function newDataListener(event)
		if ( event.isError ) then
			native.showAlert ("Error", "Error - no connection.", {"OK"} )
		else
			local t = loadTextFile("photo_latest.txt", system.TemporaryDirectory)
			if t:sub(1,7) == "Error: " then
				native.showAlert ("Error", t, {"OK"} )
			else
				t = json.decode( t )
				if #t > 0 then

					for v = 1, numberOfRecords do
						recordList[v] =
						{
						Message = t[v]["Message"],
						Id = t[v]["Id"] ,
						PhotoId = t[v]["PhotoId"],
						UserId = t[v]["UserId"],
						Time = t[v]["Time"],
						Date = t[v]["Date"],
						Latitude = t[v]["Latitude"],
						Longitude = t[v]["Longitude"]
						}
						
					end
					
				else
					native.showAlert ( "Error", "No new records found.", {"OK"} )
				end
			end
		end
		getImages()
	showData(group)
	--createMap(group)
	end

	local settings = { username="jdoe", password="pword" }
	
	local params = {}
	params.body = "u=" .. settings.username .. "&p=" .. settings.password
		
	network.download ( GETdbURL, "POST", newDataListener, params, "photo_latest.txt", system.TemporaryDirectory )
end

function scene:create( event )

	local sceneGroup = self.view
	
		getNewData(sceneGroup)
		createMap(sceneGroup)
	
end

function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

    elseif ( phase == "did" ) then
	
			if(tableView)then
			tableView:reloadData()
			end
	        if(M.myTemp)then
			M.myTemp:removeSelf()
			M.myTemp=nil;
			end
	if( composer.getSceneName('previous')=='tableMap.zoom' )then
		composer.removeScene( "tableMap.zoom" )
	end	
	
    end
end

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



scene:addEventListener( "create" )
scene:addEventListener( "show" )
scene:addEventListener( "hide" )

return scene
