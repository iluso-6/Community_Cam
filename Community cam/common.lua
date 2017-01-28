
local M = {}

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local screenLeft = display.screenOriginX
local screenWidth = display.contentWidth - screenLeft * 2
local screenRight = screenLeft + screenWidth
local screenTop = display.screenOriginY
local screenHeight = display.contentHeight - screenTop * 2
local screenBottom = screenTop + screenHeight

M.centerX = centerX
M.centerY = centerY
M.screenLeft = display.screenOriginX
M.screenWidth = screenWidth
M.screenRight = screenLeft + screenWidth
M.screenTop = screenTop
M.screenHeight = screenHeight
M.screenBottom = screenBottom



local clicker = audio.loadSound('sounds/click.mp3')
M.clicker = clicker

local dateNow = os.date( "*t" )
M.dateNow = dateNow

local photoTime = (dateNow.day .. dateNow.month .. dateNow.hour .. dateNow.min )
M.photoTime = photoTime 

local userId = "User"
M.userId = userId

local photoId = tostring( userId .. photoTime .. ".jpg" )
M.photoId = photoId

local Message = 'No notes added'
M.Message = Message

local userTable = {User = userId, Pic = photoId, Lon = 0, Lat = 0,Message = Message }
M.userTable = userTable



return M