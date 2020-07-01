function apply_damage(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    caster:EmitSound("Ability.LagunaBlade")
    target:EmitSound("Ability.LagunaBladeImpact")
    local blade_pfx =
        ParticleManager:CreateParticle(
        "particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf",
        PATTACH_CUSTOMORIGIN,
        caster
    )
    ParticleManager:SetParticleControlEnt(
        blade_pfx,
        0,
        caster,
        PATTACH_POINT_FOLLOW,
        "attach_attack1",
        caster:GetAbsOrigin(),
        true
    )
    ParticleManager:SetParticleControlEnt(
        blade_pfx,
        1,
        target,
        PATTACH_POINT_FOLLOW,
        "attach_hitloc",
        target:GetAbsOrigin(),
        true
    )
    ParticleManager:ReleaseParticleIndex(blade_pfx)
    local main_attr = caster:GetPrimaryAttribute()
    local target_max_health = target:GetMaxHealth()
    local damage = ability:GetSpecialValueFor("base_damage")
    if main_attr == 0 then
        damage =
            damage + caster:GetStrength() * ability:GetSpecialValueFor("main_attribute_times") * target_max_health / 100
    elseif main_attr == 1 then
        damage =
            damage + caster:GetAgility() * ability:GetSpecialValueFor("main_attribute_times") * target_max_health / 100
    elseif main_attr == 2 then
        damage =
            damage +
            caster:GetIntellect() * ability:GetSpecialValueFor("main_attribute_times") * target_max_health / 100
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
