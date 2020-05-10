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
        local radius = keys.ability:GetSpecialValueFor("radius")
        if Path:distance_between_two_point(hero:GetAbsOrigin(), _G.transport_car:GetAbsOrigin()) < radius then
            local add_xp = _G.load_kv["base_bonus_xp"] + level * _G.load_kv["lvl_bonus_xp"]
            hero:AddExperience(add_xp, 0, false, false)
            -- PopupXPGain(hero, math.floor(xp))
            local add_gold = _G.load_kv["base_bonus_gold"] + level * _G.load_kv["lvl_bonus_gold"]
            local total_gold = PlayerResource:GetUnreliableGold(hero:GetPlayerID()) + add_gold
            PlayerResource:SetGold(hero:GetPlayerID(), total_gold, false)
        -- PopupGoldGain(hero, math.floor(add_gold))
        end
    end
end
