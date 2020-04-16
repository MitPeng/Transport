function miser(keys)
    local caster = keys.caster
    local gold = PlayerResource:GetUnreliableGold(caster:GetPlayerID())
    local add_gold = math.ceil(gold * (keys.ability:GetSpecialValueFor("times") - 1))
    PlayerResource:SetGold(caster:GetPlayerID(), gold + add_gold, false)
    PopupGoldGain(caster, add_gold)
end
