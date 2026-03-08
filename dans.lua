-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- VARIABLES
local fly = false
local flySpeed = 50
local godmode = false
local instantInteract = false
local infiniteJump = false

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "DanHub"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

-------------------------------------------------
-- INTRO ANIMATION
-------------------------------------------------

local introFrame = Instance.new("Frame")
introFrame.Size = UDim2.new(1,0,1,0)
introFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
introFrame.BackgroundTransparency = 1
introFrame.Parent = gui

local introText = Instance.new("TextLabel")
introText.Size = UDim2.new(0,400,0,80)
introText.Position = UDim2.new(0.5,-200,0.6,0)
introText.BackgroundTransparency = 1
introText.Text = "dansskiee"
introText.TextScaled = true
introText.Font = Enum.Font.GothamBlack
introText.TextColor3 = Color3.fromRGB(255,255,255)
introText.TextTransparency = 1
introText.Parent = introFrame

local glow = Instance.new("UIStroke")
glow.Color = Color3.fromRGB(120,120,255)
glow.Thickness = 2
glow.Parent = introText

TweenService:Create(introFrame,TweenInfo.new(0.6),{
BackgroundTransparency = 0.2
}):Play()

TweenService:Create(introText,TweenInfo.new(1,Enum.EasingStyle.Quart),{
TextTransparency = 0,
Position = UDim2.new(0.5,-200,0.45,0)
}):Play()

task.wait(2)

TweenService:Create(introFrame,TweenInfo.new(1),{
BackgroundTransparency = 1
}):Play()

TweenService:Create(introText,TweenInfo.new(1),{
TextTransparency = 1
}):Play()

task.wait(1)

introFrame:Destroy()

-------------------------------------------------
-- MAIN FRAME
-------------------------------------------------

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,320,0,240)
frame.Position = UDim2.new(0,120,0,120)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,8)
corner.Parent = frame

-------------------------------------------------
-- TITLE BAR
-------------------------------------------------

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,36)
titleBar.BackgroundColor3 = Color3.fromRGB(40,40,40)
titleBar.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0,8)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-40,1,0)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "Dan Hub"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-------------------------------------------------
-- MINIMIZE BUTTON
-------------------------------------------------

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0,30,0,24)
minimize.Position = UDim2.new(1,-34,0,6)
minimize.Text = "-"
minimize.TextSize = 18
minimize.Font = Enum.Font.GothamBold
minimize.BackgroundColor3 = Color3.fromRGB(60,60,60)
minimize.TextColor3 = Color3.new(1,1,1)
minimize.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0,6)
minCorner.Parent = minimize

-------------------------------------------------
-- CONTAINER
-------------------------------------------------

local container = Instance.new("Frame")
container.Size = UDim2.new(1,-10,1,-46)
container.Position = UDim2.new(0,5,0,40)
container.BackgroundTransparency = 1
container.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,6)
layout.Parent = container

-------------------------------------------------
-- DRAG SYSTEM
-------------------------------------------------

local dragging = false
local dragStart
local startPos

titleBar.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
dragging = true
dragStart = input.Position
startPos = frame.Position
end
end)

titleBar.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
dragging = false
end
end)

UIS.InputChanged:Connect(function(input)
if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
local delta = input.Position - dragStart
frame.Position = UDim2.new(
startPos.X.Scale,
startPos.X.Offset + delta.X,
startPos.Y.Scale,
startPos.Y.Offset + delta.Y
)
end
end)

-------------------------------------------------
-- MINIMIZE LOGIC
-------------------------------------------------

local minimized = false

minimize.MouseButton1Click:Connect(function()

minimized = not minimized

if minimized then
container.Visible = false
frame.Size = UDim2.new(0,320,0,36)
minimize.Text = "+"
else
container.Visible = true
frame.Size = UDim2.new(0,320,0,240)
minimize.Text = "-"
end

end)

-------------------------------------------------
-- TOGGLE CREATOR
-------------------------------------------------

local function createToggle(text,callback)

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1,0,0,34)
btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
btn.TextColor3 = Color3.new(1,1,1)
btn.Text = text.." : OFF"
btn.Font = Enum.Font.Gotham
btn.TextSize = 15
btn.Parent = container

local c = Instance.new("UICorner")
c.CornerRadius = UDim.new(0,6)
c.Parent = btn

local state = false

btn.MouseButton1Click:Connect(function()

state = not state

btn.Text = text.." : "..(state and "ON" or "OFF")

callback(state)

end)

end

-------------------------------------------------
-- FEATURES
-------------------------------------------------

createToggle("Fly",function(v)
fly = v
end)

createToggle("Godmode",function(v)
godmode = v
end)

createToggle("Instant Interact",function(v)
instantInteract = v
end)

createToggle("Infinite Jump",function(v)
infiniteJump = v
end)

-------------------------------------------------
-- SYSTEMS
-------------------------------------------------

RunService.RenderStepped:Connect(function()

local char = player.Character
if not char then return end

local hum = char:FindFirstChildOfClass("Humanoid")
local root = char:FindFirstChild("HumanoidRootPart")

if fly and root then
root.Velocity = Vector3.new(0,flySpeed,0)
end

if godmode and hum then
hum.Health = hum.MaxHealth
end

if instantInteract then
for _,v in pairs(workspace:GetDescendants()) do
if v:IsA("ProximityPrompt") then
fireproximityprompt(v)
end
end
end

end)

UIS.JumpRequest:Connect(function()

if infiniteJump then
local char = player.Character
if char and char:FindFirstChildOfClass("Humanoid") then
char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
end
end

end)
