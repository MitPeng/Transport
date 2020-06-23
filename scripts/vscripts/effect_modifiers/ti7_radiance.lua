ti7_radiance = class({})

function ti7_radiance:GetDuration()
    return -1
end

function ti7_radiance:GetEffectName()
    return "particles/econ/events/ti7/radiance_owner_ti7.vpcf"
end

function ti7_radiance:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function ti7_radiance:AllowIllusionDuplicate()
    return true
end

function ti7_radiance:IsPassive()
    return 1
end

function ti7_radiance:IsDebuff()
    return false
end

function ti7_radiance:IsPurgable()
    return false
end

function ti7_radiance:IsHidden()
    return true
end

function ti7_radiance:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
