function get_vision_movespeed(keys)
    local caster = keys.caster
    local ability = keys.ability
    AddFOWViewer(
        caster:GetTeam(),
        caster:GetAbsOrigin(),
        ability:GetSpecialValueFor("vision_range"),
        ability:GetSpecialValueFor("interval"),
        false
    )
    if caster:HasModifier("modifier_keen_movespeed") then
        caster:SetModifierStackCount("modifier_keen_movespeed", caster, caster:GetLevel())
    else
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_keen_movespeed", {})
        caster:SetModifierStackCount("modifier_keen_movespeed", caster, caster:GetLevel())
    end
end
