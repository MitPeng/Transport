function summon_zombie(keys)
    local caster = keys.caster
    local target = keys.unit
    if target:IsRealHero() then
        local zombie_loc = target:GetAbsOrigin()
        local zombie_lvl = caster:GetLevel() - 1
        local zombie =
            Utils:create_unit_and_set_ability("unit_zombie", zombie_loc, true, caster, caster, caster:GetTeam())
        zombie:SetControllableByPlayer(caster:GetPlayerID(), false)
        zombie:SetOwner(caster)
        zombie:AddNewModifier(caster, self, "modifier_kill", {duration = keys.ability:GetSpecialValueFor("duration")})
        zombie:CreatureLevelUp(zombie_lvl)
    end
end

function is_hungry(keys)
    local caster = keys.caster
    local target_entities = keys.target_entities
    local ability = keys.ability
    local zombie_is_hungry = false
    for _, target in ipairs(target_entities) do
        if target:GetHealthPercent() <= ability:GetSpecialValueFor("hp_percent") then
            zombie_is_hungry = true
        end
    end
    if zombie_is_hungry then
        if not caster:HasModifier("modifier_hungry_count") then
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_hungry_count", {})
            caster:SetModifierStackCount("modifier_hungry_count", caster, caster:GetLevel())
        end
    else
        if caster:HasModifier("modifier_hungry_count") then
            caster:RemoveModifierByName("modifier_hungry_count")
        end
    end
end

function apply_damage(keys)
    local caster = keys.caster
    local lvl = caster:GetLevel()
    local target_entities = keys.target_entities
    local ability = keys.ability
    local damage = ability:GetSpecialValueFor("base_damage") + ability:GetSpecialValueFor("lvl_damage") * lvl
    for _, target in ipairs(target_entities) do
        local damage_table = {
            victim = target,
            attacker = caster,
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL
        }
        ApplyDamage(damage_table)
    end
end
