
local Lplr = game.Players.LocalPlayer
local Char = Lplr.Character 
local Hum = Char.Humanoid
local LplrTeam = Lplr.Team 
local Camera = workspace.CurrentCamera
local KnitClient = debug.getupvalue(require(Lplr.PlayerScripts.TS.knit).setup, 6)
local CombatConstants = require(game:GetService("ReplicatedStorage").TS.combat["combat-constant"]).CombatConstant
local BedwarsSwords = require(game:GetService("ReplicatedStorage").TS.games.bedwars["bedwars-swords"]).BedwarsMelees
local Players = game:GetService("Players")
local LookVector = Lplr.character.HumanoidRootPart.CFrame.lookVector
local ClientHandlerStore = require(Lplr.PlayerScripts.TS.ui.store).ClientStore
local SwordController = KnitClient.Controllers.SwordController
local RS = game:GetService("RunService")
local defaultColor = Color3.new(0.1, 0.1, 0.1)
local toggleColor = Color3.fromRGB(114, 137, 218) 
local humanoidRootPart = Char:FindFirstChild("HumanoidRootPart")
local TWS = game:GetService("TweenService")
local sky = Instance.new("Sky")
local VelocityMode = false --\\This is more for antivoid
local Teams = game:GetService("Teams")
local CoreGui = game:GetService("CoreGui")
local hasTeleported = false


local NovaWare = Instance.new("ScreenGui")
NovaWare.Parent = CoreGui


local NovaWare2 = Instance.new("ScreenGui")
NovaWare2.Parent = CoreGui

local function MakeDraggable(frame)--\\Probably Should Just Used .Draggable
    local dragging
    local dragStart
    local startPos
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and dragging then
            update(input)
        end
    end)
end



--\\Top Ten Best CustomNotification :)
local function CreateNotification(options)
    local NotificationBackground = Instance.new("Frame")
    NotificationBackground.Size = UDim2.new(0.7, 0, 0.17, 0)
    NotificationBackground.Position = UDim2.new(0, 780, 0, 1000) 
    NotificationBackground.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    NotificationBackground.Parent = NovaWare2

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 6)
    uiCorner.Parent = NotificationBackground

    local uiStroke = Instance.new("UIStroke")--\\Top Ten Best Strokes
    uiStroke.Thickness = 2
    if options.Mode == "Normal" then
        uiStroke.Color = Color3.fromRGB(173, 216, 230) 
    elseif options.Mode == "Error" then
        uiStroke.Color = Color3.new(1, 0, 0) 
    elseif options.Mode == "Warning" then
        uiStroke.Color = Color3.fromRGB(255, 165, 0) 
    end
    uiStroke.Parent = NotificationBackground

--[[
if options.MyAss then
uiStroke.Color = Color3.fromRGB(139, 69, 19)
end

trol:3

]]

    local waterMark = Instance.new("TextLabel")
    waterMark.Text = "NV"
    waterMark.Size = UDim2.new(0, 0, 0, 20)
    waterMark.Position = UDim2.new(0.02, 0, 0.02, 0)
    waterMark.TextColor3 = Color3.new(1, 1, 1)
    waterMark.BackgroundTransparency = 1
    waterMark.Font = Enum.Font.SourceSansBold
    waterMark.TextSize = 17
    waterMark.Parent = NotificationBackground

    local Message = Instance.new("TextLabel")
    Message.Text = options.Text or "Error"
    Message.Size = UDim2.new(0, 20, 0, 20)
    Message.Position = options.TextPos or UDim2.new(0, 80, 0, 30)--\\ in case youre wondering why theres TextPos, well the text dosent fit to good:/
    Message.TextColor3 = Color3.new(1, 1, 1)
    Message.BackgroundTransparency = 1
    Message.Font = Enum.Font.SourceSansBold
    Message.TextSize = 20
    Message.Parent = NotificationBackground

    local timerBar = Instance.new("Frame")
    timerBar.Size = UDim2.new(0, 2, 1, 0)
    timerBar.Position = UDim2.new(0, 288, 0, 0)
    timerBar.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    timerBar.BorderSizePixel = 0
    timerBar.Parent = NotificationBackground

    local endPosition = UDim2.new(0, 780, 0, 290)

    local EntranceInfo = TweenInfo.new(
        1, 
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out, 
        0, 
        false, 
        0 
    )--\\Idk why honestly external made it look like this but ok

    local Entrance = TWS:Create(NotificationBackground, EntranceInfo, {Position = endPosition})

    Entrance:Play()

    Entrance.Completed:Connect(function()
        local countdownDuration = options.Time or 4

        local countdownTweenInfo = TweenInfo.new(countdownDuration, Enum.EasingStyle.Linear)
        local countdownTween = TWS:Create(timerBar, countdownTweenInfo, {Size = UDim2.new(0, 2, 0, 0)})

        countdownTween:Play()

        countdownTween.Completed:Connect(function()
            local ExitInfo = TweenInfo.new(
                1, 
                Enum.EasingStyle.Quad, 
                Enum.EasingDirection.Out, 
                0, 
                false, 
                0 
            )--\\Same here bru

            local Exit = TWS:Create(NotificationBackground, ExitInfo, {Position = UDim2.new(1, 0, 0, 290)})

            Exit:Play()
        end)
    end)

    return NotificationBackground
end



local function CreateTab(options)
    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(0.15, 0, 0.07, 0)
    tabFrame.Position = options.Position or UDim2.new(0.5, 0, 0.2, 0)
    tabFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    tabFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    tabFrame.BorderSizePixel = 0
    tabFrame.Parent = NovaWare
 
 
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0.3, 0)
    topCorner.Parent = tabFrame
    
    
    local FrameCorner = Instance.new("Frame")
    FrameCorner.Size = UDim2.new(1, 0, 0.5, 0) 
    FrameCorner.Position = UDim2.new(0, 0, 0.5, 0)
    FrameCorner.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1) 
    FrameCorner.BorderSizePixel = 0
    FrameCorner.Parent = tabFrame
    
    
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 23, 0, 23)
    icon.Position = UDim2.new(0, 1, 0, -12) 
    icon.Image = options.Icon or "" 
    icon.BackgroundTransparency = 1
    icon.Parent = FrameCorner
    
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(0.8, 0, 1, 0)
    textLabel.Position = UDim2.new(-0.09, 0, -0.4, 0) 
    textLabel.Text = options.Name or "Tab"
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 20 
    textLabel.Parent = FrameCorner
    
    
    MakeDraggable(tabFrame)
    
    return tabFrame
end

local function CreateToggle(options)
    local column = options.Column or 1
    local yOffset = 0
    
    if options.Parent then
        yOffset = options.Parent.Size.Y.Offset 
        for _, child in ipairs(options.Parent:GetChildren()) do
            if child:IsA("TextButton") then
                yOffset = yOffset + child.Size.Y.Offset
            end
        end
    end
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(1, 0, 0, 30)
    toggleButton.Position = UDim2.new(0, 0, 1, yOffset) 
    toggleButton.Text = ""
    toggleButton.BackgroundColor3 = defaultColor
    toggleButton.BorderSizePixel = 0
    toggleButton.AutoButtonColor = false
    toggleButton.Font = Enum.Font.SourceSansBold
    toggleButton.TextSize = 0
    toggleButton.TextColor3 = Color3.new(1, 1, 1)
    toggleButton.TextXAlignment = Enum.TextXAlignment.Left 
    toggleButton.Parent = options.Parent or frame
    
    local toggleText = Instance.new("TextLabel")
    toggleText.Size = UDim2.new(1, 0, 1, 0)
    toggleText.Position = UDim2.new(0, 5, 0, 0) 
    toggleText.BackgroundTransparency = 1
    toggleText.Text = options.Name or "Toggle"
    toggleText.TextColor3 = Color3.new(1, 1, 1)
    toggleText.Font = Enum.Font.SourceSansBold
    toggleText.TextSize = 17
    toggleText.TextXAlignment = Enum.TextXAlignment.Left
    toggleText.Parent = toggleButton
    
    local function updateToggleState()
        if options.Value then
            game:GetService("TweenService"):Create(toggleButton, TweenInfo.new(0.3), {BackgroundColor3 = toggleColor}):Play()
        else
            game:GetService("TweenService"):Create(toggleButton, TweenInfo.new(0.3), {BackgroundColor3 = defaultColor}):Play()
        end
    end

    local function toggleCallback()
        options.Value = not options.Value
        updateToggleState()
        if options.Callback then
            options.Callback(options.Value)
        end
        
        if options.SaveToFile then
            local file = options.SaveToFile
            local data = {}
            if isfile(file) then
                pcall(function()
                    data = game:GetService("HttpService"):JSONDecode(readfile(file))
                end)
            end
            data[options.Name] = options.Value
            writefile(file, game:GetService("HttpService"):JSONEncode(data))
            print("Saved settings:", options.Name, options.Value)
        end
    end
    
    toggleButton.MouseButton1Click:Connect(toggleCallback)
    
   
    if options.LoadFromFile then
        local file = options.LoadFromFile
        if isfile(file) then
            local data = {}
            pcall(function()
                data = game:GetService("HttpService"):JSONDecode(readfile(file))
            end)
            if data[options.Name] ~= nil then
                options.Value = data[options.Name]
                updateToggleState()
                if options.Callback then
                    options.Callback(options.Value)
                end
                print("Loaded settings:", options.Name, options.Value)
            end
        end
    end
end


local function CreateTabToggle()
    local isVisible = false
    
    local tabToggle = Instance.new("TextButton")
    tabToggle.Size = UDim2.new(0, 50, 0, 50)
    tabToggle.Position = UDim2.new(1, -60, 0.5, -25) 
    tabToggle.AnchorPoint = Vector2.new(1, 0.5) 
    tabToggle.Text = "RV"
    tabToggle.Font = Enum.Font.SourceSansBold
    tabToggle.FontSize = Enum.FontSize.Size14
    tabToggle.TextColor3 = Color3.new(1, 1, 1)
    tabToggle.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
    tabToggle.TextSize = 25
    tabToggle.BorderSizePixel = 0
    tabToggle.AutoButtonColor = false
    tabToggle.Active = true
    tabToggle.Draggable = true
    tabToggle.Parent = NovaWare
    
    local uiCorners = Instance.new("UICorner")
    uiCorners.CornerRadius = UDim.new(0.1, 0)
    uiCorners.Parent = tabToggle
    
    local function toggleTabs()
        isVisible = not isVisible
        for _, tab in ipairs(NovaWare:GetChildren()) do
            if tab:IsA("Frame") then
                tab.Visible = isVisible
            end
        end
    end
    tabToggle.MouseButton1Click:Connect(toggleTabs)
end

local function CreateButton(options)
    local column = options.Column or 1
    local yOffset = 0
    
    if options.Parent then
        yOffset = options.Parent.Size.Y.Offset 
        for _, child in ipairs(options.Parent:GetChildren()) do
            if child:IsA("TextButton") then
                yOffset = yOffset + child.Size.Y.Offset
            end
        end
    end
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 30)
    Button.Position = UDim2.new(0, 0, 1, yOffset) 
    Button.Text = ""
    Button.BackgroundColor3 = options.Color or defaultColor
    Button.BorderSizePixel = 0
    Button.AutoButtonColor = false
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 0
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.Parent = options.Parent or frame
    
    local ButtonText = Instance.new("TextLabel")
    ButtonText.Size = UDim2.new(1, 0, 1, 0)
    ButtonText.Position = UDim2.new(0, 5, 0, 0) 
    ButtonText.BackgroundTransparency = 1
    ButtonText.Text = options.Name or "Button"
    ButtonText.TextColor3 = Color3.new(1, 1, 1)
    ButtonText.Font = Enum.Font.SourceSansBold
    ButtonText.TextSize = 17
    ButtonText.TextXAlignment = Enum.TextXAlignment.Left
    ButtonText.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        if options.Callback then
            options.Callback()
        end
    end)
    
    return Button
end

local TabToggle = CreateTabToggle()

local WelcomeNotification = CreateNotification({
    Text = "Revolve Loaded!",
    TextPos = UDim2.new(0, 80, 0, 30),
    Time = 2.5,
    Mode = "Normal"
})


--\\Code Very Gud Organized ( prob ), You Can Use This Lib If U Want

local function GetInventory(Player)
	if not Player then 
		return {Items = {}, Armor = {}}
	end

	local Success, Return = pcall(function() 
		return require(game:GetService("ReplicatedStorage").TS.inventory["inventory-util"]).InventoryUtil.getInventory(Player)
	end)

	if not Success then 
		return {Items = {}, Armor = {}}
	end
	if Player.Character and Player.Character:FindFirstChild("InventoryFolder") then 
		local InvFolder = Player.Character:FindFirstChild("InventoryFolder").Value
		if not InvFolder then return Return end
		for i, v in next, Return do 
			for i2, v2 in next, v do 
				if typeof(v2) == 'table' and v2.itemType then
					v2.instance = InvFolder:FindFirstChild(v2.itemType)
				end
			end
			if typeof(v) == 'table' and v.itemType then
				v.instance = InvFolder:FindFirstChild(v.itemType)
			end
		end
	end
	return Return
end



local Remotes = {
  DeathRemote = game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.ResetCharacter
  
}




function FindBed()
    local nearestBed = nil
    local minDistance = math.huge

    for _, v in pairs(game.Workspace:GetDescendants()) do
        if v.Name:lower() == "bed" and v:FindFirstChild("Covers") and v:FindFirstChild("Covers").BrickColor ~= Lplr.Team.TeamColor then
            local distance = (v.Position - Lplr.Character.HumanoidRootPart.Position).magnitude
            if distance < minDistance then
                nearestBed = v
                minDistance = distance
            end
        end
    end
    return nearestBed
end

function TpToBed()
    local nearestBed = FindBed()
    if nearestBed and not hasTeleported then
        hasTeleported = true

        local humanoidRootPart = Lplr.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local targetCFrame = nearestBed.CFrame + Vector3.new(0, 6, 0)
            local tweenInfo = TweenInfo.new(0.8)
            local tween = TWS:Create(humanoidRootPart, tweenInfo, {CFrame = targetCFrame})
            tween:Play()
        end
    end
end




function HashFunc(Vec)
	return {value = Vec}
end

local function FindPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Lplr and player.TeamColor ~= LplrTeam.TeamColor then
            local distance = (player.Character.HumanoidRootPart.Position - Lplr.Character.HumanoidRootPart.Position).magnitude
            if distance < shortestDistance then
                closestPlayer = player
                shortestDistance = distance
            end
        end
    end

    return closestPlayer
end

local function KillPlayer()
if not IsPlayerAlive(Lplr) then
    CreateNotification({
    Text = "Use The Module When You're Alive!",
    TextPos = UDim2.new(0, 140, 0, 30),
    Time = 2.5,
    Mode = "Error"
})
else
Remotes.DeathRemote:FireServer()
end
end





function GetSword()
	local Highest, Returning = -9e9, nil
	for i, v in next, GetInventory(Lplr).items do 
		local Power = table.find(BedwarsSwords, v.itemType)
		if not Power then continue end
		if Power > Highest then 
			Returning = v
			Highest = Power
		end
	end
	return Returning
end

local function FindPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Lplr and player.TeamColor.Name ~= LplrTeam then
            local distance = (player.Character.HumanoidRootPart.Position - Lplr.Character.HumanoidRootPart.Position).magnitude
            if distance < shortestDistance then
                closestPlayer = player
                shortestDistance = distance
            end
        end
    end

    return closestPlayer
end

function TpToPlayer()
    local closestPlayer = FindPlayer()
    if closestPlayer then
        local humanoidRootPart = Lplr.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local targetCFrame = closestPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame
            local tweenInfo = TweenInfo.new(0.8)
            local tween = TWS:Create(humanoidRootPart, tweenInfo, {CFrame = targetCFrame})
            tween:Play()
        end
    end
end

function YuziTp()
    local closestPlayer = FindPlayer()
    if closestPlayer then
        local humanoidRootPart = Lplr.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local targetCFrame = closestPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame
            local tweenInfo = TweenInfo.new(1)
            local tween = TWS:Create(humanoidRootPart, tweenInfo, {CFrame = targetCFrame})
            tween:Play()
        end
    end
end


local function ExecuteRemote()
local Dao = GetSword()
local args = {
    [1] = "dash",
    [2] = {
        ["direction"] = LookVector,
        ["weapon"] = Dao.tool,
        ["origin"] = humanoidRootPart.Position
    }
}
game:GetService("ReplicatedStorage"):FindFirstChild("events-@easy-games/game-core:shared/game-core-networking@getEvents.Events").useAbility:FireServer(unpack(args))
end


function IsPlayerAlive(Plr)
Plr = Plr or Lplr
	if not Plr.Character then return false end
	if not Plr.Character:FindFirstChild("Head") then return false end
	if not Plr.Character:FindFirstChild("Humanoid") then return false end
	return true
end
local isLplrAlive = IsPlayerAlive(Lplr)

function GetMatchState()
	return ClientHandlerStore:getState().Game.matchState
end

local OrigC0 = game:GetService("ReplicatedStorage").Assets.Viewmodel.RightHand.RightWrist.C0
local Animations = {
	["Special"] = {
		{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(-90), math.rad(8), math.rad(5)), Time = 0.1},
		{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(90), math.rad(3), math.rad(13)), Time = 0.1},
		{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(-90), math.rad(-5), math.rad(8)), Time = 0.1},
		{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0)), Time = 0.1}
	}
}
local CurrentAnimation = {["Value"] = "Special"}






local CombatTab = CreateTab({
    Name = "Combat",
    Icon = "rbxassetid://13350770192",
    Position = UDim2.new(0, 100, 0, 30)
})

local UtlityTab = CreateTab({
    Name = "Utlity",
    Icon = "rbxassetid://10829245398",
    Position = UDim2.new(0, 300, 0, 30)
})

local VisualsTab = CreateTab({
    Name = "Visuals",
    Icon = "rbxassetid://10829245398",
    Position = UDim2.new(0, 500, 0, 30)
})

local WorldTab = CreateTab({
    Name = "World",
    Icon = "rbxassetid://10829245398",
    Position = UDim2.new(0, 700, 0, 30)
})


  

local AntivoidEnabled = false
local Antivoid = CreateToggle({
  Name = "AntiVoid",
  Column = 1,
  Parent = WorldTab,
  Callback = function(isToggled)
  
    if isToggled then
      local antiVoidPart = Instance.new("Part")
      antiVoidPart.Name = "AntiVoidPart"
      antiVoidPart.Size = Vector3.new(10000, 1, 1000)
      antiVoidPart.Color = Color3.fromRGB(138, 43, 226)
      antiVoidPart.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(0, 15, 0)
      antiVoidPart.Anchored = true
      antiVoidPart.Material = Enum.Material.SmoothPlastic
      antiVoidPart.Transparency = 0.5
      antiVoidPart.Parent = workspace
    else
      local FindAntivoid2 = workspace:FindFirstChild("AntiVoidPart")
      if FindAntivoid2 then 
        FindAntivoid2:Destroy()
      end
    end
    if VelocityMode == true then
    local FindAntivoid = workspace:FindFirstChild("AntiVoidPart")
    if FindAntivoid and VelocityMode then
    FindAntivoid.Velocity = Vector3.new(0, 100, 0)
    else
    FindAntivoid.Velocity = Vector3.new(0, 0, 0)
    end
    end
  end,
  SaveToFile = "Settings.json",
  LoadFromFile = "Settings.json"
})

local DeathDelay = 3.85--\\Magic number:)
local PlayerTp = CreateButton({
    Name = "PlayerTp",
    Column = 2,
    Parent = WorldTab,
    Callback = function()
    KillPlayer()
    CreateNotification({
    Text = "Killed Player, Teleporting...",
    TextPos = UDim2.new(0, 140, 0, 30),
    Time = 2.5,
    Mode = "Normal"
})
wait(DeathDelay)--\\Wait is a bit better here
TpToPlayer()
    end
})




local PlayerTp = CreateButton({
    Name = "BedTp",
    Column = 3,
    Parent = WorldTab,
    Callback = function()
    KillPlayer()
    CreateNotification({
    Text = "Killed Player, Teleporting...",
    TextPos = UDim2.new(0, 140, 0, 30),
    Time = 2.5,
    Mode = "Normal"
})
wait(DeathDelay)
TpToBed()

    end
})

local YuziTpEnabled = false
local YuziTp = CreateToggle({
    Name = "YuziTp",
    Column = 4,
    Parent = WorldTab,
    Callback = function(isToggled)
   YuziTpEnabled = isToggled
   if YuziTpEnabled then
local YuziTpButton = Instance.new("TextButton")
YuziTpButton.Size = UDim2.new(0, 50, 0, 50) 
YuziTpButton.Position = UDim2.new(1, -75, 0.5, -25)
YuziTpButton.AnchorPoint = Vector2.new(1, 0.5)
YuziTpButton.BackgroundColor3 = Color3.new(0, 0, 0)
YuziTpButton.BackgroundTransparency = 0.6 
YuziTpButton.BorderSizePixel = 0 
YuziTpButton.Text = "YuziTp" 
YuziTpButton.TextColor3 = Color3.new(1, 1, 1)
YuziTpButton.Parent = NovaWare2

local CircleMakerLol = Instance.new("UICorner")
CircleMakerLol.CornerRadius = UDim.new(1, 0) 
CircleMakerLol.Parent = YuziTpButton

YuziTpButton.MouseButton1Click:Connect(function()
wait(1)
ExecuteRemote()
YuziTp()
end)
end
    end,
    SaveToFile = "Settings.json",
  LoadFromFile = "Settings.json"
})



--\\Visuals Toggle (Kinda Low)
local EspEnabled = false
local Esp = CreateToggle({
  Name = "Esp",
  Column = 1,
  Parent = VisualsTab,
  Callback = function(isToggled)
    local EspEnabled = isToggled

    local function setPlayerColors(player, Frame, UIStroke)
        local teamColor = player.Team and player.Team.TeamColor.Color or Color3.new(1, 0, 0)
        Frame.BackgroundColor3 = teamColor
        UIStroke.Color = teamColor
    end

    local function updateEsp()
        if EspEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= Players.LocalPlayer then
                    local billboard = player.Character:FindFirstChild("PlayerBillboard")
                    if not billboard then
                        local BillboardGui = Instance.new("BillboardGui")
                        BillboardGui.Name = "PlayerBillboard"
                        BillboardGui.Enabled = true
                        BillboardGui.AlwaysOnTop = true
                        BillboardGui.Size = UDim2.new(4, 0, 6, 0)
                        BillboardGui.StudsOffset = Vector3.new(0, -1.3, 0)

                        local Frame = Instance.new("Frame", BillboardGui)
                        Frame.BackgroundTransparency = 0.5
                        Frame.Size = UDim2.new(1, 0, 1, 0)
                        Frame.BorderSizePixel = 2

                        local UIStroke = Instance.new("UIStroke", Frame)
                        UIStroke.Thickness = 4

                        BillboardGui.Parent = player.Character.Head

                        setPlayerColors(player, Frame, UIStroke)
                    end
                end
            end
        else
            for _, player in ipairs(Players:GetPlayers()) do
                local billboard = player.Character:FindFirstChild("PlayerBillboard")
                if billboard then
                    billboard:Destroy()
                end
            end
        end
    end

    updateEsp()

    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            if EspEnabled then
                updateEsp()
            end
        end)
    end)

    Players.PlayerRemoving:Connect(function(player)
        local billboard = player.Character:FindFirstChild("BillboardGui")
        if billboard then
            billboard:Destroy()
        end
    end)
  end,
  SaveToFile = "Settings.json",
  LoadFromFile = "Settings.json"
})


local NameTags = CreateToggle({
    Name = "NameTags",
    Column = 2,
    Parent = VisualsTab,
    Callback = function(isToggled)
        local function CreateNameTag(player)
            local Tag = Instance.new("BillboardGui")
            Tag.Adornee = player.Character:FindFirstChild("Head") or player.Character.PrimaryPart 
            Tag.Size = UDim2.new(0, 100, 0, 50)
            Tag.StudsOffset = Vector3.new(0, 3, 0)
            Tag.Name = player.Name .. "NameTag"
            local TextLabel = Instance.new("TextLabel")
            TextLabel.Parent = Tag
            TextLabel.Size = UDim2.new(1, 0, 1, 0)
            TextLabel.BackgroundTransparency = 1
            TextLabel.Text = player.Name
            TextLabel.Font = Enum.Font.SourceSansBold
            TextLabel.TextColor3 = Color3.new(1, 1, 1)
            TextLabel.TextStrokeTransparency = 0
            TextLabel.TextStrokeColor3 = Color3.new(0, 0, 0) 
            TextLabel.TextScaled = true
            
            Tag.Parent = game.Workspace 
        end
        
        local function DestroyNameTag(player)
            local Tag = game.Workspace:FindFirstChild(player.Name .. "NameTag")
            if Tag then
                Tag:Destroy()
            end
        end
        
        local function ToggleNameTags(isToggled)
            local Lplr = game.Players.LocalPlayer
            if isToggled then
                for _, player in ipairs(game.Players:GetPlayers()) do
                    if player ~= Lplr then
                        CreateNameTag(player)
                    end
                end
            else
                for _, player in ipairs(game.Players:GetPlayers()) do
                    DestroyNameTag(player)
                end
            end
        end
        
        ToggleNameTags(isToggled)
    end,
    SaveToFile = "Settings.json",
    LoadFromFile = "Settings.json"
})












--\\Utlity Toggles
local NoFallEnabled = false
local NoFall = CreateToggle({
Name = "NoFall",
    Column = 1,
    Parent = UtlityTab,
    Callback = function(isToggled)
  NoFallEnabled = isToggled
  
    
      if NoFallEnabled then
      while isLplrAlive do game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.GroundHit:FireServer()
      task.wait(2)
    end
end

 
    end,
    
    SaveToFile = "Settings.json",
    LoadFromFile = "Settings.json"
})


local HKB = 100
local VKB = 100
local AntiKnockBackEnabled = false
local AntiKn = CreateToggle({
Name = "AntiKn",--\\ Anti Knockback Looked bad
    Column = 2,
    Parent = UtlityTab,
    Callback = function(isToggled)
    AntiKnockBackEnabled = isToggled
 
local function GetKnTable()
    return debug.getupvalue(require(game:GetService("ReplicatedStorage").TS.damage["knockback-util"]).KnockbackUtil.calculateKnockbackVelocity, 1)
end

local function KnPower(direction, strength)
    local knockbackTable = GetKnTable()

    if knockbackTable then
        knockbackTable["kb" .. direction .. "Strength"] = strength
    end
end
    if AntiKnockBackEnabled then
        KnPower("Direction", HKB)
        KnPower("Upward", VKB)
    else
        KnPower("Direction", 100)
        KnPower("Upward", 100)
    end
    end,
    SaveToFile = "Settings.json",
    LoadFromFile = "Settings.json"
})

local InfJumpEnabled = false
local InfJump = CreateToggle({
Name = "InfJump",
    Column = 3,
    Parent = UtlityTab,
    Callback = function(isToggled)
   InfJumpEnabled = isToggled

game:GetService("UserInputService").JumpRequest:connect(function()
	if InfJumpEnabled then --\\Honestly, ik this is prob not "Original" but i dont think it counts as skidding (Idk)

	game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
	end
end)

    end,
    SaveToFile = "Settings.json",
    LoadFromFile = "Settings.json"
})



local velocity = CreateToggle({
  Name = "Velocity",
  Column = 4,
  Parent = UtlityTab,
  Callback = function(isToggled)
  VelocityMode = isToggled--\\This is a mode, its for antivoid and other modules, it just activates the velocity mode
  end,
  SaveToFile = "Settings.json",
  LoadFromFile = "Settings.json"
})

local SkyBox = CreateToggle({
  Name = "SkyBox",
  Column = 5,
  Parent = UtlityTab,
  Callback = function(isToggled)
  local Images = {--\\What 99% Of you like to see xd
    "rbxassetid://14993957229", 
    "rbxassetid://14993958854",
    "rbxassetid://14993961695"
} 

if isToggled then
    sky.SkyboxBk = Images[1]
    sky.SkyboxDn = Images[2]
    sky.SkyboxFt = Images[2]
    sky.SkyboxLf = Images[3]
    sky.SkyboxRt = Images[1]
    sky.SkyboxUp = Images[1]
    sky.Parent = game.Lighting
end



  end,
  SaveToFile = "Settings.json",
  LoadFromFile = "Settings.json"
})







--\\Combat Toggles
--\\Credits:GodClucther for killaura
local KillauraEnabled = false
local KillauraRange = 18
local Killaura = CreateToggle({
    Name = "Killaura",
    Column = 1,
    Parent = CombatTab,
    Callback = function(isToggled)
        KillauraEnabled = isToggled
        
spawn(function()
repeat
task.wait()
for _, enemyPlayer in pairs(game:GetService("Players"):GetPlayers()) do
 if enemyPlayer ~= Lplr and enemyPlayer.Team ~= Lplr.Team and IsPlayerAlive(enemyPlayer) and GetMatchState() ~= 0 and IsPlayerAlive() and not enemyPlayer.Character:FindFirstChildOfClass("ForceField") then
                
                local distance = (enemyPlayer.Character:FindFirstChild("HumanoidRootPart").Position - Lplr.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude

                if distance < 18 then
                    local Sword = GetSword()
                    CombatConstants.RAYCAST_SWORD_CHARACTER_DISTANCE = 22

                    if Sword then
                        spawn(function()
                            if KillauraEnabled then
                                KillauraEnabled = false
                                for _, animationStep in pairs(Animations[CurrentAnimation["Value"]]) do
                                    game:GetService("TweenService"):Create(Camera.Viewmodel.RightHand.RightWrist, TweenInfo.new(animationStep.Time), {C0 = OrigC0 * animationStep.CFrame}):Play()
                                    task.wait(animationStep.Time - 0.01)
                                end
                                KillauraEnabled = true
                            end
                        end)

                        SwordController.lastAttack = game:GetService("Workspace"):GetServerTimeNow()

                        local Args = {
                            [1] = {
                                ["chargedAttack"] = {["chargeRatio"] = 0},
                                ["entityInstance"] = enemyPlayer.Character,
                                ["validate"] = {
                                    ["targetPosition"] = HashFunc(enemyPlayer.Character:FindFirstChild("HumanoidRootPart").Position),
                                    ["selfPosition"] = HashFunc(Lplr.Character:FindFirstChild("HumanoidRootPart").Position + Vector3.new(0, -0.03, 0) + ((distance > 14) and (CFrame.lookAt(Lplr.Character:FindFirstChild("HumanoidRootPart").Position, enemyPlayer.Character:FindFirstChild("HumanoidRootPart").Position).LookVector * 4) or Vector3.new(0, 0, 0))),
                                },
                                ["weapon"] = Sword.tool,
                            }
                        }                       game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.SwordHit:FireServer(unpack(Args))
                    end
                end
            end
        end
    until not game
end)
   
    end,
    SaveToFile = "Settings.json", 
    LoadFromFile = "Settings.json"
})





local ReachEnabled = false
local ReachRange = 22
local NormalReach = 14
local Reach = CreateToggle({
  Name = "Reach",
  Column = 2,
  Parent = CombatTab,
  Callback = function(isToggled)
  
  if isToggled then
  while ReachEnabled do --\\Loop cuz uh yez
  CombatConstants.RAYCAST_SWORD_CHARACTER_DISTANCE = ReachRange
  task.wait(0.9)
  end
  else
  CombatConstants.RAYCAST_SWORD_CHARACTER_DISTANCE = NormalReach
  end
  end,
  SaveToFile = "Settings.json",
  LoadFromFile = "Settings.json"
})


local AutoSprintEnabled = false
local AutoSprintTime = 1
local AutoSprintRemote = KnitClient.Controllers.SprintController
local AutoSprint = CreateToggle({
Name = "AutoSprint",
    Column = 3,
    Parent = CombatTab,
    Callback = function(isToggled)
    AutoSprintEnabled = isToggled
    
RS.Heartbeat:Connect(function()
AutoSprintRemote:startSprinting()
end)
    end,
    SaveToFile = "Settings.json",
  LoadFromFile = "Settings.json"

})


--\\ This Goofy Toggle Saving As false for some reason, probably will just fix it with thr walkspeed also
local speedEnabled 
local speedRange = 23
local Speed = CreateToggle({
Name = "Speed",
    Column = 4,
    Parent = CombatTab,
    Callback = function(isToggled)
    
   if isToggled then
   while isToggled and isLplrAlive do
   Hum.WalkSpeed = speedRange --\\WalkSpeed, will probably change it to something later
   task.wait(0.6)
   end
   end
    end,
    
    SaveToFile = "Settings.json",
    LoadFromFile = "Settings.json"
})




--\\Yay Traget Stafe! i mean Tanget Stafe, i mean Target Strafe
local Range = 10
local Speed201 = 5 --\\ Just making sure the name isnt the same
local Speed202 = 5
local FollowRange = 2 --\\not a range
local stopDuration = 1
local LowHealth = 20
local TargetStrafeEnabled = false

local TargetStrafe = CreateToggle({
Name = "TargetStrafe",
    Column = 5,
    Parent = CombatTab,
    Callback = function(isToggled)
   
TargetStrafeEnabled = isToggled

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.E then
        TargetStrafeEnabled = not TargetStrafeEnabled
    end
end)--\\Pov: u realize 90% of the hackers are on mobile :/

game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
    if TargetStrafeEnabled then
        for _, targetPlayer in pairs(game.Players:GetPlayers()) do
            if targetPlayer ~= Lplr and Lplr.Team ~= targetPlayer.Team then
                local distance = (Lplr.Character and Lplr.Character:FindFirstChild("HumanoidRootPart") and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart"))
                if distance then
                    distance = (Lplr.Character.HumanoidRootPart.Position - targetPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if distance <= Range and targetPlayer.Character:FindFirstChild("Humanoid") then
                        local targetHumanoid = targetPlayer.Character:FindFirstChild("Humanoid")
                        if targetHumanoid.Health > LowHealth then
                            local angle = tick() * Speed201
                            local offsetX = math.sin(angle) * Speed202
                            local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
                            local newPosition = Vector3.new(targetPosition.X + offsetX, targetPosition.Y, targetPosition.Z)
                            Lplr.Character:SetPrimaryPartCFrame(CFrame.new(newPosition))
                        end
                    end
                end
            end
        end
    end
end)

local timer = 0
RS.Heartbeat:Connect(function()
    if TargetStrafeEnabled then
        timer = timer + 0.1
        if timer >= FollowRange then
            TargetStrafeEnabled = false
            task.wait(stopDuration)
            TargetStrafeEnabled = true
            timer = 0
        end
    end
end)

    end,
    SaveToFile = "Settings.json",
    LoadFromFile = "Settings.json"
})





 
