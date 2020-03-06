if Utils == nil then
    print('[Utils] creating Utils')
    Utils = {}
end

-- 创建单位并设置所有技能等级为1
function Utils:create_unit_and_set_ability(sUnitName, vPosition, bClearSpace,
                                           hNPCOwner, hUnitOwner, nTeamNumber)
    local unit = CreateUnitByName(sUnitName, vPosition, bClearSpace, hNPCOwner,
                                  hUnitOwner, nTeamNumber)
    -- 设置技能等级
    local count = unit:GetAbilityCount()
    for i = 0, count - 1 do
        ability = unit:GetAbilityByIndex(i)
        if ability then ability:SetLevel(1) end
    end
    return unit
end

-- 无需知道拥有者的创建单位
function Utils:create_unit_simple(sUnitName, vPosition, bClearSpace, nTeamNumber)
    return Utils:create_unit_and_set_ability(sUnitName, vPosition, bClearSpace,
                                             nil, nil, nTeamNumber)
end

-- 计算两点间角度0-180
function Utils:getAngleByPos(p1, p2)
    local x1 = p1.x
    local x2 = p2.x
    local y1 = p1.y
    local y2 = p2.y
    local cos = (x1 * x2 + y1 * y2) /
                    ((x1 ^ 2 + y1 ^ 2) ^ 0.5 * (x2 ^ 2 + y2 ^ 2) ^ 0.5)
    local r = math.deg(math.acos(cos))
    return r
end
