local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SwitchGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local switch = Instance.new("Frame")
switch.Size = UDim2.new(0, 100, 0, 50)
switch.Position = UDim2.new(1, -120, 1, -100)
switch.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
switch.Parent = screenGui
switch.Active = true
switch.Draggable = true

local switchCorner = Instance.new("UICorner")
switchCorner.CornerRadius = UDim.new(1, 0)
switchCorner.Parent = switch

local knob = Instance.new("Frame")
knob.Size = UDim2.new(0, 46, 0, 46)
knob.Position = UDim2.new(0, 2, 0, 2)
knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
knob.Parent = switch

local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1, 0)
knobCorner.Parent = knob

local running = false
local loopThread = nil

local function unanchorCharacter()
	local char = player.Character or player.CharacterAdded:Wait()
	for _, v in pairs(char:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Anchored = false
		end
	end
end

local function startLoop()
	if loopThread then return end
	
	loopThread = task.spawn(function()
		while running do
			local args = {
				CFrame.new(-3.624049663543701, 4.006000518798828, -41.14439392089844, 0, 0, 1, 0, 1, 0, -1, 0, 0)
			}

			ReplicatedStorage:WaitForChild("LarpRE"):FireServer(unpack(args))
			task.wait(0.1)
		end
		loopThread = nil
	end)
end

local function updateSwitch()
	if running then
		TweenService:Create(switch, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(0, 170, 0)
		}):Play()

		TweenService:Create(knob, TweenInfo.new(0.2), {
			Position = UDim2.new(1, -48, 0, 2)
		}):Play()
	else
		TweenService:Create(switch, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(80, 80, 80)
		}):Play()

		TweenService:Create(knob, TweenInfo.new(0.2), {
			Position = UDim2.new(0, 2, 0, 2)
		}):Play()
	end
end

switch.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		running = not running
		updateSwitch()

		if running then
			startLoop()
		else
			unanchorCharacter()
			local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
			end
		end
	end
end)
