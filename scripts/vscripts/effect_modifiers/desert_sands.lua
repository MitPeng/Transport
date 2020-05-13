desert_sands = class({})

function desert_sands:GetDuration()
    return -1
end

function desert_sands:GetEffectName()
    return "particles/desert_sands.vpcf"
end

function desert_sands:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function desert_sands:AllowIllusionDuplicate()
    return true
end

function desert_sands:IsPassive()
    return 1
end

function desert_sands:IsDebuff()
    return false
end

function desert_sands:IsPurgable()
    return false
end

function desert_sands:IsHidden()
    return true
end

function desert_sands:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
