function apply_count(keys)
    local caster = keys.caster
    local ability = keys.ability
    local event_ability = keys.event_ability
    if ability:GetCooldownTimeRemaining() == 0 then
        --处理冷却减少
        local cd_reduction = caster:GetCooldownReduction()
        local ability_level = ability:GetLevel() - 1
        local ability_cooldown = ability:GetCooldown(ability_level) * cd_reduction
        if not event_ability:IsItem() and not event_ability:IsToggle() then
            if not caster:HasModifier("modifier_mana_surging_cd") then
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
        ability:StartCooldown(ability_cooldown)
    end
end
