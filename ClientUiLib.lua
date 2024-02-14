--[[
UiLibBy: Sentry, External
]]

local defaultColor = Color3.new(0.1, 0.1, 0.1)
local toggleColor = Color3.fromRGB(114, 137, 218) 

local NovaWare = Instance.new("ScreenGui")
NovaWare.Parent = game:GetService("CoreGui")


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
    icon.Size = UDim2.new(0, 27, 0, 27)
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
    local column = options.Column or 1--\\"Column", well column my ass external
    local yOffset = 0
    
    
    if options.Parent then
        yOffset = options.Parent.Size.Y.Offset 
        for _, child in ipairs(options.Parent:GetChildren()) do
            if child:IsA("TextButton") then
                yOffset = yOffset + child.Size.Y.Offset
            end
        end
    end
    
    
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(1, 0, 0, 30)
    Toggle.Position = UDim2.new(0, 0, 1, yOffset)
    Toggle.Text = ""
    Toggle.BackgroundColor3 = defaultColor
    Toggle.BorderSizePixel = 0
    Toggle.AutoButtonColor = false
    Toggle.Font = Enum.Font.SourceSansBold
    Toggle.TextSize = 0
    Toggle.TextColor3 = Color3.new(1, 1, 1)
    Toggle.TextXAlignment = Enum.TextXAlignment.Left 
    Toggle.Parent = options.Parent or frame
    
    
    local ToggleTittle = Instance.new("TextLabel")
    ToggleTittle.Size = UDim2.new(1, 0, 1, 0)
    ToggleTittle.Position = UDim2.new(0, 5, 0, 0) 
    ToggleTittle.BackgroundTransparency = 1
    ToggleTittle.Text = options.Name or "Toggle"
    ToggleTittle.TextColor3 = Color3.new(1, 1, 1)
    ToggleTittle.Font = Enum.Font.SourceSansBold
    ToggleTittle.TextSize = 17
    ToggleTittle.TextXAlignment = Enum.TextXAlignment.Left
    ToggleTittle.Parent = Toggle
    
    
    local function Update2()
        if options.Value then
            game:GetService("TweenService"):Create(Toggle, TweenInfo.new(0.3), {BackgroundColor3 = toggleColor}):Play()
        else
            game:GetService("TweenService"):Create(Toggle, TweenInfo.new(0.3), {BackgroundColor3 = defaultColor}):Play()
        end
    end 
    
    
    Toggle.MouseButton1Click:Connect(function()
        options.Value = not options.Value
        Update2()
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
        end
    end)
    
    
    if options.LoadFromFile then
        local file = options.LoadFromFile
        if isfile(file) then
            pcall(function()
                local data = game:GetService("HttpService"):JSONDecode(readfile(file))
                if data[options.Name] ~= nil then
                    options.Value = data[options.Name]
                    Update2()
                end
            end)
        end
    end
end

--\\Code Very Gud Organized ( prob ), You Can Use This Lib If U Want
