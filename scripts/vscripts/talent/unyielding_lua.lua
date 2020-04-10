unyielding_lua = class({})
LinkLuaModifier("modifier_unyielding", "talent/unyielding_lua.lua", LUA_MODIFIER_MOTION_NONE)

-- Passive Modifier
function unyielding_lua:GetIntrinsicModifierName()
    return "modifier_unyielding"
end

modifier_unyielding = class({})

function modifier_unyielding:GetTexture()
    return "necronomicon_warrior_sight"
end

function modifier_unyielding:GetDuration()
    return -1
end

function modifier_unyielding:IsPassive()
    return 1
end

function modifier_unyielding:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATUS_RESISTANCE,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end

function modifier_unyielding:GetModifierStatusResistance()
    return self.buff_count
end

function modifier_unyielding:GetModifierIncomingDamage_Percentage()
    return -self.buff_count
end

function modifier_unyielding:IsDebuff()
    return false
end

function modifier_unyielding:IsPurgable()
    return false
end

function modifier_unyielding:IsHidden()
    return false
end

function modifier_unyielding:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_unyielding:OnCreated(keys)
    self:StartIntervalThink(0.1)
end

function modifier_unyielding:OnIntervalThink()
    local caster = self:GetCaster()
    local hp_percent = caster:GetHealthPercent()
    local max_count = self:GetAbility():GetSpecialValueFor("max_count")
    self.buff_count = math.ceil((100 - hp_percent) / (100 / max_count))
end
