void_mist = class({})

function void_mist:GetDuration()
    return -1
end

function void_mist:GetEffectName()
    return "particles/econ/courier/courier_oculopus/courier_oculopus_ambient.vpcf"
end

function void_mist:GetEffectAttachType()
    return PATTACH_CENTER_FOLLOW
end

function void_mist:AllowIllusionDuplicate()
    return true
end

function void_mist:IsPassive()
    return 1
end

function void_mist:IsDebuff()
    return false
end

function void_mist:IsPurgable()
    return false
end

function void_mist:IsHidden()
    return true
end

function void_mist:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
