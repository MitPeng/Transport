arcane_comprehension_lua = class({})
LinkLuaModifier("modifier_arcane_comprehension_lua", "talent/arcane_comprehension_lua.lua", LUA_MODIFIER_MOTION_NONE)

-- Passive Modifier
function arcane_comprehension_lua:GetIntrinsicModifierName()
    return "modifier_arcane_comprehension_lua"
end

modifier_arcane_comprehension_lua = class({})

function modifier_arcane_comprehension_lua:GetTexture()
    return "spawnlord_aura"
end

function modifier_arcane_comprehension_lua:GetDuration()
    return -1
end

function modifier_arcane_comprehension_lua:IsPassive()
    return 1
end

function modifier_arcane_comprehension_lua:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_CAST_RANGE_BONUS,
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
    }
end

function modifier_arcane_comprehension_lua:GetModifierCastRangeBonus()
    return self.cast_range_count
end

function modifier_arcane_comprehension_lua:GetModifierPercentageCooldown()
    return self.cd_count
end

function modifier_arcane_comprehension_lua:IsDebuff()
    return false
end

function modifier_arcane_comprehension_lua:IsPurgable()
    return false
end

function modifier_arcane_comprehension_lua:IsHidden()
    return true
end

function modifier_arcane_comprehension_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_arcane_comprehension_lua:OnCreated(keys)
    self:StartIntervalThink(0.1)
end

function modifier_arcane_comprehension_lua:OnIntervalThink()
    local caster = self:GetCaster()
    local level = caster:GetLevel()
    local ability = self:GetAbility()
    self.cast_range_count = level * ability:GetSpecialValueFor("lvl_cast_range")
    self.cd_count = level * ability:GetSpecialValueFor("lvl_cd")
end
