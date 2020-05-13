red_fire = class({})

function red_fire:GetDuration()
    return -1
end

function red_fire:GetEffectName()
    return "particles/econ/courier/courier_hyeonmu_ambient/courier_hyeonmu_ambient_red_plus.vpcf"
end

function red_fire:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function red_fire:AllowIllusionDuplicate()
    return true
end

function red_fire:IsPassive()
    return 1
end

function red_fire:IsDebuff()
    return false
end

function red_fire:IsPurgable()
    return false
end

function red_fire:IsHidden()
    return true
end

function red_fire:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
