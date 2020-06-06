function blood_race_shawl(keys)
    local caster = keys.caster
    local ability = keys.ability
    local hp_percent = ability:GetSpecialValueFor("buff_hp_percent") / 100
    local damage = hp_percent * caster:GetHealth()
    local damage_table = {
        victim = caster,
        attacker = caster,
        damage = damage,
        damage_type = DAMAGE_TYPE_PURE
    }
    ApplyDamage(damage_table)
end
