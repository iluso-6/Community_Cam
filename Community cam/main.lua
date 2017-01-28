local composer = require( "composer" )
local M = require('common')
local widget = require('widget')
local connect = require('connect')
local lfs = require "lfs"

display.setStatusBar( display.HiddenStatusBar )
system.setLocationAccuracy( 10 )


--fores
local wifiSpinner
local gpsSpinner
local wifiSpinnerTimer={}
local gpsSpinnerTimer={}


local function spinWifiX()
  wifiSpinner:rotate( 15 )	
end


local function spinLocationX()
  gpsSpinner:rotate( 15 )
end


local function textWrite(txt)

	textInfo.text = txt

end
M.textWrite = textWrite


local function goHome()

composer.gotoScene('menu','slideRight',1000)

end
M.goHome = goHome

local topMid = 64.5
local displayBar = display.newGroup()
M.displayBar = displayBar

	local bg = display.newRect(M.screenLeft,M.screenTop, M.screenWidth, M.screenHeight)
	bg.anchorX = 0
	bg.anchorY = 0
	bg:setFillColor(141/255,163/255,82/255)
	M.bg = bg
	
	local topBar = display.newRoundedRect(M.centerX,topMid, M.screenWidth-40, 85,8)
	topBar:setFillColor(203/255,210/255,120/255,.4)--(140/255,175/255,84/255)
	topBar.strokeWidth = 1
	topBar:setStrokeColor(76/255,88/255,44/255)	
	displayBar:insert(topBar)
	
	local wifi = display.newImageRect('images/cloud1.png',48,48)
	wifi.x = M.centerX - 100
	wifi.y = topMid-5
	wifi.alpha = 1
	displayBar:insert(wifi)
	
	wifiSpinner = display.newImageRect('images/x1.png', 24, 24 )
	wifiSpinner.x = wifi.x +10
	wifiSpinner.y = wifi.y + 25
	M.wifiSpinner = wifiSpinner
	displayBar:insert(wifiSpinner)
	
	local location = display.newImageRect('images/gps1.png',48,48)
	location.x = M.centerX - 32
	location.y = topMid-5
	location.alpha = 1
	displayBar:insert(location)
	
	gpsSpinner = display.newImageRect('images/x1.png', 24, 24 )
	gpsSpinner.x = location.x +10
	gpsSpinner.y = location.y + 25
	M.gpsSpinner = gpsSpinner
	displayBar:insert(gpsSpinner)
	
	local picUpload = display.newImageRect('images/document.png',48,48)
	picUpload.x = M.centerX + 32
	picUpload.y = topMid-5
	picUpload.alpha = 1
	displayBar:insert(picUpload)
	
	local mail = display.newImageRect('images/mail1.png',48,48)
	mail.x = M.centerX + 100
	mail.y = topMid-5
	mail.alpha = 1
	displayBar:insert(mail)
	
	local correctWifi = display.newImageRect('images/tick.png',32,32)
	correctWifi.x = wifi.x+12
	correctWifi.y = wifi.y+25
	correctWifi.isVisible = false
	M.correctWifi = correctWifi
	displayBar:insert(correctWifi)
	
	local correctGps = display.newImageRect('images/tick.png',32,32)
	correctGps.x = location.x+12
	correctGps.y = location.y+25
	correctGps.isVisible = false
	M.correctGps = correctGps
	displayBar:insert(correctGps)
	
	local correctUp = display.newImageRect('images/tick.png',32,32)
	correctUp.x = picUpload.x+12
	correctUp.y = picUpload.y+25
	correctUp.isVisible = false
	M.correctUp = correctUp
	displayBar:insert(correctUp)
	
	local correctMail = display.newImageRect('images/tick.png',32,32)
	correctMail.x = mail.x+12
	correctMail.y = mail.y+25
	correctMail.isVisible = false	
	M.correctMail = correctMail
	displayBar:insert(correctMail)
	
	wifiSpinnerTimer = timer.performWithDelay(100, spinWifiX ,0)
	M.wifiSpinnerTimer = wifiSpinnerTimer

	gpsSpinnerTimer = timer.performWithDelay(100, spinLocationX ,0)	
	M.gpsSpinnerTimer = gpsSpinnerTimer	
	
	bg:toBack()
	composer.gotoScene('menu')

local function removeTempFiles()

local doc_path = system.pathForFile( "", system.TemporaryDirectory )
	for file in lfs.dir(doc_path) do
	   os.remove( system.pathForFile( file, system.TemporaryDirectory ))
	   
	end
end
	
	
local onSystem = function( event )
    if event.type == "applicationStart" then
        print("start")
		removeTempFiles()
    elseif event.type == "applicationExit" then
        print("exit")
		removeTempFiles()
    elseif event.type == "applicationSuspend" then
        print("suspend")
    elseif event.type == "applicationResume" then
        print("resume")
    end
end


Runtime:addEventListener( "system", onSystem )
	
	