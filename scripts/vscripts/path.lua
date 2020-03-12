if Path == nil then
    Path = {}
end

-- 计算两点（三维向量）之间距离
function Path:distance_between_two_point(point_1, point_2)
    return ((point_1.x - point_2.x) ^ 2 + (point_1.y - point_2.y) ^ 2) ^ 0.5
end

--根据路点数字获取路点实体
function Path:get_corner(corner_num)
    return Entities:FindByName(nil, _G.load_map[tostring(corner_num)])
end

function Path:get_corner_vector(corner_num)
    return Entities:FindByName(nil, _G.load_map[tostring(corner_num)]):GetOrigin()
end

function Path:get_corner_name(corner_num)
    return _G.load_map[tostring(corner_num)]
end
