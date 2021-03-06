function is_transport(keys)
    local caster = keys.caster
    local ability = keys.ability
    local target_entities = keys.target_entities
    local good = 0
    local bad = 0
    local good_hero = {}
    local bad_hero = {}
    for _, target in ipairs(target_entities) do
        if Utils:is_real_hero(target) then
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
        caster.is_stop_time = false
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
            --推进时间小于保底推进时间，则增加推进时间
            --若推进时间大于，则不变
            overtime()
        end
        caster.is_stop_time = false
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
        caster.is_stop_time = false
    elseif good ~= 0 and bad ~= 0 then
        --防御阶段不变
        --双方都在,在原地不动
        caster.is_bad_transport = false
        caster.is_good_transport = false
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_transport_stun", {duration = -1})
        --暂停时间
        caster.is_stop_time = true
    end

    --提供视野
    local loc = caster:GetAbsOrigin()
    local radius = ability:GetSpecialValueFor("vision_radius")
    local interval = ability:GetSpecialValueFor("interval")
    AddFOWViewer(DOTA_TEAM_GOODGUYS, loc, radius, interval, true)
    AddFOWViewer(DOTA_TEAM_BADGUYS, loc, radius, interval, true)
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
                    ability:ApplyDataDrivenModifier(
                        caster,
                        caster,
                        "modifier_transport_defend_road_section",
                        {duration = -1}
                    )
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
    if ability.remaining_time == nil then
        ability.remaining_time = tonumber(_G.load_map["defend_time_" .. _G.road_section_num]) + 2
    end
    --游戏没结束才运行
    if not caster.is_game_end then
        --剩余时间为0
        if ability.remaining_time == 0 then
            --防御阶段结束
            caster.is_defend = false
            --如果还存在下一个路点，则设置
            if _G.load_map[tostring(_G.next_corner + 1)] then
                denfend_success(caster)
            else
                print("End Game!")
                --如果已经到达最后一个路段终点并防御完成，则结束游戏，推进方获胜
                GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
                caster.is_game_end = true
            end
            ability.remaining_time = nil
        else
            start_defend(ability.remaining_time, caster)
            if not caster.is_stop_time then
                ability.remaining_time = ability.remaining_time - 1
            end
        end
    end
end

--防御阶段成功
function denfend_success(caster)
    print("End defend,turn to next road section!")
    Notifications:ClearTopFromAll()
    Notifications:TopToAll(
        {text = "#defend_success", duration = 2.0, style = {color = "yellow", ["font-size"] = "50px"}}
    )
    --成功音效
    caster:EmitSound("Tutorial.TaskCompleted")
    _G.pre_corner = _G.next_corner
    _G.next_corner = _G.next_corner + 1
    caster:MoveToPosition(Path:get_corner(_G.next_corner):GetOrigin())
    Utils:unit_abilities_lvlup(caster)
    --设置路段
    _G.road_section_num = _G.road_section_num + 1
    --设置双方重生点
    local good_change = Entities:FindByName(nil, "good_spawn_" .. _G.road_section_num):GetAbsOrigin()
    local bad_change = Entities:FindByName(nil, "bad_spawn_" .. _G.road_section_num):GetAbsOrigin()
    local good_starts = Entities:FindAllByClassname("info_player_start_goodguys")
    for _, good_start in pairs(good_starts) do
        good_start:SetOrigin(good_change)
    end
    local bad_starts = Entities:FindAllByClassname("info_player_start_badguys")
    for _, bad_start in pairs(bad_starts) do
        bad_start:SetOrigin(bad_change)
    end

    --推进时间奖励
    _G.push_time = _G.push_time + tonumber(_G.load_map["push_time_" .. _G.road_section_num])
    --若处于防御阶段，则结束防御阶段
    if caster:HasModifier("modifier_transport_defend_road_section") then
        caster:RemoveModifierByName("modifier_transport_defend_road_section")
        caster.is_defend = false
    end
end

--防御阶段开始
function start_defend(remaining_time, caster)
    --开始前2秒给提示
    if remaining_time == tonumber(_G.load_map["defend_time_" .. _G.road_section_num]) + 2 then
        print("Start Defend!")
        Notifications:ClearTopFromAll()
        Notifications:TopToAll(
            {text = "#start_defend", duration = 2.0, style = {color = "yellow", ["font-size"] = "50px"}}
        )
        --计时音效
        caster:EmitSound("Tutorial.TaskProgress")
    end
    --开始倒计时
    if remaining_time <= tonumber(_G.load_map["defend_time_" .. _G.road_section_num]) then
        print("Defend remaining time: " .. remaining_time)
        Notifications:ClearTopFromAll()
        Notifications:TopToAll(
            {text = remaining_time, duration = 0.9, style = {color = "yellow", ["font-size"] = "50px"}}
        )
        --计时音效
        caster:EmitSound("Tutorial.TaskProgress")
    end
end

--中断或结束防御阶段事件
function stop_defend(keys)
    local caster = keys.caster
    local ability = keys.ability
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_transport_road_section", {duration = -1})
    ability.remaining_time = nil
end

--推进阶段每秒事件
function is_push(keys)
    local caster = keys.caster
    if caster.is_game_end then
        return
    end
    --不处于防御阶段则倒计时
    if not caster.is_defend then
        if _G.push_time == 0 then
            --推进时间耗尽,游戏结束,防守方胜利
            print("Push Failed! End Game!")
            --防止一直弹队伍获胜
            -- _G.push_time = _G.push_time - 1
            caster.is_game_end = true
            GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
        elseif _G.push_time > 0 then
            local shortest_push_time = tonumber(_G.load_map["shortest_push_time"])
            if _G.push_time >= shortest_push_time then
                display_push_time()
                push_time_to_end(caster)
                print("Push remaining time: " .. _G.push_time)
                --剩余推进时间减1
                _G.push_time = _G.push_time - 1
            else
                if caster.is_stop_time then
                    display_push_time()
                    push_time_to_end(caster)
                    print("Push remaining time: " .. _G.push_time)
                else
                    display_push_time()
                    push_time_to_end(caster)
                    print("Push remaining time: " .. _G.push_time)
                    --剩余推进时间减1
                    _G.push_time = _G.push_time - 1
                end
            end
        end
    else
        --若处于防御阶段，并且推进时间小于进入防守阶段保底推进时间，则增加推进时间
        --若推进时间大于，则不变
        overtime()
        display_push_time()
    end
end

--加时
function overtime()
    local shortest_push_time = tonumber(_G.load_map["shortest_push_time"])
    if _G.push_time < shortest_push_time then
        _G.push_time = shortest_push_time
        Notifications:ClearTopFromAll()
        Notifications:TopToAll({text = "#overtime", duration = 1.0, style = {color = "yellow", ["font-size"] = "50px"}})
    end
end

--显示推进时间
function display_push_time()
    --获取推进时间分秒
    local push_time_min = math.modf(_G.push_time / 60)
    local push_time_sec = math.fmod(_G.push_time, 60)
    if push_time_min < 10 then
        push_time_min = "0" .. push_time_min
    end
    if push_time_sec < 10 then
        push_time_sec = "0" .. push_time_sec
    end
    local show_push_time_event = {
        push_time_min = push_time_min,
        push_time_sec = push_time_sec
    }
    --推进时间UI显示
    CustomGameEventManager:Send_ServerToAllClients("show_push_time", show_push_time_event)
end

--推进时间不足提示
function push_time_to_end(caster)
    --提前2秒文字提示
    if _G.push_time == _G.countdown + 2 then
        Notifications:ClearTopFromAll()
        Notifications:TopToAll(
            {text = "#push_time_to_end", duration = 2.0, style = {color = "red", ["font-size"] = "50px"}}
        )
        --计时音效
        caster:EmitSound("Tutorial.TaskProgress")
    end
    --倒计时数字提示
    if _G.push_time <= _G.countdown then
        Notifications:ClearTopFromAll()
        Notifications:TopToAll({text = _G.push_time, duration = 0.9, style = {color = "red", ["font-size"] = "50px"}})
        --计时音效
        caster:EmitSound("Tutorial.TaskProgress")
    end
end
