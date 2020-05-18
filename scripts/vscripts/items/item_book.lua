function use_book(keys)
    local caster = keys.caster
    local ability = keys.ability
    if Utils:is_real_hero(caster) then
        local modifier_name = keys.modifier_name
        local void_modifier = keys.void_modifier
        local charges = ability:GetCurrentCharges()
        caster:EmitSound("Item.TomeOfKnowledge")
        if not caster:HasModifier(modifier_name) then
            ability:ApplyDataDrivenModifier(caster, caster, modifier_name, {duration = -1})
            caster:SetModifierStackCount(modifier_name, caster, 1)
        else
            local count = caster:GetModifierStackCount(modifier_name, caster)
            caster:SetModifierStackCount(modifier_name, caster, count + 1)
        end
        ability:ApplyDataDrivenModifier(caster, caster, void_modifier, {duration = -1})
        caster:RemoveModifierByName(void_modifier)
        if charges > 1 then
            ability:SetCurrentCharges(charges - 1)
        else
            UTIL_RemoveImmediate(ability)
        end
    else
        _G.msg.bottom("#cant_use", caster:GetOwner():GetPlayerID())
    end
end
