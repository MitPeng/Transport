pink_memories = class({})

function pink_memories:GetDuration()
    return -1
end

function pink_memories:GetEffectName()
    return "particles/econ/courier/courier_baekho/courier_baekho_ambient.vpcf"
end

function pink_memories:GetEffectAttachType()
    return PATTACH_CENTER_FOLLOW
end

function pink_memories:AllowIllusionDuplicate()
    return true
end

function pink_memories:IsPassive()
    return 1
end

function pink_memories:IsDebuff()
    return false
end

function pink_memories:IsPurgable()
    return false
end

function pink_memories:IsHidden()
    return true
end

function pink_memories:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
