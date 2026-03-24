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

--========================================
-- SPECTATE PLAYER SYSTEM (FULL)
--========================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local SpectateEnabled = false
local currentIndex = nil
local playerList = {}

--========================================
-- MAIN GUI
--========================================

local SpectateGui = Instance.new("ScreenGui")
SpectateGui.Parent = game.CoreGui
SpectateGui.Name = "SpectateGui"
SpectateGui.Enabled = false

local Main = Instance.new("Frame",SpectateGui)
Main.Size = UDim2.new(0,260,0,320)
Main.Position = UDim2.new(0.75,0,0.3,0)
Main.BackgroundColor3 = Color3.fromRGB(30,30,30)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner",Main)

local Title = Instance.new("TextLabel",Main)
Title.Size = UDim2.new(1,0,0,35)
Title.BackgroundTransparency = 1
Title.Text = "Spectate Player"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

local Minimize = Instance.new("TextButton",Main)
Minimize.Size = UDim2.new(0,30,0,25)
Minimize.Position = UDim2.new(1,-35,0,5)
Minimize.Text = "-"
Minimize.BackgroundColor3 = Color3.fromRGB(60,60,60)
Minimize.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",Minimize)

local Content = Instance.new("Frame",Main)
Content.Size = UDim2.new(1,0,1,-40)
Content.Position = UDim2.new(0,0,0,40)
Content.BackgroundTransparency = 1

local Scroll = Instance.new("ScrollingFrame",Content)
Scroll.Size = UDim2.new(1,-10,1,0)
Scroll.Position = UDim2.new(0,5,0,0)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0

local Layout = Instance.new("UIListLayout",Scroll)
Layout.Padding = UDim.new(0,4)

--========================================
-- CONTROL BAR (BOTTOM)
--========================================

local ControlGui = Instance.new("ScreenGui")
ControlGui.Parent = game.CoreGui
ControlGui.Enabled = false

local ControlFrame = Instance.new("Frame",ControlGui)
ControlFrame.Size = UDim2.new(0,220,0,50)
ControlFrame.Position = UDim2.new(0.5,-110,1,-90)
ControlFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
ControlFrame.BorderSizePixel = 0
Instance.new("UICorner",ControlFrame)

local PrevBtn = Instance.new("TextButton",ControlFrame)
PrevBtn.Size = UDim2.new(0.3,0,0.8,0)
PrevBtn.Position = UDim2.new(0.05,0,0.1,0)
PrevBtn.Text = "<"
PrevBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
PrevBtn.TextColor3 = Color3.new(1,1,1)
PrevBtn.Font = Enum.Font.GothamBold
PrevBtn.TextSize = 18
Instance.new("UICorner",PrevBtn)

local ExitBtn = Instance.new("TextButton",ControlFrame)
ExitBtn.Size = UDim2.new(0.3,0,0.8,0)
ExitBtn.Position = UDim2.new(0.35,0,0.1,0)
ExitBtn.Text = "Keluar"
ExitBtn.BackgroundColor3 = Color3.fromRGB(200,60,60)
ExitBtn.TextColor3 = Color3.new(1,1,1)
ExitBtn.Font = Enum.Font.GothamBold
ExitBtn.TextSize = 14
Instance.new("UICorner",ExitBtn)

local NextBtn = Instance.new("TextButton",ControlFrame)
NextBtn.Size = UDim2.new(0.3,0,0.8,0)
NextBtn.Position = UDim2.new(0.65,0,0.1,0)
NextBtn.Text = ">"
NextBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
NextBtn.TextColor3 = Color3.new(1,1,1)
NextBtn.Font = Enum.Font.GothamBold
NextBtn.TextSize = 18
Instance.new("UICorner",NextBtn)

--========================================
-- PLAYER LIST
--========================================

local function refreshList()

playerList = {}

for _,v in pairs(Scroll:GetChildren()) do
	if v:IsA("TextButton") then
		v:Destroy()
	end
end

for _,plr in pairs(Players:GetPlayers()) do

	if plr ~= LocalPlayer then

		table.insert(playerList,plr)

		local btn = Instance.new("TextButton",Scroll)
		btn.Size = UDim2.new(1,-5,0,30)
		btn.Text = plr.Name
		btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
		btn.TextColor3 = Color3.new(1,1,1)
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 14
		Instance.new("UICorner",btn)

		btn.MouseButton1Click:Connect(function()

			currentIndex = table.find(playerList,plr)

			if plr.Character and plr.Character:FindFirstChild("Humanoid") then
				Camera.CameraSubject = plr.Character.Humanoid
				ControlGui.Enabled = true
			end

		end)

	end

end

task.wait()
Scroll.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y)

end

refreshList()

Players.PlayerAdded:Connect(refreshList)
Players.PlayerRemoving:Connect(refreshList)

--========================================
-- CONTROL BUTTONS
--========================================

NextBtn.MouseButton1Click:Connect(function()

if not currentIndex then return end

currentIndex += 1
if currentIndex > #playerList then
	currentIndex = 1
end

local plr = playerList[currentIndex]

if plr and plr.Character and plr.Character:FindFirstChild("Humanoid") then
	Camera.CameraSubject = plr.Character.Humanoid
end

end)

PrevBtn.MouseButton1Click:Connect(function()

if not currentIndex then return end

currentIndex -= 1
if currentIndex < 1 then
	currentIndex = #playerList
end

local plr = playerList[currentIndex]

if plr and plr.Character and plr.Character:FindFirstChild("Humanoid") then
	Camera.CameraSubject = plr.Character.Humanoid
end

end)

ExitBtn.MouseButton1Click:Connect(function()

if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
	Camera.CameraSubject = LocalPlayer.Character.Humanoid
end

currentIndex = nil
ControlGui.Enabled = false

end)

--========================================
-- MINIMIZE (SMOOTH)
--========================================

local minimized = false

Minimize.MouseButton1Click:Connect(function()

minimized = not minimized

if minimized then

	TweenService:Create(
		Main,
		TweenInfo.new(0.25),
		{Size = UDim2.new(0,260,0,40)}
	):Play()

	Content.Visible = false

else

	TweenService:Create(
		Main,
		TweenInfo.new(0.25),
		{Size = UDim2.new(0,260,0,320)}
	):Play()

	Content.Visible = true

end

end)

--========================================
-- TOGGLE FUNCTION
--========================================

function ToggleSpectate()

SpectateEnabled = not SpectateEnabled
SpectateGui.Enabled = SpectateEnabled

end
