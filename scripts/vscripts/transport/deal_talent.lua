function deal_talent(keys)
    local caster = keys.caster
    local talent_ability = caster.talent_ability
    --有天赋技能的话
    if talent_ability ~= nil then
        --循环判断是否有另一个天赋技能
        local count = caster:GetAbilityCount()
        for i = 0, count - 1 do
            local ability = caster:GetAbilityByIndex(i)
            if ability then
                --是天赋技能，且与已有天赋技能不一样
                local ability_name = ability:GetAbilityName()
                local is_talent = false
                for _, v in pairs(_G.talent_abilities) do
                    if v == ability_name then
                        is_talent = true
                        print(ability_name)
                    end
                end
                if is_talent == true and abilities_name ~= talent_ability:GetAbilityName() then
                    --如果有就删掉技能和buff
                    caster:RemoveAbility("ability_name")
                    for j = 0, caster:GetModifierCount() do
                        local modifier_name = caster:GetModifierNameByIndex(j)
                        if modifier_name ~= nil and string.find(modifier_name, ability_name) then
                            caster:RemoveModifierByName(modifier_name)
                        end
                    end
                end
            end
        end
    end
end
