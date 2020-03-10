-- Generated from template

if TransportGameMode == nil then
	TransportGameMode = class({})
end

-- require files
require("timers")
require("utils")
require("msg")
require("path")

--全局变量
-- 载入kv
_G.load_kv = LoadKeyValues("scripts/vscripts/kv/load_kv.txt")
_G.load_map = LoadKeyValues("scripts/vscripts/kv/load_map.txt")

--保存路段
_G.road_section_num = 1

-- 关联修改器
LinkLuaModifier("modifier_hero_xp_gold", "modifiers/modifier_hero_xp_gold.lua", LUA_MODIFIER_MOTION_NONE)

function Precache(context)
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = TransportGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function TransportGameMode:InitGameMode()
	-- 监听单位重生或者创建事件
	ListenToGameEvent("npc_spawned", Dynamic_Wrap(TransportGameMode, "OnNPCSpawned"), self)

	GameRules:GetGameModeEntity():SetThink("OnThink", self, "GlobalThink", 2)
end

-- 单位出生
function TransportGameMode:OnNPCSpawned(keys)
	local hero = EntIndexToHScript(keys.entindex)
	if hero:IsHero() then
		-- 初次重生
		if hero.is_first_spawn == nil then
			hero.is_first_spawn = false
			--设置英雄初次重生等级和金钱
			local hero_lvl = tonumber(_G.load_kv["first_spawn_hero_lvl"])
			for i = 1, hero_lvl - 1 do
				hero:HeroLevelUp(false)
			end
			hero:SetGold(tonumber(_G.load_kv["first_spawn_hero_gold"]), false)

			-- 添加自动获取经验金钱
			hero:AddNewModifier(hero, nil, "modifier_hero_xp_gold", {duration = -1})
		end
		--根据当前路段设置重生点
		--天辉夜魇重生点不同
		local spawn_point
		if hero:GetTeam() == DOTA_TEAM_GOODGUYS then
			--获取重生点位置
			spawn_point = "good_spawn_" .. _G.road_section_num
		elseif hero:GetTeam() == DOTA_TEAM_BADGUYS then
			spawn_point = "bad_spawn_" .. _G.road_section_num
		end
		local vec = Entities:FindByName(nil, spawn_point):GetOrigin()
		hero:SetOrigin(vec)
	end
end

-- Evaluate the state of the game
function TransportGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end
