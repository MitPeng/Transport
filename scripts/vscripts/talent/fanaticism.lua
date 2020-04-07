function is_apply(keys)
    local caster = keys.caster
    local ability = keys.ability
    -- 获取当前释放的技能
    local event_ability = keys.event_ability
    --不是物品，不是切换型技能
    if
        not event_ability:IsItem() and not event_ability:IsToggle() and
            event_ability:GetCooldown(event_ability:GetLevel() - 1) ~= 0
     then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_fanaticism_apply", {})
    end
end
