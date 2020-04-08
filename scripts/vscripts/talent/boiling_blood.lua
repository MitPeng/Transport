function boiling_blood(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local damage_caster = caster:GetHealth() * ability:GetSpecialValueFor("hp_percent_caster") / 100
    local damage_target = caster:GetHealth() * ability:GetSpecialValueFor("hp_percent_target") / 100
    local damage_table_1 = {
        victim = caster,
        attacker = caster,
        damage = damage_caster,
        damage_type = DAMAGE_TYPE_MAGICAL
    }
    ApplyDamage(damage_table_1)
    PopupDamageOverTime(caster, math.ceil(damage_caster))
    local damage_table_2 = {
        victim = target,
        attacker = caster,
        damage = damage_target,
        damage_type = DAMAGE_TYPE_MAGICAL
    }
    ApplyDamage(damage_table_2)
    PopupDamageOverTime(target, math.ceil(damage_target))
end
