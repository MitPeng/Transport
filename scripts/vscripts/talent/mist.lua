function mist(keys)
    local caster = keys.caster
    local target_entities = keys.target_entities
    local ability = keys.ability
    local is_apply = true
    for _, target in ipairs(target_entities) do
        if Utils:is_real_hero(target) or target:IsClone() then
            is_apply = false
        end
    end
    if is_apply then
        if not caster:HasModifier("modifier_mist_apply") then
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_mist_apply", {duration = -1})
        end
        if not caster:HasModifier("modifier_smoke_of_deceit") then
            caster:AddNewModifier(caster, nil, "modifier_smoke_of_deceit", {duration = -1})
        end
    end
end

function broken_mist(keys)
    local caster = keys.caster
    local target_entities = keys.target_entities
    local is_broken = false
    for _, target in ipairs(target_entities) do
        if Utils:is_real_hero(target) or target:IsClone() then
            is_broken = true
        end
    end
    if is_broken then
        if caster:HasModifier("modifier_mist_apply") then
            caster:RemoveModifierByName("modifier_mist_apply")
        end
    end
end
