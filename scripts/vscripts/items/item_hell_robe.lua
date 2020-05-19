function hell_robe(keys)
    local caster = keys.caster
    local target_entities = keys.target_entities
    local ability = keys.ability
    for _, target in ipairs(target_entities) do
        local damage
        if caster:IsRealHero() then
            damage =
                ability:GetSpecialValueFor("max_hp_percent") / 100 * target:GetMaxHealth() +
                ability:GetSpecialValueFor("base_damage")
        else
            damage =
                (ability:GetSpecialValueFor("max_hp_percent") / 100 * target:GetMaxHealth() +
                ability:GetSpecialValueFor("base_damage")) *
                ability:GetSpecialValueFor("not_hero_damage_percent") /
                100
        end

        local damage_table = {
            victim = target,
            attacker = caster,
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = ability
        }
        ApplyDamage(damage_table)
    end
end
