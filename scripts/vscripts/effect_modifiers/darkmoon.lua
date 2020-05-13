darkmoon = class({})

function darkmoon:GetDuration()
    return -1
end

function darkmoon:GetEffectName()
    return "particles/darkmoon.vpcf"
end

function darkmoon:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function darkmoon:AllowIllusionDuplicate()
    return true
end

function darkmoon:IsPassive()
    return 1
end

function darkmoon:IsDebuff()
    return false
end

function darkmoon:IsPurgable()
    return false
end

function darkmoon:IsHidden()
    return true
end

function darkmoon:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
