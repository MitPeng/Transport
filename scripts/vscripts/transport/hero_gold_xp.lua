function get_gold_xp(keys)
    local hero = keys.caster
    if hero:IsRealHero() then
        local level = hero:GetLevel()
        local xp = _G.load_kv["base_xp"] + level * _G.load_kv["lvl_xp"]
        --快速升级到初生指定等级
        if hero:GetLevel() < tonumber(_G.load_kv["first_spawn_hero_lvl"]) then
            --到6级正好2280经验
            hero:AddExperience(2280, 0, false, false)
        else
            hero:AddExperience(xp, 0, false, false)
        end
        local gold =
            PlayerResource:GetUnreliableGold(hero:GetPlayerID()) + _G.load_kv["base_gold"] +
            level * _G.load_kv["lvl_gold"]
        PlayerResource:SetGold(hero:GetPlayerID(), gold, false)
    end
end
