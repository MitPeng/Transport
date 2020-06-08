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
    local damage =
        caster:GetIntellect() * ability:GetSpecialValueFor("int_times") + ability:GetSpecialValueFor("base_damage")
    local damage_table = {
        victim = target,
        attacker = caster,
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = ability
    }
    ApplyDamage(damage_table)
end
