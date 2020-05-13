cave_crystal = class({})

function cave_crystal:GetDuration()
    return -1
end

function cave_crystal:GetEffectName()
    return "particles/cave_crystal.vpcf"
end

function cave_crystal:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function cave_crystal:AllowIllusionDuplicate()
    return true
end

function cave_crystal:IsPassive()
    return 1
end

function cave_crystal:IsDebuff()
    return false
end

function cave_crystal:IsPurgable()
    return false
end

function cave_crystal:IsHidden()
    return true
end

function cave_crystal:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
