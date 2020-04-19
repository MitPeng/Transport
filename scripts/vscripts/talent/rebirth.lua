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
    caster:SetTimeUntilRespawn(0)
end
