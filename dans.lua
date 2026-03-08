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

--------------------------------------------------
-- INTRO ANIMATION
--------------------------------------------------

local intro = Instance.new("TextLabel")
intro.Size = UDim2.new(0,400,0,80)
intro.Position = UDim2.new(0.5,-200,0.6,0)
intro.BackgroundTransparency = 1
intro.Text = "dansskiee"
intro.Font = Enum.Font.GothamBlack
intro.TextScaled = true
intro.TextColor3 = Color3.new(1,1,1)
intro.TextTransparency = 1
intro.Parent = gui

TweenService:Create(intro,TweenInfo.new(1),{
TextTransparency = 0,
Position = UDim2.new(0.5,-200,0.45,0)
}):Play()

task.wait(2)

TweenService:Create(intro,TweenInfo.new(1),{
TextTransparency = 1,
Position = UDim2.new(0.5,-200,0.35,0)
}):Play()

task.wait(1)
intro:Destroy()

--------------------------------------------------
-- MAIN FRAME (SAMA SEPERTI AWAL)
--------------------------------------------------

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,300,0,260)
frame.Position = UDim2.new(0,100,0,100)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,35)
title.BackgroundColor3 = Color3.fromRGB(35,35,35)
title.Text = "Dan Hub"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 18
title.Font = Enum.Font.SourceSansBold
title.Parent = frame

--------------------------------------------------
-- MINIMIZE BUTTON
--------------------------------------------------

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0,30,0,20)
minimize.Position = UDim2.new(1,-35,0,7)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(50,50,50)
minimize.TextColor3 = Color3.new(1,1,1)
minimize.Parent = title

--------------------------------------------------
-- CONTAINER
--------------------------------------------------

local container = Instance.new("Frame")
container.Size = UDim2.new(1,0,1,-35)
container.Position = UDim2.new(0,0,0,35)
container.BackgroundTransparency = 1
container.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,5)
layout.Parent = container

--------------------------------------------------
-- DRAG SYSTEM (DIPERBAIKI)
--------------------------------------------------

local dragging = false
local dragStart
local startPos

title.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
dragging = true
dragStart = input.Position
startPos = frame.Position
end
end)

title.InputEnded:Connect(function(input)
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

--------------------------------------------------
-- MINIMIZE LOGIC
--------------------------------------------------

local minimized = false

minimize.MouseButton1Click:Connect(function()

minimized = not minimized

if minimized then
container.Visible = false
frame.Size = UDim2.new(0,300,0,35)
minimize.Text = "+"
else
container.Visible = true
frame.Size = UDim2.new(0,300,0,260)
minimize.Text = "-"
end

end)

--------------------------------------------------
-- TOGGLE BUTTON
--------------------------------------------------

local function createToggle(text,callback)

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1,-10,0,35)
btn.Position = UDim2.new(0,5,0,0)
btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
btn.TextColor3 = Color3.new(1,1,1)
btn.Text = text.." : OFF"
btn.Font = Enum.Font.SourceSans
btn.TextSize = 16
btn.Parent = container

local state = false

btn.MouseButton1Click:Connect(function()

state = not state
btn.Text = text.." : "..(state and "ON" or "OFF")

callback(state)

end)

end

--------------------------------------------------
-- FEATURES
--------------------------------------------------

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

--------------------------------------------------
-- SYSTEMS
--------------------------------------------------

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
