blue_fire = class({})

function blue_fire:GetDuration()
    return -1
end

function blue_fire:GetEffectName()
    return "particles/econ/courier/courier_hyeonmu_ambient/courier_hyeonmu_ambient_blue_plus.vpcf"
end

function blue_fire:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function blue_fire:AllowIllusionDuplicate()
    return true
end

function blue_fire:IsPassive()
    return 1
end

function blue_fire:IsDebuff()
    return false
end

function blue_fire:IsPurgable()
    return false
end

function blue_fire:IsHidden()
    return true
end

function blue_fire:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
