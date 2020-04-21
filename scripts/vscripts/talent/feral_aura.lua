function feral_aura(keys)
    local caster = keys.caster
    local target = keys.target
    local lvl = caster:GetLevel()
    target:SetModifierStackCount("modifier_feral_aura_count", caster, lvl)
end
