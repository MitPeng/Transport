golden_fire = class({})

function golden_fire:GetDuration()
    return -1
end

function golden_fire:GetEffectName()
    return "particles/econ/courier/courier_hyeonmu_ambient/courier_hyeonmu_ambient_gold.vpcf"
end

function golden_fire:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function golden_fire:AllowIllusionDuplicate()
    return true
end

function golden_fire:IsPassive()
    return 1
end

function golden_fire:IsDebuff()
    return false
end

function golden_fire:IsPurgable()
    return false
end

function golden_fire:IsHidden()
    return true
end

function golden_fire:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
