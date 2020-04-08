function source_of_life(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local damage = caster:GetLevel() * ability:GetSpecialValueFor("lvl_damage")
    local damage_table = {
        victim = target,
        attacker = caster,
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL
    }
    ApplyDamage(damage_table)
    caster:Heal(math.ceil(damage), caster)
    PopupHealing(caster, math.ceil(damage))
end
