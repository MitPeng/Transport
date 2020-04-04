function damage(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1
    --处理冷却减少
    local cd_reduction = caster:GetCooldownReduction()
    local ability_cooldown = ability:GetCooldown(ability_level) * cd_reduction
    local damage = caster:GetLevel() * ability:GetSpecialValueFor("lvl_damage")
    local damage_table = {
        victim = target,
        attacker = caster,
        damage = damage,
        damage_type = DAMAGE_TYPE_PURE
    }
    ApplyDamage(damage_table)
    --处理技能增强
    local amp = caster:GetSpellAmplification(false)
    PopupDamage(target, math.floor((1 + amp) * damage))
    ability:ApplyDataDrivenModifier(caster, target, "modifier_suddenly_strike_slow", {})
    caster:RemoveModifierByName("modifier_suddenly_strike_apply")
    --开始冷却（如果使用刷新球等刷新技能或物品，虽然技能冷却好了，但是Timers还是在继续读冷却，实际为无法被刷新）
    ability:StartCooldown(ability_cooldown)
    Timers:CreateTimer(
        ability_cooldown,
        function()
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_suddenly_strike_apply", {})
        end
    )
end
