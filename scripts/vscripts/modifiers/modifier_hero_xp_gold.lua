-- 获取经验金钱
if modifier_hero_xp_gold == nil then
    modifier_hero_xp_gold = class({})
end

function modifier_hero_xp_gold:IsHidden()
    return true
end
function modifier_hero_xp_gold:IsDebuff()
    return false
end
function modifier_hero_xp_gold:IsPurgable()
    return false
end
function modifier_hero_xp_gold:IsPurgeException()
    return false
end
function modifier_hero_xp_gold:DestroyOnExpire()
    return false
end
function modifier_hero_xp_gold:RemoveOnDeath()
    return false
end

function modifier_hero_xp_gold:OnCreated(params)
    self:StartIntervalThink(0.3)
end
function modifier_hero_xp_gold:OnIntervalThink()
    local hero = self:GetParent()
    local level = hero:GetLevel()
    local xp = _G.load_kv["base_xp"] + level * _G.load_kv["lvl_xp"]
    hero:AddExperience(xp, 0, false, false)
    local gold =
        PlayerResource:GetUnreliableGold(hero:GetPlayerID()) + _G.load_kv["base_gold"] + level * _G.load_kv["lvl_gold"]
    PlayerResource:SetGold(hero:GetPlayerID(), gold, false)
end
