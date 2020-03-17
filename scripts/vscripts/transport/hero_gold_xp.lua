function get_gold_xp(keys)
    local hero = keys.caster
    if hero:IsRealHero() then
        local level = hero:GetLevel()
        local xp = _G.load_kv["base_xp"] + level * _G.load_kv["lvl_xp"]
        --快速升级到初生指定等级
        local first_spawn_hero_lvl = tonumber(_G.load_kv["first_spawn_hero_lvl"])
        if level < first_spawn_hero_lvl then
            local total_xp = 0
            for i = 1, first_spawn_hero_lvl - 1 do
                --每级增加经验从经验表中获取
                local lvlup_xp = tonumber(_G.load_lvlup_xp[tostring(i)])
                total_xp = total_xp + lvlup_xp
            end
            hero:AddExperience(total_xp, 0, false, false)
        else
            hero:AddExperience(xp, 0, false, false)
        end
        local gold =
            PlayerResource:GetUnreliableGold(hero:GetPlayerID()) + _G.load_kv["base_gold"] +
            level * _G.load_kv["lvl_gold"]
        PlayerResource:SetGold(hero:GetPlayerID(), gold, false)
    end
end
