function get_gold_xp(keys)
    local hero = keys.caster
    if hero:IsRealHero() then
        local level = hero:GetLevel()
        local xp = _G.load_kv["base_xp"] + level * _G.load_kv["lvl_xp"]
        hero:AddExperience(xp, 0, false, false)
        local gold =
            PlayerResource:GetUnreliableGold(hero:GetPlayerID()) + _G.load_kv["base_gold"] +
            level * _G.load_kv["lvl_gold"]
        PlayerResource:SetGold(hero:GetPlayerID(), gold, false)
    end
end
