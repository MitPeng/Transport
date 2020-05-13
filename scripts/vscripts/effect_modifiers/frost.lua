frost = class({})

function frost:GetDuration()
    return -1
end

function frost:GetEffectName()
    return "particles/frost.vpcf"
end

function frost:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function frost:AllowIllusionDuplicate()
    return true
end

function frost:IsPassive()
    return 1
end

function frost:IsDebuff()
    return false
end

function frost:IsPurgable()
    return false
end

function frost:IsHidden()
    return true
end

function frost:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
