function nether_sword(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    if caster:IsRealHero() then
        local damage = ability:GetSpecialValueFor("max_hp_percent") / 100 * target:GetMaxHealth()
        local damage_table = {
            victim = target,
            attacker = caster,
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = ability
        }
        ApplyDamage(damage_table)
        PopupDamageOverTime(target, math.floor(damage))
    end
end
