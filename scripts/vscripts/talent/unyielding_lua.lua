unyielding_lua = class({})
LinkLuaModifier("modifier_unyielding", "talent/modifier_unyielding_lua.lua", LUA_MODIFIER_MOTION_NONE)

-- Passive Modifier
function unyielding_lua:GetIntrinsicModifierName()
    return "modifier_unyielding"
end
