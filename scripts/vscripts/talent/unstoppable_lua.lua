unstoppable_lua = class({})
LinkLuaModifier("modifier_unstoppable_lua", "talent/unstoppable_lua.lua", LUA_MODIFIER_MOTION_NONE)

-- Passive Modifier
function unstoppable_lua:GetIntrinsicModifierName()
    return "modifier_unstoppable_lua"
end

modifier_unstoppable_lua = class({})

function modifier_unstoppable_lua:GetTexture()
    return "blue_dragonspawn_sorcerer_evasion"
end

function modifier_unstoppable_lua:GetDuration()
    return -1
end

function modifier_unstoppable_lua:IsPassive()
    return 1
end

function modifier_unstoppable_lua:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATUS_RESISTANCE,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end

function modifier_unstoppable_lua:GetModifierStatusResistance()
    return self.status_count
end

function modifier_unstoppable_lua:GetModifierMagicalResistanceBonus()
    return self.magic_count
end

function modifier_unstoppable_lua:GetModifierPhysicalArmorBonus()
    return self.armor_count
end

function modifier_unstoppable_lua:IsDebuff()
    return false
end

function modifier_unstoppable_lua:IsPurgable()
    return false
end

function modifier_unstoppable_lua:IsHidden()
    return false
end

function modifier_unstoppable_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_unstoppable_lua:OnCreated(keys)
    self:StartIntervalThink(0.1)
end

function modifier_unstoppable_lua:OnIntervalThink()
    local caster = self:GetCaster()
    local level = caster:GetLevel()
    local ability = self:GetAbility()
    self.status_count = level * ability:GetSpecialValueFor("lvl_status")
    self.magic_count = level * ability:GetSpecialValueFor("lvl_magic")
    self.armor_count = level * ability:GetSpecialValueFor("lvl_armor")
end
