function is_apply(keys)
    local caster = keys.caster
    local target = keys.unit
    if target:IsRealHero() then
        local ability = keys.ability
        if caster:HasModifier("modifier_soul_harvest_count") then
            local count = caster:GetModifierStackCount("modifier_soul_harvest_count", caster)
            caster:SetModifierStackCount("modifier_soul_harvest_count", caster, count + 1)
        else
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_soul_harvest_count", {})
            caster:SetModifierStackCount("modifier_soul_harvest_count", caster, 1)
        end
    end
end
