function set_respawn_time(keys)
    local caster = keys.caster
    --处理骷髅王大招
    if caster:GetUnitName() == "npc_dota_hero_skeleton_king" then
        local ability = caster:FindAbilityByName("skeleton_king_reincarnation")
        local cd = ability:GetCooldownTimeRemaining()
        local ability_level = ability:GetLevel()
        if ability_level > 0 and cd > (ability:GetCooldown(ability_level) * caster:GetCooldownReduction() - 5) then
            return
        end
    end
    --处理尸王重生
    if caster:GetUnitName() == "npc_dota_hero_undying" then
        local ability = caster:FindAbilityByName("special_bonus_reincarnation_300")
        if ability:GetLevel() == 1 then
            local cd = caster:FindModifierByName("modifier_special_bonus_reincarnation"):GetRemainingTime()
            print(cd)
            if cd > 294.8 then
                return
            end
        end
    end
    caster:SetTimeUntilRespawn(0)
end
