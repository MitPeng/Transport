function source_of_life(keys)
    local caster = keys.caster
    local target = keys.target
    if Utils:is_real_hero(target) or target:IsClone() then
        local ability = keys.ability
        local damage = caster:GetLevel() * ability:GetSpecialValueFor("lvl_damage")
        local damage_table = {
            victim = target,
            attacker = caster,
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = ability
        }
        ApplyDamage(damage_table)
        local healing_percent = ability:GetSpecialValueFor("healing_percent") / 100
        caster:Heal(math.ceil(damage * healing_percent), caster)
        PopupHealing(caster, math.ceil(damage * healing_percent))
    end
end
