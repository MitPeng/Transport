function talent_potion(keys)
    local caster = keys.caster
    local ability = keys.ability
    --消耗一层
    local charges = ability:GetCurrentCharges()
    if charges > 1 then
        ability:SetCurrentCharges(charges - 1)
    else
        UTIL_RemoveImmediate(ability)
    end
    --调用天赋技能选择面板
    --随机4个天赋技能
    local abilities = {}
    while true do
        local rd = RandomInt(1, _G.abilities_num)
        local isHave = false
        for i = 0, #abilities do
            if abilities[i] and abilities[i] == _G.talent_abilities[tostring(rd)] then
                isHave = true
                break
            end
        end
        if not isHave then
            table.insert(abilities, _G.talent_abilities[tostring(rd)])
        end
        if #abilities == 4 then
            break
        end
    end
    --选择天赋技能
    CustomGameEventManager:Send_ServerToPlayer(
        PlayerResource:GetPlayer(caster:GetPlayerID()),
        "show_ability_selector",
        {
            PlayerID = caster:GetPlayerID(),
            Abilities = abilities,
            is_first = false
        }
    )
end
