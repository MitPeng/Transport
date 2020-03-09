if Path == nil then
    Path = {}
end

--根据路线寻路
---[[
function Path:find_path(unit, path_corners)
    unit.next_corner_num = 1
    Timers:CreateTimer(
        0.1,
        function()
            local i = tonumber(unit.next_corner_num)
            local path_corner = path_corners[i]
            if path_corner then
                local next_corner = Entities:FindByName(nil, path_corner)
                if not GameRules:IsGamePaused() then
                    local next_corner_point = next_corner:GetOrigin()
                    local distance = Path:distance_between_two_point(unit:GetOrigin(), next_corner_point)
                    -- 到达目标点附近，指向下一个点，否则继续移动到目标点
                    if (distance <= 10.0 and distance >= 0) then
                        unit.next_corner_num = i + 1
                    else
                        unit:MoveToPositionAggressive(next_corner_point)
                    end
                end
            end
            return 0.1
        end
    )
    return 0.1
end
-- ]]

-- 规划运输车运动路线
function Path:get_path(unit)
    local p = {}
    --加载路段信息
    local corners = _G.load_map["road_section_" .. _G.road_section_num]
    local next_corner_num = unit.next_corner_num
    --初始路点避免出错
    if next_corner_num == 1 then
        next_corner_num = 2
    end
    local is_transport = unit.is_transport
    --如果是运输状态
    --路点计数
    local k = 1
    if is_transport then
        for i = next_corner_num, #corners do
            p[k] = corners[i]
            k = k + 1
        end
    else --如果不是运输状态
        for i = next_corner_num - 1, 1 do
            p[k] = corners[i]
            k = k + 1
        end
    end
    return p
end

-- 计算两点（三维向量）之间距离
function Path:distance_between_two_point(point_1, point_2)
    return ((point_1.x - point_2.x) ^ 2 + (point_1.y - point_2.y) ^ 2) ^ 0.5
end
