ti9_radiance = class({})

function ti9_radiance:GetDuration()
    return -1
end

function ti9_radiance:GetEffectName()
    return "particles/econ/events/ti9/radiance_owner_ti9.vpcf"
end

function ti9_radiance:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function ti9_radiance:AllowIllusionDuplicate()
    return true
end

function ti9_radiance:IsPassive()
    return 1
end

function ti9_radiance:IsDebuff()
    return false
end

function ti9_radiance:IsPurgable()
    return false
end

function ti9_radiance:IsHidden()
    return true
end

function ti9_radiance:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
