local API = {}

-- Define private players
local privatePlayers = {
    ["snoopyprivateismean"] = true, -- Example player name
    ["volvxlx"] = true
}

-- Function to create a button
function API.CreateButton(parent, buttonText, position, size, callback)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.Text = buttonText
    button.Position = position
    button.Size = size
    button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSans
    button.TextColor3 = Color3.fromRGB(0, 0, 0)
    button.TextSize = 14

    -- Adding stroke to the button
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Parent = button
    uiStroke.Color = Color3.fromRGB(0, 0, 0)
	uiStroke.Thickness = 2
	uiStroke.ApplyStrokeMode = "Border"

    button.MouseButton1Click:Connect(callback)

    return button
end

-- Function to check if player is private
local function IsPrivatePlayer(playerName)
    return privatePlayers[playerName] == true
end

-- Main GUI creation
local function CreateMainGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    screenGui.Name = "AsteriskClientGUI"

    local mainButton = API.CreateButton(screenGui, "AsteriskClient", UDim2.new(0.5, -50, 0, 100), UDim2.new(0, 100, 0, 50), function()
        local frame = Instance.new("Frame")
        frame.Parent = screenGui
        frame.Position = UDim2.new(0.5, -150, 0, 160)
        frame.Size = UDim2.new(0, 300, 0, 300)
		frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		API.CreateButton(frame, "X", UDim2.new(0.5, -200, 0, 160), UDim2.new(0, 50, 0, 50), function()
			frame.Visible = false
		end)

        -- Regular features
		API.CreateButton(frame, "Speed", UDim2.new(0, 10, 0, 10), UDim2.new(0, 80, 0, 30), function()
			print("Speed Activated") 
			local player = game.Players.LocalPlayer
			local hum = player.Character.Humanoid
			hum.WalkSpeed = 23
		end)
		API.CreateButton(frame, "Bodyguard", UDim2.new(0, 10, 0, 50), UDim2.new(0, 80, 0, 30), function()
			print("Bodyguard Activated") 
			for i, v in pairs(game:GetService("Players"):GetChildren()) do


				if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Team ~= game.Players.LocalPlayer.Team then
					print(v.Name)
					repeat wait(0.2)
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
					until v.Character.Humanoid.Health == 0 or not v.Character:FindFirstChild("Humanoid")
				end
			end
		end)
		API.CreateButton(frame, "PlayerLevel50", UDim2.new(0, 10, 0, 90), UDim2.new(0, 80, 0, 30), function()
			print("PlayerLevel50 Activated")
			game.Players.LocalPlayer:SetAttribute("PlayerLevel", 50)
		end)
		API.CreateButton(frame, "ESP", UDim2.new(0, 10, 0, 130), UDim2.new(0, 80, 0, 30), function()
			print("ESP Activated") 
			local FillColor = Color3.fromRGB(175,25,255)
			local DepthMode = "AlwaysOnTop"
			local FillTransparency = 0.5
			local OutlineColor = Color3.fromRGB(255,255,255)
			local OutlineTransparency = 0

			local CoreGui = game:FindService("CoreGui")
			local Players = game:FindService("Players")
			local lp = Players.LocalPlayer
			local connections = {}

			local Storage = Instance.new("Folder")
			Storage.Parent = CoreGui
			Storage.Name = "Highlight_Storage"

			local function Highlight(plr)
				local Highlight = Instance.new("Highlight")
				Highlight.Name = plr.Name
				Highlight.FillColor = FillColor
				Highlight.DepthMode = DepthMode
				Highlight.FillTransparency = FillTransparency
				Highlight.OutlineColor = OutlineColor
				Highlight.OutlineTransparency = 0
				Highlight.Parent = Storage

				local plrchar = plr.Character
				if plrchar then
					Highlight.Adornee = plrchar
				end

				connections[plr] = plr.CharacterAdded:Connect(function(char)
					Highlight.Adornee = char
				end)
			end

			Players.PlayerAdded:Connect(Highlight)
			for i,v in next, Players:GetPlayers() do
				Highlight(v)
			end

			Players.PlayerRemoving:Connect(function(plr)
				local plrname = plr.Name
				if Storage[plrname] then
					Storage[plrname]:Destroy()
				end
				if connections[plr] then
					connections[plr]:Disconnect()
				end
			end)
		end)
		API.CreateButton(frame, "HostPanel", UDim2.new(0, 10, 0, 170), UDim2.new(0, 80, 0, 30), function()
			print("HostPanel Activated") 
			game.Players.LocalPlayer:SetAttribute("CustomMatchRole", "host")
		end)
		API.CreateButton(frame, "coolkid skybox", UDim2.new(0, 10, 0, 210), UDim2.new(0, 80, 0, 30), function()
			print("skybox Activated") 
			s = Instance.new("Sky")
			s.Name = "SKY"
			s.SkyboxBk = "http://www.roblox.com/asset/?id=358313209"
			s.SkyboxDn = "http://www.roblox.com/asset/?id=358313209"
			s.SkyboxFt = "http://www.roblox.com/asset/?id=358313209"
			s.SkyboxLf = "http://www.roblox.com/asset/?id=358313209"
			s.SkyboxRt = "http://www.roblox.com/asset/?id=358313209"
			s.SkyboxUp = "http://www.roblox.com/asset/?id=358313209"
			s.Parent = game.Lighting
		end)

        -- Private features
        if IsPrivatePlayer(game.Players.LocalPlayer.Name) then
			API.CreateButton(frame, "SwordTexture", UDim2.new(0, 100, 0, 10), UDim2.new(0, 80, 0, 30), function()
				print("SwordTexture Activated") 
				workspace.CurrentCamera.Viewmodel.ChildAdded:Connect(function(x)
					if x and x:FindFirstChild("Handle") then
						if string.find(x.Name:lower(), 'sword') then
							x.Handle.Material = "ForceField"
							x.Handle.MeshId = "rbxassetid://13471207377"
							x.Handle.BrickColor = BrickColor.new("Hot pink")
						end
					end
				end)
			end)
			API.CreateButton(frame, "CrashAll (COMING SOON)", UDim2.new(0, 100, 0, 50), UDim2.new(0, 80, 0, 30), function()
				print("CrashAll Activated") 
			end)
        end
    end)
end

CreateMainGUI()

return API
