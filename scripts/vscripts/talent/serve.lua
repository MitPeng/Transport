function serve(keys)
    local caster = keys.caster
    local target_entities = keys.target_entities
    local ability = keys.ability
    local count = 0
    local nearest = nil
    --计算周围友方英雄个数和最近的友方英雄
    for _, target in ipairs(target_entities) do
        if Utils:is_real_hero(target) and target ~= caster and target:GetLevel() < 30 then
            count = count + 1
            if nearest == nil then
                nearest = target
            else
                if
                    Path:distance_between_two_point(nearest:GetAbsOrigin(), caster:GetAbsOrigin()) >
                        Path:distance_between_two_point(target:GetAbsOrigin(), caster:GetAbsOrigin())
                 then
                    nearest = target
                end
            end
        end
    end
    local xp = math.ceil(ability:GetSpecialValueFor("lvl_xp") * caster:GetLevel() * count)
    local xp_half = math.ceil(xp / 2)
    local level = caster:GetLevel()
    local lvl_share_half = ability:GetSpecialValueFor("lvl_share_half")
    local lvl_share_all = ability:GetSpecialValueFor("lvl_share_all")
    --经验分一半给最近的友方英雄
    if level >= lvl_share_half and level < lvl_share_all then
        --经验全分给最近的友方英雄
        if nearest then
            caster:AddExperience(xp_half, 0, false, false)
            nearest:AddExperience(xp_half, 0, false, false)
            PopupXPGain(caster, xp_half)
            PopupXPGain(nearest, xp_half)
        else
            caster:AddExperience(xp_half, 0, false, false)
            PopupXPGain(caster, xp_half)
        end
    elseif level >= lvl_share_all then
        if nearest then
            nearest:AddExperience(xp, 0, false, false)
            PopupXPGain(nearest, xp)
        end
    else
        if count > 0 then
            caster:AddExperience(xp, 0, false, false)
            PopupXPGain(caster, xp)
        end
    end
end
