-- ✅ TINIEST Draggable "DUPING METHOD" Button (Mobile + PC Fixed)
-- 50x50 round button + Press R on PC

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Persistent ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DUPING_METHOD_GUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame (50x50)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "DUPING_METHOD_FRAME"
mainFrame.Size = UDim2.new(0, 50, 0, 50)
mainFrame.Position = UDim2.new(0.5, -25, 0, 30)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 110, 255)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

-- Make it a perfect circle
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = mainFrame

-- Invisible button overlay with text
local dupingButton = Instance.new("TextButton")
dupingButton.Name = "DUPING_METHOD_BUTTON"
dupingButton.Size = UDim2.new(1, 0, 1, 0)
dupingButton.BackgroundTransparency = 1
dupingButton.Text = "DUPING\nMETHOD"
dupingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
dupingButton.TextScaled = true
dupingButton.Font = Enum.Font.GothamBold
dupingButton.TextWrapped = true
dupingButton.Parent = mainFrame

-- === DRAG SYSTEM ===
local dragging = false
local dragStart = nil
local startPos = nil

local function updateDrag(input)
    if not dragging then return end
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

-- Drag on button (for both mouse and touch)
dupingButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        -- Auto release when finger/mouse lifts
        local conn
        conn = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                conn:Disconnect()
            end
        end)
    end
end)

dupingButton.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                     input.UserInputType == Enum.UserInputType.Touch) then
        updateDrag(input)
    end
end)

-- Global fallback (very important for tiny button on mobile)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                     input.UserInputType == Enum.UserInputType.Touch) then
        updateDrag(input)
    end
end)

-- === TRIGGER FUNCTIONS ===
local function triggerDupingMethod()
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.Health = 0
        task.delay(0.1, function()
            if player.Character then
                player:LoadCharacter()
            end
        end)
    end
end

-- Click on button (works on both mobile and PC)
dupingButton.MouseButton1Click:Connect(triggerDupingMethod)

-- Press R on keyboard (PC only)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.R then
        triggerDupingMethod()
    end
end)

print("✅ TINIEST DUPING METHOD button loaded!")
print("• Drag the tiny blue circle (works on mobile)")
print("• Click the button or press R on PC to trigger")
