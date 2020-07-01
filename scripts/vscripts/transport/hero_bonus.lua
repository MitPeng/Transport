function apply_modifier_count(keys)
    local hero = keys.caster
    local ability = keys.ability
    local hero_attr = hero:GetPrimaryAttribute()
    ability:ApplyDataDrivenModifier(hero, hero, "modifier_hero_bonus_hp", {duration = -1})
    ability:ApplyDataDrivenModifier(hero, hero, "modifier_hero_bonus_mp", {duration = -1})
    if hero_attr == 0 then
        hero:SetModifierStackCount("modifier_hero_bonus_hp", hero, 1)
        hero:SetModifierStackCount("modifier_hero_bonus_mp", hero, 3)
    elseif hero_attr == 1 then
        hero:SetModifierStackCount("modifier_hero_bonus_hp", hero, 2)
        hero:SetModifierStackCount("modifier_hero_bonus_mp", hero, 2)
    elseif hero_attr == 2 then
        hero:SetModifierStackCount("modifier_hero_bonus_hp", hero, 3)
        hero:SetModifierStackCount("modifier_hero_bonus_mp", hero, 1)
    end
end
