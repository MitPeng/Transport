function is_transport(key)
    local caster = keys.caster
    local ability = keys.ability
    local target_entities = keys.target_entities
    local good = 0
    local bad = 0
    local good_hero = {}
    local bad_hero = {}
    for _, target in ipairs(target_entities) do
        local team = target:GetTeam()
        if team then
            if team == DOTA_TEAM_GOODGUYS then
                good = good + 1
                good_hero[good] = target
            elseif team == DOTA_TEAM_BADGUYS then
                bad = bad + 1
                bad_hero[bad] = target
            end
        end
    end
    if good == 0 and bad ~= 0 then
        --解除眩晕
        if caster:HasModifier("modifier_transport_stun") then
            caster:RemoveModifierByName("modifier_transport_stun")
        end
        --运输方不在，防守方在，则退至上一个目标点
        caster.is_transport = false
        Path:find_path(caster, Path:get_path(caster))
        --防守方加经验和金钱
        for i, hero in ipairs(bad_hero) do
            local level = hero:GetLevel()
            local xp = _G.load_kv["base_xp"] + level * _G.load_kv["lvl_xp"]
            hero:AddExperience(xp, 0, false, false)
            local gold =
                PlayerResource:GetUnreliableGold(hero:GetPlayerID()) + _G.load_kv["base_gold"] +
                level * _G.load_kv["lvl_gold"]
            PlayerResource:SetGold(hero:GetPlayerID(), gold, false)
        end
    elseif good ~= 0 and bad == 0 then
        --解除眩晕
        if caster:HasModifier("modifier_transport_stun") then
            caster:RemoveModifierByName("modifier_transport_stun")
        end
        --运输方在，防守方不在，则推至下一个目标点
        caster.is_transport = true
        Path:find_path(caster, Path:get_path(caster))
        --运输方加经验和金钱
        for i, hero in ipairs(good_hero) do
            local level = hero:GetLevel()
            local xp = _G.load_kv["base_bonus_xp"] + level * _G.load_kv["lvl_bonus_xp"]
            hero:AddExperience(xp, 0, false, false)
            local gold =
                PlayerResource:GetUnreliableGold(hero:GetPlayerID()) + _G.load_kv["base_bonus_gold"] +
                level * _G.load_kv["lvl_bonus_gold"]
            PlayerResource:SetGold(hero:GetPlayerID(), gold, false)
        end
    else
        --双方都不在或双方都在，则在原地不动
        caster.is_transport = false
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_transport_stun", {duration = -1})
    end

    --提供视野
    local loc = caster:GetAbsOrigin()
    local radius = ability:GetSpecialValueFor("vision_radius")
    local interval = ability:GetSpecialValueFor("interval")
    AddFOWViewer(DOTA_TEAM_GOODGUYS, loc, radius, interval, false)
    AddFOWViewer(DOTA_TEAM_BADGUYS, loc, radius, interval, false)
end

--判断是否到达下一路段起点
function road_section(keys)
    local caster = keys.caster
    Path:set_road_section(caster)
end
