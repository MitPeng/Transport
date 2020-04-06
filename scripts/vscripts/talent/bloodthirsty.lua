function count_buff(keys)
    local caster = keys.caster
    local ability = keys.ability
    local attack_times = ability:GetSpecialValueFor("attack_times")
    --如果有嗜血buff则刷新持续时间
    if caster:HasModifier("modifier_bloodthirsty_apply") then
        caster:RemoveModifierByName("modifier_bloodthirsty_apply")
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_bloodthirsty_apply", {})
    else
        --如果有计数buff
        if caster:HasModifier("modifier_bloodthirsty_count") then
            --计数buff层数
            local count = caster:GetModifierStackCount("modifier_bloodthirsty_count", caster)
            --计数buff小于attack_times-1则加1
            if count < attack_times - 1 then
                count = count + 1
                caster:RemoveModifierByName("modifier_bloodthirsty_count")
                ability:ApplyDataDrivenModifier(caster, caster, "modifier_bloodthirsty_count", {})
                caster:SetModifierStackCount("modifier_bloodthirsty_count", caster, count)
            elseif count == attack_times - 1 then --计数等于attack_times-1则加嗜血buff并清除计数buff
                caster:RemoveModifierByName("modifier_bloodthirsty_count")
                ability:ApplyDataDrivenModifier(caster, caster, "modifier_bloodthirsty_apply", {})
            end
        else --如果没有计数buff则加上并设置层数为1
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_bloodthirsty_count", {})
            caster:SetModifierStackCount("modifier_bloodthirsty_count", caster, 1)
        end
    end
end
