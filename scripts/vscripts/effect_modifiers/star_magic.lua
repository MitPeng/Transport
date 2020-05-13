star_magic = class({})

function star_magic:GetDuration()
    return -1
end

function star_magic:GetEffectName()
    return "particles/econ/courier/courier_hwytty/courier_hwytty_ambient.vpcf"
end

function star_magic:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function star_magic:AllowIllusionDuplicate()
    return true
end

function star_magic:IsPassive()
    return 1
end

function star_magic:IsDebuff()
    return false
end

function star_magic:IsPurgable()
    return false
end

function star_magic:IsHidden()
    return true
end

function star_magic:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
