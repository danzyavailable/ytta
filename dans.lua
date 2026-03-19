-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local Stats = game:GetService("Stats")
local workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- DELETE OLD GUI
local old = playerGui:FindFirstChild("DansskieeGui")
if old then old:Destroy() end

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DansskieeGui"
ScreenGui.Parent = playerGui
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18,18,18)
MainFrame.Position = UDim2.new(0.02,0,0.45,0)
MainFrame.Size = UDim2.new(0,250,0,240)
MainFrame.Active = true

local corner = Instance.new("UICorner",MainFrame)
corner.CornerRadius = UDim.new(0,15)

-- TITLE
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1,0,0,45)
Title.BackgroundColor3 = Color3.fromRGB(25,25,25)
Title.Text = "Script By Dansskiee"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(255,255,255)

local titleCorner = Instance.new("UICorner",Title)
titleCorner.CornerRadius = UDim.new(0,15)

-- MINIMIZE
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Parent = MainFrame
MinimizeBtn.Size = UDim2.new(0,30,0,30)
MinimizeBtn.Position = UDim2.new(1,-35,0,7)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "▼"
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 18
MinimizeBtn.TextColor3 = Color3.new(1,1,1)

-- CONTAINER
local Container = Instance.new("ScrollingFrame")
Container.Parent = MainFrame
Container.Position = UDim2.new(0,10,0,55)
Container.Size = UDim2.new(1,-20,0,150)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 4
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y

local UIListLayout = Instance.new("UIListLayout",Container)
UIListLayout.Padding = UDim.new(0,8)

-- FOOTER
local Footer = Instance.new("TextLabel")
Footer.Parent = MainFrame
Footer.Size = UDim2.new(1,0,0,25)
Footer.Position = UDim2.new(0,0,1,-25)
Footer.BackgroundTransparency = 1
Footer.Text = "Tiktok = @dansskiee2"
Footer.Font = Enum.Font.GothamBold
Footer.TextSize = 11
Footer.TextColor3 = Color3.fromRGB(200,200,200)

-- MINIMIZE SYSTEM
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

-- DRAG SYSTEM
local dragging
local dragStart
local startPos

Title.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position

	end

end)

Title.InputEnded:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end

end)

UserInputService.InputChanged:Connect(function(input)

	if dragging then

		local delta = input.Position - dragStart

		MainFrame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)

	end

end)

-- TOGGLE CREATOR
local function createToggle(name,callback)

	local btn = Instance.new("TextButton")
	btn.Parent = Container
	btn.Size = UDim2.new(1,-10,0,35)
	btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
	btn.Text = name.." : OFF"
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.TextColor3 = Color3.new(1,1,1)

	local corner = Instance.new("UICorner",btn)
	corner.CornerRadius = UDim.new(0,8)

	local state = false

	btn.MouseButton1Click:Connect(function()

		state = not state
		btn.Text = name.." : "..(state and "ON" or "OFF")
		btn.BackgroundColor3 = state and Color3.fromRGB(50,150,50) or Color3.fromRGB(30,30,30)

		callback(state)

	end)

end

-- =========================
-- INFINITE JUMP
-- =========================

local InfiniteJump = false

createToggle("Infinite Jump",function(state)
	InfiniteJump = state
end)

UserInputService.JumpRequest:Connect(function()

	if InfiniteJump then

		local char = player.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				hum:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end

	end

end)

-- =========================
-- NOCLIP
-- =========================

local noclip = false

createToggle("Noclip",function(state)
	noclip = state
end)

RunService.Stepped:Connect(function()

	if noclip then

		local char = player.Character
		if char then
			for _,v in pairs(char:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end
		end

	end

end)

-- =========================
-- FLY SYSTEM
-- =========================

local flying = false
local bg
local bv
local speed = 60

local function startFly()

	local char = player.Character
	if not char then return end

	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")

	if not hum or not root then return end

	hum.PlatformStand = true

	bg = Instance.new("BodyGyro",root)
	bg.P = 9e4
	bg.maxTorque = Vector3.new(9e9,9e9,9e9)

	bv = Instance.new("BodyVelocity",root)
	bv.maxForce = Vector3.new(9e9,9e9,9e9)

	RunService.RenderStepped:Connect(function()

		if not flying then return end

		local cam = workspace.CurrentCamera
		local move = hum.MoveDirection

		bv.Velocity = cam.CFrame:VectorToWorldSpace(move) * speed
		bg.CFrame = cam.CFrame

	end)

end

local function stopFly()

	local char = player.Character
	if not char then return end

	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.PlatformStand = false
	end

	if bg then bg:Destroy() end
	if bv then bv:Destroy() end

end

createToggle("Fly",function(state)

	flying = state

	if state then
		startFly()
	else
		stopFly()
	end

end)

-- =========================
-- FPS & PING
-- =========================

local fpsGui = Instance.new("Frame")
fpsGui.Parent = ScreenGui
fpsGui.Size = UDim2.new(0,150,0,40)
fpsGui.Position = UDim2.new(1,-170,0,10)
fpsGui.BackgroundColor3 = Color3.fromRGB(20,20,20)
fpsGui.Visible = false

local fpsCorner = Instance.new("UICorner",fpsGui)

local fpsText = Instance.new("TextLabel")
fpsText.Parent = fpsGui
fpsText.Size = UDim2.new(1,0,1,0)
fpsText.BackgroundTransparency = 1
fpsText.Font = Enum.Font.GothamBold
fpsText.TextColor3 = Color3.new(1,1,1)
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

createToggle("Change Server",function(state)

	if state then
		TeleportService:Teleport(game.PlaceId,player)
	end

end)
