function is_transport(keys)
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
        --如果不是防守方反推进，则执行
        --如果正在反推进，则不执行
        if not caster.is_bad_transport then
            --解除眩晕
            if caster:HasModifier("modifier_transport_stun") then
                caster:RemoveModifierByName("modifier_transport_stun")
            end
            --运输方不在，防守方在
            --如果处于防守目标点阶段,则移除防守buff
            if caster.is_defend then
                caster.is_defend = false
                caster:RemoveModifierByName("modifier_transport_defend_road_section")
            end
            --退至上一个目标点
            caster.is_good_transport = false
            caster.is_bad_transport = true
            Path:find_path(caster, Path:get_path(caster))
            --防守方加经验和金钱
            for i, hero in ipairs(bad_hero) do
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
        end
    elseif good ~= 0 and bad == 0 then
        --如果不是推进方推进，则执行
        --如果正在推进，则不执行
        if not caster.is_good_transport then
            --解除眩晕
            if caster:HasModifier("modifier_transport_stun") then
                caster:RemoveModifierByName("modifier_transport_stun")
            end
            --运输方在，防守方不在，则推至下一个目标点
            caster.is_bad_transport = false
            caster.is_good_transport = true
            Path:find_path(caster, Path:get_path(caster))
            --运输方加经验和金钱
            for i, hero in ipairs(good_hero) do
                if hero:IsRealHero() then
                    local level = hero:GetLevel()
                    local xp = _G.load_kv["base_bonus_xp"] + level * _G.load_kv["lvl_bonus_xp"]
                    hero:AddExperience(xp, 0, false, false)
                    local gold =
                        PlayerResource:GetUnreliableGold(hero:GetPlayerID()) + _G.load_kv["base_bonus_gold"] +
                        level * _G.load_kv["lvl_bonus_gold"]
                    PlayerResource:SetGold(hero:GetPlayerID(), gold, false)
                end
            end
        end
    else
        --双方都不在或双方都在，则在原地不动
        caster.is_bad_transport = false
        caster.is_good_transport = false
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
    local ability = keys.ability
    --加载下一路段信息
    local corners = _G.load_map["road_section_" .. (_G.road_section_num + 1)]
    --判断与目标点的距离
    local distance =
        Path:distance_between_two_point(caster:GetOrigin(), Entities:FindByName(nil, corners["1"]):GetOrigin())
    -- 如果到达目标点附近
    if (distance <= 10.0 and distance >= 0) then
        --如果进入目标点,但还没进入防御阶段
        if not caster.is_defend then
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_transport_defend_road_section", {})
            caster.is_defend = true
        end
    end
end

--防御阶段每秒事件
function is_defend(keys)
    local caster = keys.caster
    local modifier = caster:FindModifierByName("modifier_transport_defend_road_section")
    local remaining_time = modifier:GetRemainingTime()
    print("Defend remaining time: " .. math.ceil(remaining_time))
end

--防御阶段结束
function end_defend(keys)
    local caster = keys.caster
    caster.is_defend = false
    local next_road_section_num = _G.road_section_num + 1
    --如果还存在下一个路段，则设置下一个路段标志
    if _G.load_map["road_section_" .. (_G.road_section_num + 1)] then
        print("End defend,turn to next road section!")
        _G.road_section_num = next_road_section_num
        Utils:unit_abilities_lvlup(caster)
    else
        print("End Game!")
        --如果已经到达最后一个路段终点并防御完成，则结束游戏，推进方获胜
        GameRules.SetGameWinner(DOTA_TEAM_GOODGUYS)
    end
end
