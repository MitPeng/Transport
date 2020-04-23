function init_count(keys)
    local caster = keys.caster
    local ability = keys.ability
    local hero_level = caster:GetLevel()
    local block_count =
        ability:GetSpecialValueFor("base_block_damage") + ability:GetSpecialValueFor("lvl_block_damage") * hero_level
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_block_master_block_damage", {})
    caster:SetModifierStackCount("modifier_block_master_block_damage", caster, block_count)
    ability.trigger_damage = block_count * ability:GetSpecialValueFor("trigger_times")
end
