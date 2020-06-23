author_effect = class({})

function author_effect:GetDuration()
    return -1
end

function author_effect:GetEffectName()
    return "particles/heart.vpcf"
end

function author_effect:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function author_effect:AllowIllusionDuplicate()
    return true
end

function author_effect:IsPassive()
    return 1
end

function author_effect:IsDebuff()
    return false
end

function author_effect:IsPurgable()
    return false
end

function author_effect:IsHidden()
    return true
end

function author_effect:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
