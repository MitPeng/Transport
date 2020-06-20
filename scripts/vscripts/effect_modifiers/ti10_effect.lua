ti10_effect = class({})

function ti10_effect:GetDuration()
    return -1
end

function ti10_effect:GetEffectName()
    return "particles/econ/events/ti10/emblem/ti10_emblem_effect.vpcf"
end

function ti10_effect:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function ti10_effect:AllowIllusionDuplicate()
    return true
end

function ti10_effect:IsPassive()
    return 1
end

function ti10_effect:IsDebuff()
    return false
end

function ti10_effect:IsPurgable()
    return false
end

function ti10_effect:IsHidden()
    return true
end

function ti10_effect:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
