function apply_debuff(keys)
    local caster = keys.caster
    local ability = keys.ability
    if caster:HasModifier("modifier_item_extreme_sword_debuff") then
        local count = caster:GetModifierStackCount("modifier_item_extreme_sword_debuff", caster)
        caster:SetModifierStackCount("modifier_item_extreme_sword_debuff", caster, count + 1)
    else
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_extreme_sword_debuff", {duration = -1})
        caster:SetModifierStackCount("modifier_item_extreme_sword_debuff", caster, 1)
    end
end
