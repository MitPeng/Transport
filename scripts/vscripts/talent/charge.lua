function init_loc(keys)
    local caster = keys.caster
    caster.loc_1 = caster:GetAbsOrigin()
    caster.is_apply = true
end

function is_apply(keys)
    local caster = keys.caster
    local loc_2 = caster:GetAbsOrigin()
    local charge_distance = keys.ability:GetSpecialValueFor("charge_distance")
    local distance = Path:distance_between_two_point(caster.loc_1, loc_2)
    if distance >= charge_distance then
        if not caster:HasModifier("modifier_charge_apply") then
            keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_charge_apply", {})
            caster.is_apply = false
        else
            if caster.is_apply == true then
                keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_charge_apply", {})
                caster.is_apply = false
            end
        end
    end
end

function apply_count(keys)
    local caster = keys.caster
    local lvl = caster:GetLevel()
    if caster:HasModifier("modifier_charge_damage_amp") then
        caster:RemoveModifierByName("modifier_charge_damage_amp")
    end
    keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_charge_damage_amp", {})
    caster:SetModifierStackCount("modifier_charge_damage_amp", caster, lvl)
end
