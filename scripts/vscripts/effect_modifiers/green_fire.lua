green_fire = class({})

function green_fire:GetDuration()
    return -1
end

function green_fire:GetEffectName()
    return "particles/econ/courier/courier_hyeonmu_ambient/courier_hyeonmu_ambient_green.vpcf"
end

function green_fire:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function green_fire:AllowIllusionDuplicate()
    return true
end

function green_fire:IsPassive()
    return 1
end

function green_fire:IsDebuff()
    return false
end

function green_fire:IsPurgable()
    return false
end

function green_fire:IsHidden()
    return true
end

function green_fire:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
