if Utils == nil then
    print("[Utils] creating Utils")
    Utils = {}
end

-- 创建单位并设置所有技能等级为1
function Utils:create_unit_and_set_ability(sUnitName, vPosition, bClearSpace, hNPCOwner, hUnitOwner, nTeamNumber)
    local unit = CreateUnitByName(sUnitName, vPosition, bClearSpace, hNPCOwner, hUnitOwner, nTeamNumber)
    -- 设置技能等级
    local count = unit:GetAbilityCount()
    for i = 0, count - 1 do
        local ability = unit:GetAbilityByIndex(i)
        if ability then
            ability:SetLevel(1)
        end
    end
    return unit
end

-- 无需知道拥有者的创建单位
function Utils:create_unit_simple(sUnitName, vPosition, bClearSpace, nTeamNumber)
    return Utils:create_unit_and_set_ability(sUnitName, vPosition, bClearSpace, nil, nil, nTeamNumber)
end

--单位所有技能升一级
function Utils:unit_abilities_lvlup(unit)
    -- 设置技能等级
    local count = unit:GetAbilityCount()
    for i = 0, count - 1 do
        local ability = unit:GetAbilityByIndex(i)
        if ability then
            ability:SetLevel(ability:GetLevel() + 1)
        end
    end
    return unit
end

--判断是否为真英雄本体
function Utils:is_real_hero(hero)
    if hero:IsRealHero() then
        local player_hero = PlayerResource:GetSelectedHeroEntity(hero:GetPlayerID())
        if player_hero ~= nil and player_hero ~= hero then
            return false
        else
            return true
        end
    else
        return false
    end
end

-- 计算两点间角度0-180
function Utils:getAngleByPos(p1, p2)
    local x1 = p1.x
    local x2 = p2.x
    local y1 = p1.y
    local y2 = p2.y
    local cos = (x1 * x2 + y1 * y2) / ((x1 ^ 2 + y1 ^ 2) ^ 0.5 * (x2 ^ 2 + y2 ^ 2) ^ 0.5)
    local r = math.deg(math.acos(cos))
    return r
end

function Utils:count_nums(t)
    local count = 0

    if type(t) ~= "table" then
        t = {}
    end

    for k, v in pairs(t) do
        count = count + 1
    end

    return count
end

POPUP_SYMBOL_PRE_PLUS = 0 --加号
POPUP_SYMBOL_PRE_MINUS = 1 --减号
POPUP_SYMBOL_PRE_SADFACE = 2 --悲伤的脸
POPUP_SYMBOL_PRE_BROKENARROW = 3 --断开的箭
POPUP_SYMBOL_PRE_SHADES = 4 --墨镜
POPUP_SYMBOL_PRE_MISS = 5 --MISS,丢失
POPUP_SYMBOL_PRE_EVADE = 6 --EVADE,回避
POPUP_SYMBOL_PRE_DENY = 7 --DENY,否决
POPUP_SYMBOL_PRE_ARROW = 8 --向上的箭头

POPUP_SYMBOL_POST_EXCLAMATION = 0 --无
POPUP_SYMBOL_POST_POINTZERO = 1 --".0"
POPUP_SYMBOL_POST_MEDAL = 2 --勋章
POPUP_SYMBOL_POST_DROP = 3 --水滴
POPUP_SYMBOL_POST_LIGHTNING = 4 --闪电
POPUP_SYMBOL_POST_SKULL = 5 --骷髅
POPUP_SYMBOL_POST_EYE = 6 --眼睛
POPUP_SYMBOL_POST_SHIELD = 7 --盾牌
POPUP_SYMBOL_POST_POINTFIVE = 8 --".5"

-- e.g. when healed by an ability
function PopupHealing(target, amount)
    PopupNumbers(target, "heal", Vector(0, 255, 0), 1.0, amount, POPUP_SYMBOL_PRE_PLUS, nil)
end

-- e.g. the popup you get when you suddenly take a large portion of your health pool in damage at once
function PopupDamage(target, amount)
    PopupNumbers(target, "damage", Vector(255, 0, 0), 1.0, amount, nil, POPUP_SYMBOL_POST_DROP)
end

-- e.g. when dealing critical damage
function PopupCriticalDamage(target, amount)
    PopupNumbers(target, "crit", Vector(255, 0, 0), 1.0, amount, nil, POPUP_SYMBOL_POST_LIGHTNING)
end

-- e.g. when taking damage over time from a poison type spell
function PopupDamageOverTime(target, amount)
    PopupNumbers(target, "poison", Vector(215, 50, 248), 1.0, amount, nil, POPUP_SYMBOL_POST_EYE)
end

-- e.g. when blocking damage with a stout shield
function PopupDamageBlock(target, amount)
    PopupNumbers(target, "block", Vector(255, 255, 255), 1.0, amount, POPUP_SYMBOL_PRE_MINUS, nil)
end

-- e.g. when last-hitting a creep
function PopupGoldGain(target, amount)
    PopupNumbers(target, "gold", Vector(255, 200, 33), 1.0, amount, POPUP_SYMBOL_PRE_PLUS, nil)
end

function PopupXPGain(target, amount)
    PopupNumbers(target, "gold", Vector(30, 144, 255), 1.0, amount, POPUP_SYMBOL_PRE_PLUS, nil)
end

-- e.g. when missing uphill
function PopupMiss(target)
    PopupNumbers(target, "miss", Vector(255, 0, 0), 1.0, nil, POPUP_SYMBOL_PRE_MISS, nil)
end

-- Customizable version.
function PopupNumbers(target, pfx, color, lifetime, number, presymbol, postsymbol)
    local pfxPath = string.format("particles/msg_fx/msg_%s.vpcf", pfx)
    local pidx = ParticleManager:CreateParticle(pfxPath, PATTACH_ABSORIGIN_FOLLOW, target) -- target:GetOwner()

    local digits = 0
    if number ~= nil then
        digits = #tostring(number)
    end
    if presymbol ~= nil then
        digits = digits + 1
    end
    if postsymbol ~= nil then
        digits = digits + 1
    end

    ParticleManager:SetParticleControl(pidx, 1, Vector(tonumber(presymbol), tonumber(number), tonumber(postsymbol)))
    ParticleManager:SetParticleControl(pidx, 2, Vector(lifetime, digits, 0))
    ParticleManager:SetParticleControl(pidx, 3, color)
end

function print_r(t)
    local print_r_cache = {}
    local function sub_print_r(t, indent)
        if (print_r_cache[tostring(t)]) then
            print(indent .. "*" .. tostring(t))
        else
            print_r_cache[tostring(t)] = true
            if (type(t) == "table") then
                for pos, val in pairs(t) do
                    if (type(val) == "table") then
                        print(indent .. "[" .. pos .. "] => " .. tostring(t) .. " {")
                        sub_print_r(val, indent .. string.rep(" ", string.len(pos) + 8))
                        print(indent .. string.rep(" ", string.len(pos) + 6) .. "}")
                    elseif (type(val) == "string") then
                        print(indent .. "[" .. pos .. '] => "' .. val .. '"')
                    else
                        print(indent .. "[" .. pos .. "] => " .. tostring(val))
                    end
                end
            else
                print(indent .. tostring(t))
            end
        end
    end
    if (type(t) == "table") then
        print(tostring(t) .. " {")
        sub_print_r(t, "  ")
        print("}")
    else
        sub_print_r(t, "  ")
    end
    print()
end
