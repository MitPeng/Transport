function init_count(keys)
    local caster = keys.caster
    local ability = keys.ability
    local hero_level = caster:GetLevel()
    local block_count =
        math.ceil(
        ability:GetSpecialValueFor("base_block_damage") + ability:GetSpecialValueFor("lvl_block_damage") * hero_level
    )
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_block_master_block_damage", {})
    caster:SetModifierStackCount("modifier_block_master_block_damage", caster, block_count)
    ability.trigger_damage = block_count * ability:GetSpecialValueFor("trigger_times")
end

function fire_effect(keys)
    local caster = keys.caster
    local particle = ParticleManager:CreateParticle("particles/block_master.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0, 0, 0), false) --origin
    local modifier = caster:FindModifierByName("modifier_block_master_block_damage")
    modifier:AddParticle(particle, false, false, -1, true, false)
    keys.ability.particle = particle
end

function destroy_effect(keys)
    ParticleManager:DestroyParticle(keys.ability.particle, true)
end
