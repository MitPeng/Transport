ti10_radiance = class({})

function ti10_radiance:GetDuration()
    return -1
end

function ti10_radiance:GetEffectName()
    return "particles/econ/events/ti10/radiance_owner_ti10.vpcf"
end

function ti10_radiance:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function ti10_radiance:AllowIllusionDuplicate()
    return true
end

function ti10_radiance:IsPassive()
    return 1
end

function ti10_radiance:IsDebuff()
    return false
end

function ti10_radiance:IsPurgable()
    return false
end

function ti10_radiance:IsHidden()
    return true
end

function ti10_radiance:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
