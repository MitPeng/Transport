function apply_count(keys)
    local caster = keys.caster
    local ability = keys.ability
    local event_ability = keys.event_ability
    if not event_ability:IsItem() and not event_ability:IsToggle() then
        if not caster:HasModifier("modifier_mana_surging_cd") then
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_mana_surging_cd", {})
            ability:StartCooldown(ability:GetSpecialValueFor("cd"))
            local count = caster:GetModifierStackCount("modifier_mana_surging_count", caster)
            if not count then
                count = 0
            else
                count = count + 1
            end
            caster:SetModifierStackCount("modifier_mana_surging_count", caster, count)
        end
    end
end
