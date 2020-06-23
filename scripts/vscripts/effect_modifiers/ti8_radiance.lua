ti8_radiance = class({})

function ti8_radiance:GetDuration()
    return -1
end

function ti8_radiance:GetEffectName()
    return "particles/econ/events/ti8/radiance_owner_ti8.vpcf"
end

function ti8_radiance:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function ti8_radiance:AllowIllusionDuplicate()
    return true
end

function ti8_radiance:IsPassive()
    return 1
end

function ti8_radiance:IsDebuff()
    return false
end

function ti8_radiance:IsPurgable()
    return false
end

function ti8_radiance:IsHidden()
    return true
end

function ti8_radiance:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
