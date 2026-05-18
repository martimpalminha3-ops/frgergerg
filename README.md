# 🏷️ Roblox Tag System

Sistema de tags overhead para Roblox com suporte para **Owner**, **Co-Owner**, **Staff**, **Dev** e **VIP**.

![Roblox](https://img.shields.io/badge/Roblox-Luau-blue)

---

## ✨ Funcionalidades

- **5 Tags pré-configuradas**: Owner, Co-Owner, Staff, Dev, VIP
- **Cores personalizáveis** para cada tag
- **Animações** de entrada e saída suaves
- **BillboardGui** visível acima do personagem
- **Suporte a GamePass** para atribuição automática de VIP
- **Suporte a Groups** para atribuição automática de Staff
- **Prioridade de tags** — se um jogador tiver múltiplas tags, aparece a de maior prioridade
- **Efeitos visuais**: gradiente, sombra de texto, contorno

---

## 📁 Estrutura do Projeto

```
src/
├── ReplicatedStorage/
│   └── TagConfig.lua            -- Configuração de tags (cores, IDs, prioridades)
├── ServerScriptService/
│   └── TagSystem/
│       └── init.server.lua      -- Script do servidor (atribui tags)
└── StarterPlayer/
    └── StarterPlayerScripts/
        └── TagClient.client.lua -- Script do cliente (renderiza tags)
```

---

## 🚀 Instalação no Roblox Studio

### Opção 1: Copiar manualmente

1. **Abre o Roblox Studio** e o teu jogo.

2. **TagConfig** (ModuleScript):
   - Vai a `ReplicatedStorage`
   - Cria um novo **ModuleScript** chamado `TagConfig`
   - Cola o conteúdo de `src/ReplicatedStorage/TagConfig.lua`

3. **TagSystem** (Server Script):
   - Vai a `ServerScriptService`
   - Cria uma nova **Folder** chamada `TagSystem`
   - Dentro da pasta, cria um **Script** (não LocalScript)
   - Cola o conteúdo de `src/ServerScriptService/TagSystem/init.server.lua`

4. **TagClient** (Local Script):
   - Vai a `StarterPlayer > StarterPlayerScripts`
   - Cria um novo **LocalScript** chamado `TagClient`
   - Cola o conteúdo de `src/StarterPlayer/StarterPlayerScripts/TagClient.client.lua`

### Opção 2: Usar Rojo

Se usas [Rojo](https://rojo.space), basta configurar o `default.project.json` (incluído) e sincronizar.

---

## ⚙️ Configuração

### Adicionar jogadores às tags

Edita o ficheiro `TagConfig.lua` e adiciona os **UserIds** dos jogadores:

```lua
TagConfig.Tags = {
    Owner = {
        DisplayName = "👑 Owner",
        Color       = Color3.fromRGB(255, 215, 0),
        TextColor   = Color3.fromRGB(0, 0, 0),
        Priority    = 1,
        UserIds     = {
            123456789,  -- Substitui pelo teu UserId
        },
    },
    -- ...
}
```

### Ativar GamePass VIP

Para que jogadores com um GamePass específico recebam automaticamente a tag VIP:

```lua
TagConfig.VipGamePassId = 12345678  -- Coloca o ID do teu GamePass
```

### Ativar Group Rank → Staff

Para que membros do teu grupo com rank suficiente recebam a tag Staff:

```lua
TagConfig.GroupId = 12345678           -- ID do teu grupo
TagConfig.GroupMinRankForStaff = 200   -- Rank mínimo para Staff
```

### Personalizar aparência

```lua
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
```

---

## 🎨 Tags Disponíveis

| Tag       | Cor                | Emoji | Prioridade |
|-----------|-------------------|-------|------------|
| Owner     | 🟡 Dourado        | 👑    | 1 (máxima) |
| Co-Owner  | ⚪ Prateado       | ⚜️    | 2          |
| Staff     | 🔵 Azul           | 🛡️    | 3          |
| Dev       | 🟢 Verde          | 💻    | 4          |
| VIP       | 🟣 Rosa/Roxo      | ⭐    | 5          |

---

## 📝 Como encontrar o UserId

1. Vai a https://www.roblox.com/users/profile
2. O número no URL é o teu UserId
3. Ou usa: `game.Players.LocalPlayer.UserId` no Studio

---

## 📄 Licença

Este projeto é livre para uso pessoal e comercial em jogos Roblox.
