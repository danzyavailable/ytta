local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MinimizeBtn = Instance.new("TextButton")
local Footer = Instance.new("TextLabel")

local Container = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- delete old gui
local oldGui = playerGui:FindFirstChild("DansskieeGui")
if oldGui then oldGui:Destroy() end

ScreenGui.Name = "DansskieeGui"
ScreenGui.Parent = playerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

-- MAIN FRAME
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18,18,18)
MainFrame.Position = UDim2.new(0.1,0,0.4,0)
MainFrame.Size = UDim2.new(0,250,0,240)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ZIndex = 10

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0,15)
MainCorner.Parent = MainFrame

-- TITLE
Title.Parent = MainFrame
Title.Size = UDim2.new(1,0,0,45)
Title.BackgroundColor3 = Color3.fromRGB(25,25,25)
Title.Text = "Script By Dansskiee"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.ZIndex = 11

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0,15)
TitleCorner.Parent = Title

-- MINIMIZE
MinimizeBtn.Parent = MainFrame
MinimizeBtn.Size = UDim2.new(0,30,0,30)
MinimizeBtn.Position = UDim2.new(1,-35,0,7)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "▼"
MinimizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 18
MinimizeBtn.ZIndex = 12

local minimized = false

MinimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	
	MainFrame:TweenSize(
		minimized and UDim2.new(0,250,0,45) or UDim2.new(0,250,0,240),
		"Out","Quart",0.3,true
	)
	
	Container.Visible = not minimized
	Footer.Visible = not minimized
	
	MinimizeBtn.Text = minimized and "▲" or "▼"
end)

-- CONTAINER
Container.Parent = MainFrame
Container.Position = UDim2.new(0,10,0,55)
Container.Size = UDim2.new(1,-20,0,150)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.CanvasSize = UDim2.new(0,0,0,0)
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
Container.ScrollBarThickness = 4
Container.ScrollingDirection = Enum.ScrollingDirection.Y
Container.ZIndex = 11

UIListLayout.Parent = Container
UIListLayout.Padding = UDim.new(0,8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- FOOTER
Footer.Parent = MainFrame
Footer.Size = UDim2.new(1,0,0,25)
Footer.Position = UDim2.new(0,0,1,-25)
Footer.BackgroundTransparency = 1
Footer.Text = "Tiktok = @dansskiee2"
Footer.TextColor3 = Color3.fromRGB(200,200,200)
Footer.Font = Enum.Font.GothamBold
Footer.TextSize = 11
Footer.ZIndex = 11

-- TOGGLE FUNCTION
local function createToggle(txt,callback)

	local btn = Instance.new("TextButton")
	btn.Parent = Container
	btn.Size = UDim2.new(1,-10,0,35)
	btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
	btn.Text = txt.." : OFF"
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0,8)
	corner.Parent = btn

	local enabled = false

	btn.MouseButton1Click:Connect(function()

		enabled = not enabled
		
		btn.Text = txt.." : "..(enabled and "ON" or "OFF")
		btn.BackgroundColor3 = enabled and Color3.fromRGB(50,150,50) or Color3.fromRGB(30,30,30)

		callback(enabled)

	end)

end

-- ========================
-- DRAG SYSTEM (FIXED)
-- ========================

local function setupDragging(gui)

	local dragging = false
	local dragInput
	local startPos
	local startGuiPos

	gui.InputBegan:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

			dragging = true
			startPos = input.Position
			startGuiPos = gui.Position
			dragInput = input

			input.Changed:Connect(function()

				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end

			end)

		end

	end)

	gui.InputChanged:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

			dragInput = input

		end

	end)

	UserInputService.InputChanged:Connect(function(input)

		if input == dragInput and dragging then

			local delta = input.Position - startPos

			gui.Position = UDim2.new(
				startGuiPos.X.Scale,
				startGuiPos.X.Offset + delta.X,
				startGuiPos.Y.Scale,
				startGuiPos.Y.Offset + delta.Y
			)

		end

	end)

end

-- ========================
-- FITUR
-- ========================

-- Instant Interact
local instantEnabled = false

createToggle("Instant Interact",function(state)

	instantEnabled = state
	
	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("ProximityPrompt") then
			v.HoldDuration = state and 0 or 1
		end
	end
	
end)

workspace.DescendantAdded:Connect(function(v)

	if instantEnabled and v:IsA("ProximityPrompt") then
		v.HoldDuration = 0
	end

end)

-- Infinite Jump
local InfiniteJump = false

createToggle("Infinite Jump",function(state)
	InfiniteJump = state
end)

UserInputService.JumpRequest:Connect(function()

	if InfiniteJump then

		local char = player.Character
		
		if char and char:FindFirstChildOfClass("Humanoid") then
			char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
		end
		
	end

end)

-- Noclip
local Noclip = false

createToggle("Noclip",function(state)
	Noclip = state
end)

RunService.Stepped:Connect(function()

	if Noclip then

		local char = player.Character
		
		if char then
			for _,part in pairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end

	end

end)

-- =========================
-- FPS & PING
-- =========================

local fpsGui = Instance.new("Frame")
local fpsText = Instance.new("TextLabel")

fpsGui.Parent = ScreenGui
fpsGui.Size = UDim2.new(0,150,0,40)
fpsGui.Position = UDim2.new(1,-170,0,10)
fpsGui.BackgroundColor3 = Color3.fromRGB(20,20,20)
fpsGui.Visible = false
fpsGui.Active = true

setupDragging(fpsGui)

local fpsCorner = Instance.new("UICorner")
fpsCorner.CornerRadius = UDim.new(0,10)
fpsCorner.Parent = fpsGui

fpsText.Parent = fpsGui
fpsText.Size = UDim2.new(1,0,1,0)
fpsText.BackgroundTransparency = 1
fpsText.Font = Enum.Font.GothamBold
fpsText.TextColor3 = Color3.fromRGB(255,255,255)
fpsText.TextSize = 14
fpsText.Text = "FPS: 0 | Ping: 0"

local frames = 0
local lastTime = tick()

RunService.RenderStepped:Connect(function()

	frames += 1
	
	if tick() - lastTime >= 1 then

		local fps = frames
		frames = 0
		lastTime = tick()

		local ping = 0

		pcall(function()
			ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
		end)

		fpsText.Text = "FPS: "..fps.." | Ping: "..ping.." ms"

	end

end)

createToggle("Show FPS & Ping",function(state)
	fpsGui.Visible = state
end)

-- =========================
-- SERVER CHANGE
-- =========================

local serverFrame = Instance.new("Frame")
local serverBtn = Instance.new("TextButton")
local serverTitle = Instance.new("TextLabel")

serverFrame.Parent = ScreenGui
serverFrame.Size = UDim2.new(0,180,0,80)
serverFrame.Position = UDim2.new(0.8,0,0.3,0)
serverFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
serverFrame.Visible = false
serverFrame.Active = true

setupDragging(serverFrame)

local serverCorner = Instance.new("UICorner")
serverCorner.CornerRadius = UDim.new(0,10)
serverCorner.Parent = serverFrame

serverTitle.Parent = serverFrame
serverTitle.Size = UDim2.new(1,0,0,30)
serverTitle.BackgroundTransparency = 1
serverTitle.Text = "Server Menu"
serverTitle.Font = Enum.Font.GothamBold
serverTitle.TextColor3 = Color3.fromRGB(255,255,255)
serverTitle.TextSize = 14

serverBtn.Parent = serverFrame
serverBtn.Size = UDim2.new(0.9,0,0,35)
serverBtn.Position = UDim2.new(0.05,0,0.5,0)
serverBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
serverBtn.Text = "Change Server"
serverBtn.Font = Enum.Font.GothamBold
serverBtn.TextColor3 = Color3.fromRGB(255,255,255)
serverBtn.TextSize = 14

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0,8)
btnCorner.Parent = serverBtn

serverBtn.MouseButton1Click:Connect(function()

	local placeId = game.PlaceId
	TeleportService:Teleport(placeId,player)

end)

createToggle("Change Server Menu",function(state)
	serverFrame.Visible = state
end)

-- =========================
-- TELEPORT TO PLAYER
-- =========================

local tpFrame = Instance.new("Frame")
local tpTitle = Instance.new("TextLabel")
local tpList = Instance.new("ScrollingFrame")
local tpLayout = Instance.new("UIListLayout")
local tpBtn = Instance.new("TextButton")
local refreshBtn = Instance.new("TextButton")

local selectedPlayer = nil

tpFrame.Parent = ScreenGui
tpFrame.Size = UDim2.new(0,220,0,260)
tpFrame.Position = UDim2.new(0.75,0,0.35,0)
tpFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
tpFrame.Visible = false
tpFrame.Active = true

setupDragging(tpFrame)

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,10)
corner.Parent = tpFrame

-- TITLE
tpTitle.Parent = tpFrame
tpTitle.Size = UDim2.new(1,0,0,30)
tpTitle.BackgroundTransparency = 1
tpTitle.Text = "Teleport To Player"
tpTitle.Font = Enum.Font.GothamBold
tpTitle.TextColor3 = Color3.fromRGB(255,255,255)
tpTitle.TextSize = 14

-- PLAYER LIST
tpList.Parent = tpFrame
tpList.Position = UDim2.new(0,10,0,35)
tpList.Size = UDim2.new(1,-20,0,150)
tpList.BackgroundTransparency = 1
tpList.ScrollBarThickness = 4
tpList.AutomaticCanvasSize = Enum.AutomaticSize.Y

tpLayout.Parent = tpList
tpLayout.Padding = UDim.new(0,5)

-- REFRESH BUTTON
refreshBtn.Parent = tpFrame
refreshBtn.Size = UDim2.new(0.9,0,0,30)
refreshBtn.Position = UDim2.new(0.05,0,1,-80)
refreshBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
refreshBtn.Text = "Refresh User"
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.TextColor3 = Color3.fromRGB(255,255,255)
refreshBtn.TextSize = 13

local refreshCorner = Instance.new("UICorner")
refreshCorner.CornerRadius = UDim.new(0,8)
refreshCorner.Parent = refreshBtn

-- TELEPORT BUTTON
tpBtn.Parent = tpFrame
tpBtn.Size = UDim2.new(0.9,0,0,35)
tpBtn.Position = UDim2.new(0.05,0,1,-40)
tpBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
tpBtn.Text = "Teleport"
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextColor3 = Color3.fromRGB(255,255,255)
tpBtn.TextSize = 14

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0,8)
btnCorner.Parent = tpBtn

-- =========================
-- TELEPORT TO PLAYER
-- =========================

local tpFrame = Instance.new("Frame")
local tpTitle = Instance.new("TextLabel")
local tpMinimize = Instance.new("TextButton")
local tpList = Instance.new("ScrollingFrame")
local tpLayout = Instance.new("UIListLayout")
local tpBtn = Instance.new("TextButton")
local refreshBtn = Instance.new("TextButton")

local selectedPlayer = nil
local tpMinimized = false

tpFrame.Parent = ScreenGui
tpFrame.Size = UDim2.new(0,220,0,260)
tpFrame.Position = UDim2.new(0.75,0,0.35,0)
tpFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
tpFrame.Visible = false
tpFrame.Active = true

setupDragging(tpFrame)

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,10)
corner.Parent = tpFrame

-- TITLE
tpTitle.Parent = tpFrame
tpTitle.Size = UDim2.new(1,0,0,30)
tpTitle.BackgroundTransparency = 1
tpTitle.Text = "Teleport To Player"
tpTitle.Font = Enum.Font.GothamBold
tpTitle.TextColor3 = Color3.fromRGB(255,255,255)
tpTitle.TextSize = 14

-- MINIMIZE BUTTON
tpMinimize.Parent = tpFrame
tpMinimize.Size = UDim2.new(0,25,0,25)
tpMinimize.Position = UDim2.new(1,-30,0,3)
tpMinimize.BackgroundTransparency = 1
tpMinimize.Text = "▼"
tpMinimize.Font = Enum.Font.GothamBold
tpMinimize.TextColor3 = Color3.fromRGB(255,255,255)
tpMinimize.TextSize = 16

-- PLAYER LIST
tpList.Parent = tpFrame
tpList.Position = UDim2.new(0,10,0,35)
tpList.Size = UDim2.new(1,-20,0,150)
tpList.BackgroundTransparency = 1
tpList.ScrollBarThickness = 4
tpList.AutomaticCanvasSize = Enum.AutomaticSize.Y

tpLayout.Parent = tpList
tpLayout.Padding = UDim.new(0,5)

-- REFRESH BUTTON
refreshBtn.Parent = tpFrame
refreshBtn.Size = UDim2.new(0.9,0,0,30)
refreshBtn.Position = UDim2.new(0.05,0,1,-80)
refreshBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
refreshBtn.Text = "Refresh User"
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.TextColor3 = Color3.fromRGB(255,255,255)
refreshBtn.TextSize = 13

local refreshCorner = Instance.new("UICorner")
refreshCorner.CornerRadius = UDim.new(0,8)
refreshCorner.Parent = refreshBtn

-- TELEPORT BUTTON
tpBtn.Parent = tpFrame
tpBtn.Size = UDim2.new(0.9,0,0,35)
tpBtn.Position = UDim2.new(0.05,0,1,-40)
tpBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
tpBtn.Text = "Teleport"
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextColor3 = Color3.fromRGB(255,255,255)
tpBtn.TextSize = 14

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0,8)
btnCorner.Parent = tpBtn

-- =========================
-- MINIMIZE SYSTEM
-- =========================

tpMinimize.MouseButton1Click:Connect(function()

	tpMinimized = not tpMinimized

	tpList.Visible = not tpMinimized
	refreshBtn.Visible = not tpMinimized
	tpBtn.Visible = not tpMinimized

	tpFrame:TweenSize(
		tpMinimized and UDim2.new(0,220,0,35) or UDim2.new(0,220,0,260),
		"Out","Quart",0.25,true
	)

	tpMinimize.Text = tpMinimized and "▲" or "▼"

end)

-- =========================
-- REFRESH PLAYER LIST
-- =========================

local function refreshPlayers()

	for _,v in pairs(tpList:GetChildren()) do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end

	for _,plr in pairs(Players:GetPlayers()) do

		if plr ~= player then

			local btn = Instance.new("TextButton")
			btn.Parent = tpList
			btn.Size = UDim2.new(1,0,0,30)
			btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
			btn.Text = plr.Name
			btn.Font = Enum.Font.GothamBold
			btn.TextColor3 = Color3.fromRGB(255,255,255)
			btn.TextSize = 13

			local c = Instance.new("UICorner")
			c.CornerRadius = UDim.new(0,6)
			c.Parent = btn

			btn.MouseButton1Click:Connect(function()

				selectedPlayer = plr

				for _,b in pairs(tpList:GetChildren()) do
					if b:IsA("TextButton") then
						b.BackgroundColor3 = Color3.fromRGB(35,35,35)
					end
				end

				btn.BackgroundColor3 = Color3.fromRGB(60,120,60)

			end)

		end

	end

end

refreshPlayers()

Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)

-- MANUAL REFRESH
refreshBtn.MouseButton1Click:Connect(function()
	refreshPlayers()
end)

-- TELEPORT FUNCTION
tpBtn.MouseButton1Click:Connect(function()

	if selectedPlayer then

		local targetChar = selectedPlayer.Character
		local myChar = player.Character

		if targetChar and myChar then

			local hrp1 = myChar:FindFirstChild("HumanoidRootPart")
			local hrp2 = targetChar:FindFirstChild("HumanoidRootPart")

			if hrp1 and hrp2 then
				hrp1.CFrame = hrp2.CFrame + Vector3.new(2,0,2)
			end

		end

	end

end)

-- TOGGLE
createToggle("Teleport To Player",function(state)
	tpFrame.Visible = state
end)

-- =========================
-- ANTI LAG
-- =========================

local antiLag = false

createToggle("Anti Lag", function(state)

	antiLag = state

	if state then

		for _,v in pairs(workspace:GetDescendants()) do

			if v:IsA("ParticleEmitter")
			or v:IsA("Trail")
			or v:IsA("Smoke")
			or v:IsA("Fire")
			or v:IsA("Sparkles") then

				v:Destroy()

			end

			if v:IsA("BasePart") then
				v.Material = Enum.Material.Plastic
				v.Reflectance = 0
			end

		end

		workspace.GlobalShadows = false

		local Lighting = game:GetService("Lighting")
		Lighting.FogEnd = 9e9

	end

end)

-- =========================
-- FRIEND TRACKER MENU
-- =========================

local friendGui = Instance.new("Frame")
local friendTitle = Instance.new("TextLabel")
local friendList = Instance.new("ScrollingFrame")
local friendLayout = Instance.new("UIListLayout")
local refreshBtn = Instance.new("TextButton")
local searchBox = Instance.new("TextBox")

local selectedFriend = nil
local friendsCache = {}

friendGui.Parent = ScreenGui
friendGui.Size = UDim2.new(0,260,0,320)
friendGui.Position = UDim2.new(0.65,0,0.35,0)
friendGui.BackgroundColor3 = Color3.fromRGB(20,20,20)
friendGui.Visible = false
friendGui.Active = true

setupDragging(friendGui)

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,10)
corner.Parent = friendGui

-- TITLE
friendTitle.Parent = friendGui
friendTitle.Size = UDim2.new(1,0,0,30)
friendTitle.BackgroundTransparency = 1
friendTitle.Text = "Friend Tracker"
friendTitle.Font = Enum.Font.GothamBold
friendTitle.TextColor3 = Color3.fromRGB(255,255,255)
friendTitle.TextSize = 14

-- SEARCH
searchBox.Parent = friendGui
searchBox.Size = UDim2.new(0.9,0,0,28)
searchBox.Position = UDim2.new(0.05,0,0,35)
searchBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
searchBox.Text = ""
searchBox.PlaceholderText = "Search Friend"
searchBox.Font = Enum.Font.GothamBold
searchBox.TextColor3 = Color3.fromRGB(255,255,255)
searchBox.TextSize = 13

local sCorner = Instance.new("UICorner")
sCorner.CornerRadius = UDim.new(0,6)
sCorner.Parent = searchBox

-- LIST
friendList.Parent = friendGui
friendList.Position = UDim2.new(0,10,0,70)
friendList.Size = UDim2.new(1,-20,1,-110)
friendList.BackgroundTransparency = 1
friendList.ScrollBarThickness = 4
friendList.AutomaticCanvasSize = Enum.AutomaticSize.Y

friendLayout.Parent = friendList
friendLayout.Padding = UDim.new(0,6)

-- REFRESH
refreshBtn.Parent = friendGui
refreshBtn.Size = UDim2.new(0.9,0,0,28)
refreshBtn.Position = UDim2.new(0.05,1,-35)
refreshBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
refreshBtn.Text = "Refresh Friends"
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.TextColor3 = Color3.fromRGB(255,255,255)
refreshBtn.TextSize = 13

local rCorner = Instance.new("UICorner")
rCorner.CornerRadius = UDim.new(0,6)
rCorner.Parent = refreshBtn

-- CREATE FRIEND ITEM
local function createFriendItem(data)

	local item = Instance.new("Frame")
	item.Parent = friendList
	item.Size = UDim2.new(1,0,0,36)
	item.BackgroundColor3 = Color3.fromRGB(35,35,35)

	local itemCorner = Instance.new("UICorner")
	itemCorner.CornerRadius = UDim.new(0,6)
	itemCorner.Parent = item

	local avatar = Instance.new("ImageLabel")
	avatar.Parent = item
	avatar.Size = UDim2.new(0,30,0,30)
	avatar.Position = UDim2.new(0,3,0,3)
	avatar.BackgroundTransparency = 1

	local thumb = Players:GetUserThumbnailAsync(data.Id, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
	avatar.Image = thumb

	local name = Instance.new("TextButton")
	name.Parent = item
	name.Size = UDim2.new(1,-40,1,0)
	name.Position = UDim2.new(0,40,0,0)
	name.BackgroundTransparency = 1
	name.Text = data.Username
	name.Font = Enum.Font.GothamBold
	name.TextColor3 = Color3.fromRGB(255,255,255)
	name.TextSize = 13
	name.TextXAlignment = Enum.TextXAlignment.Left

	name.MouseButton1Click:Connect(function()

		selectedFriend = data.Username

		for _,v in pairs(friendList:GetChildren()) do
			if v:IsA("Frame") then
				v.BackgroundColor3 = Color3.fromRGB(35,35,35)
			end
		end

		item.BackgroundColor3 = Color3.fromRGB(60,120,60)

	end)

end

-- LOAD FRIENDS
local function loadFriends()

	for _,v in pairs(friendList:GetChildren()) do
		if v:IsA("Frame") then
			v:Destroy()
		end
	end

	friendsCache = {}

	local success, pages = pcall(function()
		return Players:GetFriendsAsync(player.UserId)
	end)

	if not success then return end

	repeat

		local friends = pages:GetCurrentPage()

		for _,data in pairs(friends) do
			table.insert(friendsCache,data)
			createFriendItem(data)
		end

		if not pages.IsFinished then
			pages:AdvanceToNextPageAsync()
		end

	until pages.IsFinished

end

-- SEARCH SYSTEM
searchBox:GetPropertyChangedSignal("Text"):Connect(function()

	local text = string.lower(searchBox.Text)

	for _,v in pairs(friendList:GetChildren()) do
		if v:IsA("Frame") then
			local name = v:FindFirstChildOfClass("TextButton")
			if name then
				v.Visible = string.find(string.lower(name.Text),text) ~= nil
			end
		end
	end

end)

refreshBtn.MouseButton1Click:Connect(loadFriends)

loadFriends()

createToggle("Friend Tracker",function(state)
	friendGui.Visible = state
end)
