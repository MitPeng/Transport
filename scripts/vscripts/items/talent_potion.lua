function talent_potion(keys)
    local caster = keys.caster
    local ability = keys.ability
    if Utils:is_real_hero(caster) then
        --消耗一层
        local charges = ability:GetCurrentCharges()
        if charges > 1 then
            ability:SetCurrentCharges(charges - 1)
        else
            UTIL_RemoveImmediate(ability)
        end
        --调用天赋技能选择面板
        --随机5个天赋技能
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
            if #abilities == 5 then
                break
            end
        end
        local is_first = false
        if caster.talent_ability then
            is_first = false
        else
            is_first = true
        end
        --选择天赋技能
        CustomGameEventManager:Send_ServerToPlayer(
            PlayerResource:GetPlayer(caster:GetPlayerID()),
            "show_ability_selector",
            {
                PlayerID = caster:GetPlayerID(),
                Abilities = abilities,
                is_first = is_first
            }
        )
    else
        _G.msg.bottom("#cant_use", caster:GetPlayerOwnerID())
    end
end
