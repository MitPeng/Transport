ti6_radiance = class({})

function ti6_radiance:GetDuration()
    return -1
end

function ti6_radiance:GetEffectName()
    return "particles/econ/events/ti6/radiance_owner_ti6.vpcf"
end

function ti6_radiance:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function ti6_radiance:AllowIllusionDuplicate()
    return true
end

function ti6_radiance:IsPassive()
    return 1
end

function ti6_radiance:IsDebuff()
    return false
end

function ti6_radiance:IsPurgable()
    return false
end

function ti6_radiance:IsHidden()
    return true
end

function ti6_radiance:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
