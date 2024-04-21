local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- List of private users who can access exclusive features
local privateUsers = {
    ["volvxlx"] = true,
    ["snoopyprivateismean"] = true,
}

-- Function to check if a player is a private user
local function isPrivateUser(playerName)
    return privateUsers[playerName] or false
end

-- Create the menu GUI
local screenGui = Instance.new("ScreenGui", script.Parent)
screenGui.Name = "AsteriskMenu"

local menuFrame = Instance.new("Frame", screenGui)
menuFrame.Size = UDim2.new(0.3, 0, 0.5, 0)
menuFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
menuFrame.Visible = false

local function createButton(text, position, callback)
    local btn = Instance.new("TextButton", menuFrame)
    btn.Text = text
    btn.Size = UDim2.new(0.8, 0, 0.05, 0)
    btn.Position = position
    btn.MouseButton1Click:Connect(callback)
end

-- Function to create a notification
function createNotification(parent, name, text, duration)
	local notification = Instance.new("TextLabel")
	notification.Parent = parent
	notification.Name = name
	notification.Text = text
	notification.Size = UDim2.new(0, 200, 0, 50)
	notification.Position = UDim2.new(0.5, -100, 0, -50) -- Center top
	notification.BackgroundColor3 = Color3.new(1, 1, 1)
	notification.TextColor3 = Color3.new(0, 0, 0)

	-- Auto-remove after duration
	task.delay(duration, function()
		notification:Destroy()
	end)
end

-- Buttons
local function speed()
	createNotification(screenGui, "Name", "Speed Enabled!", 5)
	local player = game.Players.LocalPlayer
	local hum = player.Character:FindFirstChild("Humanoid")
	if hum then
		hum.WalkSpeed = 23
	end
end

local function bg()
	createNotification(screenGui, "Name", "Bodyguard Enabled!", 5)
	for i, v in pairs(game:GetService("Players"):GetChildren()) do


		if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Team ~= game.Players.LocalPlayer.Team then
			print(v.Name)
			repeat wait(0.2)
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
			until v.Character.Humanoid.Health == 0 or not v.Character:FindFirstChild("Humanoid")
		end
	end
end

local function HostPanel()
	createNotification(screenGui, "Name", "HostPanel Enabled!", 5)
	game.Players.LocalPlayer:SetAttribute("CustomMatchRole", "host")
end

local function PL50()
	createNotification(screenGui, "Name", "PlayerLevel50 Enabled!", 5)
	game.Players.LocalPlayer:SetAttribute("PlayerLevel", 50)
end

local function esp(targetPlayer)
	createNotification(screenGui, "Name", "ESP Enabled!", 5)
	local character = targetPlayer.Character
	if not character then return end

	-- Check if ESP already exists to avoid duplicates
	if character:FindFirstChild("ESPBox") then return end

	-- Create a BillboardGui for ESP visuals
	local espBox = Instance.new("BillboardGui")
	espBox.Name = "ESPBox"
	espBox.Adornee = character:FindFirstChild("HumanoidRootPart")
	espBox.Size = UDim2.new(0, 100, 0, 100)
	espBox.StudsOffset = Vector3.new(0, 2, 0)
	espBox.AlwaysOnTop = true
	espBox.Parent = character

	-- Create a Frame inside the BillboardGui for visibility
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundTransparency = 0.5
	frame.BackgroundColor3 = Color3.new(1, 0, 0) -- Red color for visibility
	frame.BorderSizePixel = 0
	frame.Parent = espBox
end

-- Create buttons
createButton("Speed", UDim2.new(0.1, 0, 0.05, 0), speed)
createButton("Bodyguard", UDim2.new(0.1, 0, 0.10, 0), bg)
createButton("HostPanel", UDim2.new(0.1, 0, 0.15, 0), HostPanel)
createButton("ESP", UDim2.new(0.1, 0, 0.20, 0), esp)
createButton("PlayerLevel50", UDim2.new(0.1, 0, 0.25, 0), PL50)


-- Toggle menu visibility
local button = Instance.new("TextButton")
button.Text = "Asterisk Client"
button.Size = UDim2.new(0.2, 0, 0.1, 0)
button.Position = UDim2.new(0.4, 0, 0.85, 0)
button.Parent = screenGui

-- Function to handle button click
local function toggleFrame()
	menuFrame.Visible = not menuFrame.Visible -- Toggle visibility of the frame
end

-- Connect the toggleFrame function to the button's Click event
button.MouseButton1Click:Connect(toggleFrame)

-- Check if the local player is a private user and adjust the menu accordingly
local localPlayer = Players.LocalPlayer
if isPrivateUser(localPlayer.Name) then
    -- Create buttons for private features
	createButton("PlayerLevelInfinite", UDim2.new(0.1, 0, 0.30, 0), function()
		createNotification(screenGui, "Name", "PlayerLevelInfinite Enabled!", 5)
		game.Players.LocalPlayer:SetAttribute("PlayerLevel", math.huge)
	end)
	createButton("KickAll", UDim2.new(0.1, 0, 0.35, 0), function()
		createNotification(screenGui, "Name", "KickAll Enabled!", 5)
		for _, player in ipairs(Players:GetPlayers()) do
			player:Kick("KICKED BY ASTERISK PRIVATE USER! GET KICKED!")
		end
	end)
end
