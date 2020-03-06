if path == nil then path = {} end
---[[
function path:find_path(unit, path_corners)
    unit.next_corner_num = 1
    Timers:CreateTimer(0.1, function()
        local i = tonumber(unit.next_corner_num)
        local path_corner = path_corners[i]
        if path_corner then
            local next_corner = Entities:FindByName(nil, path_corner)
            if not GameRules:IsGamePaused() then
                local next_corner_point = next_corner:GetOrigin()
                local distance = path:distance_between_two_point(
                                     unit:GetOrigin(), next_corner_point)
                -- 到达目标点附近，指向下一个点，否则继续移动到目标点
                if (distance <= 10.0 and distance >= 0) then
                    unit.next_corner_num = i + 1
                else
                    unit:MoveToPositionAggressive(next_corner_point)
                end
            end
        end
        return 0.1
    end)
    return 0.1
end
-- ]]

-- 规划corner_1到corner_7的100个路点的路线
function path:get_path()
    local p = {}
    for i = 1, 150 do
        if i == 1 or i == 150 then
            p[i] = "corner_1"
        else
            if p[i - 1] then
                if p[i - 1] == "corner_1" then
                    p[i] = "corner_" .. tostring(RandomInt(2, 7))
                elseif p[i - 1] == "corner_2" then
                    local num = RandomInt(1, 3)
                    if num == 1 then
                        p[i] = "corner_1"
                    elseif num == 2 then
                        p[i] = "corner_3"
                    elseif num == 3 then
                        p[i] = "corner_4"
                    end
                elseif p[i - 1] == "corner_3" then
                    local num = RandomInt(1, 3)
                    if num == 1 then
                        p[i] = "corner_1"
                    elseif num == 2 then
                        p[i] = "corner_2"
                    elseif num == 3 then
                        p[i] = "corner_5"
                    end
                elseif p[i - 1] == "corner_4" then
                    local num = RandomInt(1, 3)
                    if num == 1 then
                        p[i] = "corner_1"
                    elseif num == 2 then
                        p[i] = "corner_2"
                    elseif num == 3 then
                        p[i] = "corner_6"
                    end
                elseif p[i - 1] == "corner_5" then
                    local num = RandomInt(1, 3)
                    if num == 1 then
                        p[i] = "corner_1"
                    elseif num == 2 then
                        p[i] = "corner_3"
                    elseif num == 3 then
                        p[i] = "corner_7"
                    end
                elseif p[i - 1] == "corner_6" then
                    local num = RandomInt(1, 3)
                    if num == 1 then
                        p[i] = "corner_1"
                    elseif num == 2 then
                        p[i] = "corner_4"
                    elseif num == 3 then
                        p[i] = "corner_7"
                    end
                elseif p[i - 1] == "corner_7" then
                    local num = RandomInt(1, 3)
                    if num == 1 then
                        p[i] = "corner_1"
                    elseif num == 2 then
                        p[i] = "corner_5"
                    elseif num == 3 then
                        p[i] = "corner_6"
                    end
                end
            end
        end
    end
    return p
end

-- 计算两点（三维向量）之间距离
function path:distance_between_two_point(point_1, point_2)
    return ((point_1.x - point_2.x) ^ 2 + (point_1.y - point_2.y) ^ 2) ^ 0.5
end
