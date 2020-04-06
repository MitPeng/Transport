function apply_count(keys)
    local target = keys.target
    local caster = keys.caster
    local ability = keys.ability
    local max_count = ability:GetSpecialValueFor("max_count")
    --如果有计数buff
    if target:HasModifier("modifier_dark_breaking_target_count") then
        --计数buff层数
        local count = target:GetModifierStackCount("modifier_dark_breaking_target_count", caster)
        --计数buff小于max_count则加1
        if count < max_count then
            count = count + 1
        end
        target:RemoveModifierByName("modifier_dark_breaking_target_count")
        ability:ApplyDataDrivenModifier(caster, target, "modifier_dark_breaking_target_count", {})
        target:SetModifierStackCount("modifier_dark_breaking_target_count", caster, count)
    else --如果没有计数buff则加上并设置层数为1
        ability:ApplyDataDrivenModifier(caster, target, "modifier_dark_breaking_target_count", {})
        target:SetModifierStackCount("modifier_dark_breaking_target_count", caster, 1)
    end

    --如果有buff则刷新持续时间
    if target:HasModifier("modifier_dark_breaking_target_apply") then
        target:RemoveModifierByName("modifier_dark_breaking_target_apply")
        ability:ApplyDataDrivenModifier(caster, target, "modifier_dark_breaking_target_apply", {})
    else
        ability:ApplyDataDrivenModifier(caster, target, "modifier_dark_breaking_target_apply", {})
    end
end

function breaking(keys)
    local target = keys.target
    local ability = keys.ability
    local caster = keys.caster
    local target_armor = target:GetPhysicalArmorValue(false)
    local target_magic_resistance = target:GetMagicalArmorValue()
    local max_count = ability:GetSpecialValueFor("max_count")
    local break_percent = ability:GetSpecialValueFor("break_percent") / 100
    local count = target:GetModifierStackCount("modifier_dark_breaking_target_count", caster)
    --总削减百分比
    local total_break_percent = 0
    if count < max_count then
        total_break_percent = 1 - (1 - break_percent) ^ count
    elseif count == max_count then
        total_break_percent = 1
    end
    local total_break_armor_count = math.ceil(total_break_percent * target_armor * 10)
    local total_break_magic_resistance_count = math.ceil(total_break_percent * target_magic_resistance * 100)
    if target:HasModifier("modifier_dark_breaking_armor") then
        target:SetModifierStackCount("modifier_dark_breaking_armor", caster, total_break_armor_count)
    else
        ability:ApplyDataDrivenModifier(caster, target, "modifier_dark_breaking_armor", {duration = -1})
        target:SetModifierStackCount("modifier_dark_breaking_armor", caster, total_break_armor_count)
    end
    if target:HasModifier("modifier_dark_breaking_magic_resist") then
        target:SetModifierStackCount("modifier_dark_breaking_magic_resist", caster, total_break_magic_resistance_count)
    else
        ability:ApplyDataDrivenModifier(caster, target, "modifier_dark_breaking_magic_resist", {duration = -1})
        target:SetModifierStackCount("modifier_dark_breaking_magic_resist", caster, total_break_magic_resistance_count)
    end
end
