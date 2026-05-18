--[[
    TagClient (Client Script)
    
    Responsável por:
    1. Receber eventos do servidor sobre tags
    2. Criar BillboardGui acima do personagem com a tag
    3. Animações e efeitos visuais
]]

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")

local TagConfig = require(ReplicatedStorage:WaitForChild("TagConfig"))
local tagEvent  = ReplicatedStorage:WaitForChild("TagSystemEvent")

local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local appearance  = TagConfig.Appearance

-- Armazenar conexões rainbow ativas para limpeza
local rainbowConnections = {}

-- ============================================================
-- RAINBOW (ARCO-ÍRIS) - Ciclo de cores suave
-- ============================================================

local function hsvToRgb(h: number, s: number, v: number): Color3
    return Color3.fromHSV(h % 1, s, v)
end

local function startRainbow(frame, stroke)
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not frame or not frame.Parent then
            connection:Disconnect()
            return
        end
        local hue = (tick() * 0.5) % 1
        frame.BackgroundColor3 = hsvToRgb(hue, 1, 1)
        if stroke then
            stroke.Color = hsvToRgb((hue + 0.5) % 1, 1, 0.8)
        end
    end)
    return connection
end

-- ============================================================
-- CRIAR BILLBOARD GUI
-- ============================================================

local function createTagBillboard(character, tagName: string, tagData)
    local head = character:WaitForChild("Head", 5)
    if not head then
        return
    end

    -- Remover tag existente (se houver)
    local existing = head:FindFirstChild("TagBillboard")
    if existing then
        existing:Destroy()
    end

    -- BillboardGui
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "TagBillboard"
    billboard.Adornee = head
    billboard.Size = appearance.TagSize
    billboard.StudsOffset = appearance.StudsOffset
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 100
    billboard.Parent = head

    -- Frame de fundo
    local frame = Instance.new("Frame")
    frame.Name = "TagFrame"
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.Position = UDim2.new(0, 0, 0, 0)
    frame.AnchorPoint = Vector2.new(0, 0)
    frame.BackgroundColor3 = tagData.Color
    frame.BackgroundTransparency = appearance.BackgroundTransparency
    frame.BorderSizePixel = 0
    frame.Parent = billboard

    -- Cantos arredondados
    local corner = Instance.new("UICorner")
    corner.CornerRadius = appearance.CornerRadius
    corner.Parent = frame

    -- Contorno
    local stroke = Instance.new("UIStroke")
    stroke.Color = appearance.StrokeColor
    stroke.Thickness = appearance.StrokeThickness
    stroke.Transparency = 0.5
    stroke.Parent = frame

    -- Gradiente (efeito visual extra)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(0.5, Color3.new(0.9, 0.9, 0.9)),
        ColorSequenceKeypoint.new(1, Color3.new(0.7, 0.7, 0.7)),
    })
    gradient.Rotation = 90
    gradient.Parent = frame

    -- Texto da tag
    local label = Instance.new("TextLabel")
    label.Name = "TagLabel"
    label.Size = UDim2.new(1, -10, 1, -6)
    label.Position = UDim2.new(0.5, 0, 0.5, 0)
    label.AnchorPoint = Vector2.new(0.5, 0.5)
    label.BackgroundTransparency = 1
    label.Text = tagData.DisplayName
    label.TextColor3 = tagData.TextColor
    label.Font = appearance.Font
    label.TextSize = appearance.TextSize
    label.TextScaled = false
    label.Parent = frame

    -- Sombra do texto
    local shadow = Instance.new("TextLabel")
    shadow.Name = "TagShadow"
    shadow.Size = UDim2.new(1, 0, 1, 0)
    shadow.Position = UDim2.new(0, 1, 0, 1)
    shadow.BackgroundTransparency = 1
    shadow.Text = tagData.DisplayName
    shadow.TextColor3 = Color3.new(0, 0, 0)
    shadow.TextTransparency = 0.6
    shadow.Font = appearance.Font
    shadow.TextSize = appearance.TextSize
    shadow.TextScaled = false
    shadow.ZIndex = label.ZIndex - 1
    shadow.Parent = frame

    -- Animação de entrada (fade in + scale)
    frame.Size = UDim2.new(0.5, 0, 0.5, 0)
    frame.Position = UDim2.new(0.25, 0, 0.25, 0)
    billboard.Size = UDim2.new(0, 100, 0, 25)

    local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    local frameTween = TweenService:Create(frame, tweenInfo, {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
    })

    local billboardTween = TweenService:Create(billboard, tweenInfo, {
        Size = appearance.TagSize,
    })

    frameTween:Play()
    billboardTween:Play()

    -- Ativar animação rainbow se a tag tiver Rainbow = true
    if tagData.Rainbow then
        local playerId = character.Parent and character.Parent:IsA("Player") and character.Parent.UserId
        if not playerId then
            local player = Players:GetPlayerFromCharacter(character)
            if player then
                playerId = player.UserId
            end
        end

        local conn = startRainbow(frame, stroke)
        if playerId then
            if rainbowConnections[playerId] then
                rainbowConnections[playerId]:Disconnect()
            end
            rainbowConnections[playerId] = conn
        end
    end

    return billboard
end

-- ============================================================
-- REMOVER TAG
-- ============================================================

local function removeTag(character)
    if not character then
        return
    end

    local head = character:FindFirstChild("Head")
    if not head then
        return
    end

    local billboard = head:FindFirstChild("TagBillboard")
    if billboard then
        -- Parar rainbow se existir
        local player = Players:GetPlayerFromCharacter(character)
        if player and rainbowConnections[player.UserId] then
            rainbowConnections[player.UserId]:Disconnect()
            rainbowConnections[player.UserId] = nil
        end

        -- Animação de saída
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        local tween = TweenService:Create(billboard, tweenInfo, {
            Size = UDim2.new(0, 0, 0, 0),
        })
        tween:Play()
        tween.Completed:Connect(function()
            billboard:Destroy()
        end)
    end
end

-- ============================================================
-- PROCESSAR EVENTOS DO SERVIDOR
-- ============================================================

tagEvent.OnClientEvent:Connect(function(action: string, player: Player, tagName: string?, tagData)
    if action == "AddTag" then
        if player and player.Character then
            createTagBillboard(player.Character, tagName, tagData)
        end

    elseif action == "RemoveTag" then
        if player and player.Character then
            removeTag(player.Character)
        end
    end
end)

print("[TagSystem] Cliente de tags carregado com sucesso!")
