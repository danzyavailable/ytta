local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MinimizeBtn = Instance.new("TextButton")
local Footer = Instance.new("TextLabel")

-- BAGIAN UTAMA: Menggunakan ScrollingFrame
local Container = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

-- Hapus GUI lama jika ada (Biar tidak tumpuk saat re-execute)
local oldGui = game.CoreGui:FindFirstChild("DansskieeGui")
if oldGui then oldGui:Destroy() end
ScreenGui.Name = "DansskieeGui"
ScreenGui.Parent = game.CoreGui

-- Main Frame Setup
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 250, 0, 240)
MainFrame.Active = true
MainFrame.Draggable = true -- Simple dragging

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 15)

-- Title Setup
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "Script By Dansskiee"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 15)

-- Minimize Button
MinimizeBtn.Parent = MainFrame
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -35, 0, 7)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "▼"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 18

local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    MainFrame:TweenSize(minimized and UDim2.new(0, 250, 0, 45) or UDim2.new(0, 250, 0, 240), "Out", "Quart", 0.3, true)
    Container.Visible = not minimized
    Footer.Visible = not minimized
    MinimizeBtn.Text = minimized and "▲" or "▼"
end)

-- Scrolling Container Setup
Container.Parent = MainFrame
Container.Position = UDim2.new(0, 10, 0, 55)
Container.Size = UDim2.new(1, -20, 0, 150) -- Ukuran area scroll
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.CanvasSize = UDim2.new(0, 0, 0, 0) -- Otomatis memanjang
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
Container.ScrollBarThickness = 4
Container.ScrollingDirection = Enum.ScrollingDirection.Y

UIListLayout.Parent = Container
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Footer
Footer.Parent = MainFrame
Footer.Size = UDim2.new(1, 0, 0, 25)
Footer.Position = UDim2.new(0, 0, 1, -25)
Footer.BackgroundTransparency = 1
Footer.Text = "Tiktok = @dansskiee2"
Footer.TextColor3 = Color3.fromRGB(200, 200, 200)
Footer.Font = Enum.Font.GothamBold
Footer.TextSize = 11

-- Fungsi Create Toggle
local function createToggle(txt, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, -10, 0, 35) -- Kasih gap dikit buat scrollbar
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = txt .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local enabled = false  
    btn.MouseButton1Click:Connect(function()  
        enabled = not enabled  
        btn.Text = txt .. (enabled and ": ON" or ": OFF")  
        btn.BackgroundColor3 = enabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(30, 30, 30)  
        callback(enabled)  
    end)
end

-- ========================
-- FITUR SCRIPT
-- ========================

-- Instant Interact
local instantEnabled = false
createToggle("Instant Interact", function(state)
    instantEnabled = state
    for _, v in pairs(workspace:GetDescendants()) do
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
createToggle("Infinite Jump", function(state)
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
createToggle("Noclip", function(state)
    Noclip = state
end)

RunService.Stepped:Connect(function()
    if Noclip then
        local char = player.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- FPS & Ping
local Stats = game:GetService("Stats")
local fpsGui = Instance.new("Frame")
local fpsText = Instance.new("TextLabel")

fpsGui.Parent = ScreenGui
fpsGui.Size = UDim2.new(0,150,0,40)
fpsGui.Position = UDim2.new(1,-170,0,10)
fpsGui.BackgroundColor3 = Color3.fromRGB(20,20,20)
fpsGui.Visible = false
Instance.new("UICorner", fpsGui).CornerRadius = UDim.new(0,10)

fpsText.Parent = fpsGui
fpsText.Size = UDim2.new(1,0,1,0)
fpsText.BackgroundTransparency = 1
fpsText.TextColor3 = Color3.fromRGB(255,255,255)
fpsText.Text = "FPS: 0 | Ping: 0"

local frames = 0
local lastTime = tick()
RunService.RenderStepped:Connect(function()
    frames = frames + 1
    if tick() - lastTime >= 1 then
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        fpsText.Text = "FPS: "..frames.." | Ping: "..ping.." ms"
        frames = 0
        lastTime = tick()
    end
end)

createToggle("Show FPS & Ping", function(state)
    fpsGui.Visible = state
end)

-- Server Menu
local serverFrame = Instance.new("Frame")
local serverBtn = Instance.new("TextButton")
serverFrame.Parent = ScreenGui
serverFrame.Size = UDim2.new(0,180,0,60)
serverFrame.Position = UDim2.new(0.8,0,0.3,0)
serverFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
serverFrame.Visible = false
Instance.new("UICorner",serverFrame).CornerRadius = UDim.new(0,10)

serverBtn.Parent = serverFrame
serverBtn.Size = UDim2.new(0.9,0,0,35)
serverBtn.Position = UDim2.new(0.05,0,0.2,0)
serverBtn.Text = "Rejoin Server"
Instance.new("UICorner",serverBtn).CornerRadius = UDim.new(0,8)

serverBtn.MouseButton1Click:Connect(function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, player)
end)

createToggle("Server Menu", function(state)
    serverFrame.Visible = state
end)
