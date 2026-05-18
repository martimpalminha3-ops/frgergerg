--[[
    TagSystem (Server Script)
    
    Responsável por:
    1. Determinar que tag cada jogador deve ter
    2. Comunicar ao cliente via RemoteEvent para criar o BillboardGui
    3. Suportar atribuição por UserId, GamePass e Group Rank
]]

local Players            = game:GetService("Players")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local GroupService       = game:GetService("GroupService")

local TagConfig = require(ReplicatedStorage:WaitForChild("TagConfig"))

-- Criar RemoteEvent para comunicar com o cliente
local tagEvent = Instance.new("RemoteEvent")
tagEvent.Name = "TagSystemEvent"
tagEvent.Parent = ReplicatedStorage

-- ============================================================
-- FUNÇÕES AUXILIARES
-- ============================================================

local function getTagByUserId(userId: number): string?
    for tagName, tagData in pairs(TagConfig.Tags) do
        for _, id in ipairs(tagData.UserIds) do
            if id == userId then
                return tagName
            end
        end
    end
    return nil
end

local function hasVipGamePass(player: Player): boolean
    if TagConfig.VipGamePassId == 0 then
        return false
    end

    local success, ownsPass = pcall(function()
        return MarketplaceService:UserOwnsGamePassAsync(player.UserId, TagConfig.VipGamePassId)
    end)

    return success and ownsPass
end

local function hasGroupRank(player: Player): boolean
    if TagConfig.GroupId == 0 then
        return false
    end

    local success, rank = pcall(function()
        return player:GetRankInGroup(TagConfig.GroupId)
    end)

    return success and rank >= TagConfig.GroupMinRankForStaff
end

local function resolveTag(player: Player): string?
    -- 1. Verificar tags por UserId (maior prioridade)
    local directTag = getTagByUserId(player.UserId)
    if directTag then
        return directTag
    end

    -- 2. Verificar Group Rank -> Staff
    if hasGroupRank(player) then
        return "Staff"
    end

    -- 3. Verificar GamePass -> VIP
    if hasVipGamePass(player) then
        return "VIP"
    end

    return nil
end

-- ============================================================
-- ATRIBUIR TAGS AOS JOGADORES
-- ============================================================

local function onPlayerAdded(player: Player)
    local tagName = resolveTag(player)

    if not tagName then
        return
    end

    local tagData = TagConfig.Tags[tagName]
    if not tagData then
        return
    end

    -- Esperar pelo personagem
    player.CharacterAdded:Connect(function(character)
        -- Pequeno delay para garantir que o personagem está carregado
        task.wait(1)

        -- Enviar a todos os clientes para renderizar a tag
        tagEvent:FireAllClients("AddTag", player, tagName, tagData)
    end)

    -- Se o personagem já existe (reconexão rápida)
    if player.Character then
        task.wait(1)
        tagEvent:FireAllClients("AddTag", player, tagName, tagData)
    end
end

local function onPlayerRemoving(player: Player)
    tagEvent:FireAllClients("RemoveTag", player)
end

-- ============================================================
-- CONECTAR EVENTOS
-- ============================================================

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Processar jogadores que já estão no servidor (Studio)
for _, player in ipairs(Players:GetPlayers()) do
    task.spawn(onPlayerAdded, player)
end

print("[TagSystem] Sistema de tags carregado com sucesso!")
