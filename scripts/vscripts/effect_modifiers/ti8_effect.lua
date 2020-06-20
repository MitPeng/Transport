ti8_effect = class({})

function ti8_effect:GetDuration()
    return -1
end

function ti8_effect:GetEffectName()
    return "particles/econ/events/ti8/ti8_hero_effect.vpcf"
end

function ti8_effect:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function ti8_effect:AllowIllusionDuplicate()
    return true
end

function ti8_effect:IsPassive()
    return 1
end

function ti8_effect:IsDebuff()
    return false
end

function ti8_effect:IsPurgable()
    return false
end

function ti8_effect:IsHidden()
    return true
end

function ti8_effect:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
