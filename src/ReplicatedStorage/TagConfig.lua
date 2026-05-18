--[[
    TagConfig.lua
    Módulo de configuração do sistema de tags.
    
    Coloca os UserIds dos jogadores em cada categoria.
    Personaliza cores, ícones e ordem de prioridade.
]]

local TagConfig = {}

-- ============================================================
-- TAGS DISPONÍVEIS
-- Prioridade: quanto menor o número, maior a prioridade.
-- Se um jogador tiver várias tags, aparece a de maior prioridade.
-- ============================================================

TagConfig.Tags = {
    Owner = {
        DisplayName = "👑 Owner",
        Color       = Color3.fromRGB(220, 20, 20),    -- Vermelho
        TextColor   = Color3.fromRGB(255, 255, 255),   -- Branco
        Priority    = 1,
        UserIds     = {
            -- Coloca aqui os UserIds dos Owners
            -- Ex: 123456789,
        },
    },

    CoOwner = {
        DisplayName = "⚜️ Co-Owner",
        Color       = Color3.fromRGB(192, 192, 192),  -- Prateado
        TextColor   = Color3.fromRGB(0, 0, 0),
        Priority    = 2,
        UserIds     = {},
    },

    Staff = {
        DisplayName = "🛡️ Staff",
        Color       = Color3.fromRGB(0, 170, 255),    -- Azul
        TextColor   = Color3.fromRGB(255, 255, 255),
        Priority    = 3,
        UserIds     = {},
    },

    Dev = {
        DisplayName = "💻 Dev",
        Color       = Color3.fromRGB(0, 255, 127),    -- Verde
        TextColor   = Color3.fromRGB(0, 0, 0),
        Priority    = 4,
        UserIds     = {},
    },

    VIP = {
        DisplayName = "⭐ VIP",
        Color       = Color3.fromRGB(255, 0, 0),      -- Base (animado rainbow)
        TextColor   = Color3.fromRGB(255, 255, 255),
        Priority    = 5,
        Rainbow     = true,
        UserIds     = {},
    },
}

-- ============================================================
-- GAMEPASS VIP (opcional)
-- Se definires um GamePassId, qualquer jogador que tenha
-- comprado esse gamepass recebe automaticamente a tag VIP.
-- Coloca 0 para desativar.
-- ============================================================
TagConfig.VipGamePassId = 0

-- ============================================================
-- GROUP TAG (opcional)
-- Se definires um GroupId, jogadores com rank >= MinRank
-- recebem automaticamente a tag Staff.
-- Coloca 0 para desativar.
-- ============================================================
TagConfig.GroupId  = 0
TagConfig.GroupMinRankForStaff = 200

-- ============================================================
-- APARÊNCIA DA TAG
-- ============================================================
TagConfig.Appearance = {
    TagSize          = UDim2.new(0, 200, 0, 50),
    StudsOffset      = Vector3.new(0, 3, 0),
    Font             = Enum.Font.GothamBold,
    TextSize         = 18,
    BackgroundTransparency = 0.3,
    CornerRadius     = UDim.new(0, 8),
    StrokeThickness  = 2,
    StrokeColor      = Color3.fromRGB(0, 0, 0),
}

return TagConfig
