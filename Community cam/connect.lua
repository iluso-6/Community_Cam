local M = require('common')

local signal = false
local gps = false

local currentLatitude = 0
local currentLongitude = 0


local function connection(val)
	if(val==true)then
		signal = true
		timer.cancel( M.wifiSpinnerTimer )
		M.wifiSpinner.isVisible = false
		M.correctWifi.isVisible = true
	 elseif(val==false)then
		signal = false
		M.wifiSpinner.isVisible = true
		M.correctWifi.isVisible = false	
	end
	return val
end
M.connection = connection

local function gpsLocation(con)
	if(con==true)then
		gps = true
	--	timer.cancel ( M.gpsSpinnerTimer ) 
		M.gpsSpinner.isVisible = false
		M.correctGps.isVisible = true
	elseif(con==false)then
		gps = false
		M.gpsSpinner.isVisible = true
		M.correctGps.isVisible = false
	end
	return con
end
M.gpsLocation = gpsLocation

------------------------ Wifi

local function networkListener( event )
        if ( event.isError ) then
              	connection( false )
        elseif(event.response=='ok')then 
       -- 	print("event.response = " .. event.response)
        --	print("HAS INTERNET")
				connection( true )
        end
end

local params = {}
params.timeout = 3

local checkNet = function ()

 network.request( "http://shay.x10.mx/appdata/checkNetwork.php", "POST", networkListener,params);
 print('check') 
 
 end

--------------------------- Wifi ^^^

--------------------------- GPS
local locationHandler = function( event )

	if event.errorCode then
		native.showAlert( "GPS Location Error", event.errorMessage, {"OK"} )
		print( "Location error: " .. tostring( event.errorMessage ) )

	else

		local latitude = event.latitude 
		currentLatitude = latitude
		M.userTable.Lat = latitude
		local longitude = event.longitude 
		currentLongitude = longitude
		M.userTable.Lon = longitude

	if( string.format( '%.4f', latitude ) == '37.4485' )then
	--	print("Simulator",latitude)

	elseif( string.format( '%.4f', latitude ) ~= '37.4485' )then
	
		if(math.floor(latitude)>=51 and math.floor(latitude)<=55)then
			gpsLocation(true)
		else 
			gpsLocation(false)
		end
		
	end   
	
			
	end
end		

 Runtime:addEventListener( "location", locationHandler ) 


checkNet() -- first trigger

timer.performWithDelay( 5000, function() 
 
checkNet() --Wifi

end ,0)
---------------------------GPS ^^^
M.userTable.Lat = currentLatitude
M.userTable.Lon = currentLongitude
M.gps = gps
M.signal = signal

