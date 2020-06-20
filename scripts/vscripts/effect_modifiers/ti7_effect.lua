ti7_effect = class({})

function ti7_effect:GetDuration()
    return -1
end

function ti7_effect:GetEffectName()
    return "particles/econ/events/ti7/ti7_hero_effect.vpcf"
end

function ti7_effect:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function ti7_effect:AllowIllusionDuplicate()
    return true
end

function ti7_effect:IsPassive()
    return 1
end

function ti7_effect:IsDebuff()
    return false
end

function ti7_effect:IsPurgable()
    return false
end

function ti7_effect:IsHidden()
    return true
end

function ti7_effect:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
