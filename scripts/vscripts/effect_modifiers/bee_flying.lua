bee_flying = class({})

function bee_flying:GetDuration()
    return -1
end

function bee_flying:GetEffectName()
    return "particles/bee_flying.vpcf"
end

function bee_flying:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function bee_flying:AllowIllusionDuplicate()
    return true
end

function bee_flying:IsPassive()
    return 1
end

function bee_flying:IsDebuff()
    return false
end

function bee_flying:IsPurgable()
    return false
end

function bee_flying:IsHidden()
    return true
end

function bee_flying:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
