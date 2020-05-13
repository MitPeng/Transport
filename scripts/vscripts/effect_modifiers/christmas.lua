christmas = class({})

function christmas:GetDuration()
    return -1
end

function christmas:GetEffectName()
    return "particles/christmas.vpcf"
end

function christmas:GetEffectAttachType()
    return PATTACH_CENTER_FOLLOW
end

function christmas:AllowIllusionDuplicate()
    return true
end

function christmas:IsPassive()
    return 1
end

function christmas:IsDebuff()
    return false
end

function christmas:IsPurgable()
    return false
end

function christmas:IsHidden()
    return true
end

function christmas:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
