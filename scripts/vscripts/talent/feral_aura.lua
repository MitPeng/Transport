function feral_aura(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local lvl = caster:GetLevel()
    if not target:IsRealHero() then
        if not target:HasModifier("modifier_feral_aura_count") then
            ability:ApplyDataDrivenModifier(caster, target, "modifier_feral_aura_count", {duration = -1})
        end
        if not target:HasModifier("modifier_feral_aura_display") then
            ability:ApplyDataDrivenModifier(caster, target, "modifier_feral_aura_display", {duration = -1})
        end

        target:SetModifierStackCount("modifier_feral_aura_count", caster, lvl)
    else
        target:RemoveModifierByName("modifier_feral_aura_apply")
    end
end
