ti9_effect = class({})

function ti9_effect:GetDuration()
    return -1
end

function ti9_effect:GetEffectName()
    return "particles/econ/events/ti9/ti9_emblem_effect.vpcf"
end

function ti9_effect:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function ti9_effect:AllowIllusionDuplicate()
    return true
end

function ti9_effect:IsPassive()
    return 1
end

function ti9_effect:IsDebuff()
    return false
end

function ti9_effect:IsPurgable()
    return false
end

function ti9_effect:IsHidden()
    return true
end

function ti9_effect:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
