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

function modifier_unyielding:OnCreated()
    self.ability = self:GetAbility()
    self.caster = self:GetCaster()
    self.parent = self:GetParent()

    -- AbilitySpecials
    self.hp_threshold_max = 1

    self.range = 100 - self.hp_threshold_max

    -- Max size in pct that Huskar increases to
    self.max_size = 35

    if not IsServer() then
        return
    end

    -- Create the Berserker's Blood particle (glow + heal)
    self.particle = ParticleManager:CreateParticle("particles/unyielding.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)

    self:StartIntervalThink(0.1)
end

function modifier_unyielding:OnDestroy()
    if not IsServer() then
        return
    end
    ParticleManager:DestroyParticle(self.particle, false)
    ParticleManager:ReleaseParticleIndex(self.particle)
end

function modifier_unyielding:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATUS_RESISTANCE,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_MODEL_SCALE
    }
end

function modifier_unyielding:GetModifierStatusResistance()
    return self.buff_count
end

function modifier_unyielding:GetModifierIncomingDamage_Percentage()
    return -self.buff_count
end

function modifier_unyielding:GetModifierModelScale()
    if not IsServer() then
        return
    end
    local pct = math.max((self.parent:GetHealthPercent() - self.hp_threshold_max) / self.range, 0)
    ParticleManager:SetParticleControl(self.particle, 1, Vector((1 - pct) * 100, 0, 0))
    return (1 - pct) * 60
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

function modifier_unyielding:OnIntervalThink()
    if not IsServer() then
        return
    end
    local caster = self:GetCaster()
    local hp_percent = caster:GetHealthPercent()
    local max_count = self:GetAbility():GetSpecialValueFor("max_count")
    self.buff_count = math.ceil((100 - hp_percent) / (100 / max_count))
end
