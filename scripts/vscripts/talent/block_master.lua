function init_count(keys)
    local caster = keys.caster
    local ability = keys.ability
    local hero_level = caster:GetLevel()
    ability.hero_level = hero_level
    local base_damage = (caster:GetBaseDamageMax() + caster:GetBaseDamageMin()) / 2
    local block_percent = ability:GetSpecialValueFor("block_percent") / 100
    local damage_count = math.ceil(base_damage)
    local block_count = math.ceil(base_damage * block_percent)
    caster:SetModifierStackCount("modifier_block_master_lua_base_damage", caster, damage_count)
    caster:SetModifierStackCount("modifier_block_master_block_damage", caster, block_count)
end

function apply_count(keys)
    local caster = keys.caster
    local ability = keys.ability
    local hero_level = caster:GetLevel()
    if ability.hero_level ~= hero_level then
        ability.hero_level = hero_level
        local base_damage = (caster:GetBaseDamageMax() + caster:GetBaseDamageMin()) / 2
        local block_percent = ability:GetSpecialValueFor("block_percent") / 100
        local damage_count = math.ceil(base_damage)
        local block_count = math.ceil(base_damage * block_percent)
        caster:RemoveModifierByName("modifier_block_master_lua_base_damage")
        caster:RemoveModifierByName("modifier_block_master_block_damage")
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_block_master_lua_base_damage", {})
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_block_master_block_damage", {})
        caster:SetModifierStackCount("modifier_block_master_lua_base_damage", caster, damage_count)
        caster:SetModifierStackCount("modifier_block_master_block_damage", caster, block_count)
    end
end
