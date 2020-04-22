function apply_count(keys)
    local caster = keys.caster
    local ability = keys.ability
    local event_ability = keys.event_ability
    if ability:GetCooldownTimeRemaining() == 0 then
        if not event_ability:IsItem() and not event_ability:IsToggle() then
            --处理冷却减少
            local cd_reduction = caster:GetCooldownReduction()
            local ability_level = ability:GetLevel() - 1
            local ability_cooldown = ability:GetCooldown(ability_level) * cd_reduction
            local duration = ability:GetSpecialValueFor("duration")
            local spend_mana = caster:GetMaxMana() - caster:GetMana()
            local mana_regen_per_sec = ability:GetSpecialValueFor("mana_regen_percent") / duration / 100
            local count = math.ceil(spend_mana * mana_regen_per_sec)
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_mana_surging_count", {duration = duration})
            caster:SetModifierStackCount("modifier_mana_surging_count", caster, count)
            ability:StartCooldown(ability_cooldown)
            local particle_name = "particles/items_fx/arcane_boots_recipient.vpcf"
            ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, caster)
        end
    end
end
