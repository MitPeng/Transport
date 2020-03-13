function is_transport(keys)
    local caster = keys.caster
    local ability = keys.ability
    local target_entities = keys.target_entities
    local good = 0
    local bad = 0
    local good_hero = {}
    local bad_hero = {}
    for _, target in ipairs(target_entities) do
        if target:IsRealHero() then
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
    end
    if good == 0 and bad ~= 0 then
        --根据人数设置移速
        if caster:HasModifier("modifier_transport_move_speed") then
            caster:SetModifierStackCount("modifier_transport_move_speed", caster, bad)
        else
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_transport_move_speed", {duration = -1})
            caster:SetModifierStackCount("modifier_transport_move_speed", caster, bad)
        end

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
            caster:MoveToPosition(Path:get_corner(_G.pre_corner):GetOrigin())
        -- Path:find_path(caster, Path:get_path(caster))
        end
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
    elseif good ~= 0 and bad == 0 then
        --根据人数设置移速
        if caster:HasModifier("modifier_transport_move_speed") then
            caster:SetModifierStackCount("modifier_transport_move_speed", caster, good)
        else
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_transport_move_speed", {duration = -1})
            caster:SetModifierStackCount("modifier_transport_move_speed", caster, good)
        end
        --若不处于防御阶段，则去下一个路点
        if not caster:HasModifier("modifier_transport_defend_road_section") then
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
                caster:MoveToPosition(Path:get_corner(_G.next_corner):GetOrigin())
            -- Path:find_path(caster, Path:get_path(caster))
            end
        end
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
    elseif good == 0 and bad == 0 then
        --双方都不在，在原地不动
        caster.is_bad_transport = false
        caster.is_good_transport = false
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_transport_stun", {duration = -1})
        --若处于防御阶段，则结束防御阶段
        if caster:HasModifier("modifier_transport_defend_road_section") then
            caster:RemoveModifierByName("modifier_transport_defend_road_section")
            caster.is_defend = false
        end
    elseif good ~= 0 and bad ~= 0 then
        --防御阶段不变
        --双方都在,在原地不动
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

--判断是否到达下一路点,到达则更换上一路点和下一路点信息
--判断是否进入防御阶段
function change_corner(keys)
    local caster = keys.caster
    local ability = keys.ability
    if caster.is_good_transport then
        --加载下一路点信息
        local corner = Path:get_corner(_G.next_corner)
        --判断与目标点的距离
        local distance = Path:distance_between_two_point(caster:GetOrigin(), corner:GetOrigin())
        -- 如果到达目标点附近
        if (distance <= 10.0 and distance >= 0) then
            --判断下一个路点是否为阶段目标点
            if string.find(Path:get_corner_name(_G.next_corner), "corner") == 1 then
                _G.pre_corner = _G.next_corner
                _G.next_corner = _G.next_corner + 1
                caster:MoveToPosition(Path:get_corner(_G.next_corner):GetOrigin())
            elseif string.find(Path:get_corner_name(_G.next_corner), "section") == 1 then
                --如果进入目标点,但还没进入防御阶段
                if not caster.is_defend then
                    ability:ApplyDataDrivenModifier(caster, caster, "modifier_transport_defend_road_section", {})
                    caster:RemoveModifierByName("modifier_transport_road_section")
                    caster.is_defend = true
                end
            end
        end
    elseif caster.is_bad_transport then
        --加载上一路点信息
        local corner = Path:get_corner(_G.pre_corner)
        --判断与目标点的距离
        local distance = Path:distance_between_two_point(caster:GetOrigin(), corner:GetOrigin())
        -- 如果到达目标点附近
        if (distance <= 10.0 and distance >= 0) then
            --判断下一个路点是否为阶段目标点
            if string.find(Path:get_corner_name(_G.pre_corner), "corner") == 1 then
                _G.next_corner = _G.pre_corner
                _G.pre_corner = _G.pre_corner - 1
                caster:MoveToPosition(Path:get_corner(_G.pre_corner):GetOrigin())
            elseif string.find(Path:get_corner_name(_G.pre_corner), "section") == 1 then
            --若为目标点，则不变
            end
        end
    end
end

--防御阶段每秒事件
function is_defend(keys)
    local caster = keys.caster
    local ability = keys.ability
    local modifier = caster:FindModifierByName("modifier_transport_defend_road_section")
    local remaining_time = math.ceil(modifier:GetRemainingTime())
    if remaining_time == 0 then
        --防御阶段结束
        caster.is_defend = false
        --如果还存在下一个路点，则设置
        if _G.load_map[tostring(_G.next_corner + 1)] then
            print("End defend,turn to next road section!")
            Notifications:TopToAll(
                {text = "#defend_success", duration = 3.0, style = {color = "red", ["font-size"] = "50px"}}
            )
            _G.pre_corner = _G.next_corner
            _G.next_corner = _G.next_corner + 1
            caster:MoveToPosition(Path:get_corner(_G.next_corner):GetOrigin())
            Utils:unit_abilities_lvlup(caster)
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_transport_road_section", {duration = -1})
        else
            print("End Game!")
            --如果已经到达最后一个路段终点并防御完成，则结束游戏，推进方获胜
            GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
        end
    else
        print("Defend remaining time: " .. remaining_time)
        Notifications:TopToAll({text = remaining_time, duration = 0.9, style = {color = "red", ["font-size"] = "50px"}})
    end
end
