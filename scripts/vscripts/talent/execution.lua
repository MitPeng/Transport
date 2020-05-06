function execution(keys)
    keys.target:Kill(keys.ability, keys.caster)
    local caster = keys.caster
    local ability = keys.ability
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_execution_cd", {})
end
