-- Generated from template

if TransportGameMode == nil then
	TransportGameMode = class({})
end

-- require files
require("timers")
require("utils")
require("msg")
require("path")
require("notifications")
require("string")

function Precache(context)
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
	PrecacheResource("soundfile", "soundevents/game_sounds_ui_imported.vsndevts", context)
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = TransportGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function TransportGameMode:InitGameMode()
	local map_name = GetMapName()
	--全局变量
	-- 载入kv
	_G.load_kv = LoadKeyValues("scripts/vscripts/kv/load_kv.txt")
	--根据地图名载入地图信息
	_G.load_map = LoadKeyValues("scripts/vscripts/kv/load_map_" .. map_name .. ".txt")

	--保存路段
	_G.road_section_num = 1

	--保存上一路点和下一路点
	_G.pre_corner = 1
	_G.next_corner = 2

	--推进时间
	_G.push_time = tonumber(_G.load_map["push_time_" .. _G.road_section_num])

	-- 监听事件
	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(TransportGameMode, "OnGameRulesStateChange"), self)
	-- 监听单位重生或者创建事件
	ListenToGameEvent("npc_spawned", Dynamic_Wrap(TransportGameMode, "OnNPCSpawned"), self)

	-- 设置选择英雄时间
	GameRules:SetHeroSelectionTime(90)
	-- 设置决策时间
	GameRules:SetStrategyTime(0)
	-- 设置展示时间
	GameRules:SetShowcaseTime(0)
	-- 设置游戏准备时间
	GameRules:SetPreGameTime(0)
	-- 设置不能买活
	GameRules:GetGameModeEntity():SetBuybackEnabled(false)
	-- 设置复活时间
	GameRules:GetGameModeEntity():SetFixedRespawnTime(10.0)
	-- 设置初始金钱
	GameRules:SetStartingGold(tonumber(_G.load_kv["first_spawn_hero_gold"]))
	-- 开启宇宙商店模式
	GameRules:SetUseUniversalShopMode(true)
	-- 7.23更新，使用modifier来为英雄增加被动金钱
	GameRules:SetGoldTickTime(0)
	GameRules:SetGoldPerTick(0)
	-- 垃圾回收
	GameRules:GetGameModeEntity():SetContextThink(
		DoUniqueString("collectgarbage"),
		function()
			collectgarbage("collect")
			return 300
		end,
		120
	)

	GameRules:GetGameModeEntity():SetThink("OnThink", self, "GlobalThink", 1)
end

function TransportGameMode:OnGameRulesStateChange(keys)
	-- DeepPrintTable(keys)
	-- 获取游戏进度
	local newState = GameRules:State_Get()

	if newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		-- print("Player begin select hero") -- 玩家处于选择英雄界面
	elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then
		-- print("Player ready game begin") -- 玩家处于游戏准备状态
		-- MakeRandomHeroSelection()
	elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		-- print("Player game begin") -- 玩家开始游戏
		-- 游戏开始后生成运输车
		local vec = Path:get_corner_vector(_G.pre_corner)
		local car = Utils:create_unit_simple("car_1", vec, true, DOTA_TEAM_GOODGUYS)
	end
end

-- 单位出生
function TransportGameMode:OnNPCSpawned(keys)
	local hero = EntIndexToHScript(keys.entindex)
	if hero:IsRealHero() then
		-- 初次重生
		if hero.is_first_spawn == nil then
			hero.is_first_spawn = false
			-- 添加自动获取经验金钱
			local ability = hero:AddAbility("hero_gold_xp")
			ability:SetLevel(1)
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
		Timers:CreateTimer(
			0.1,
			function()
				hero:SetOrigin(vec)
				--加个相位效果，防止英雄卡位
				hero:AddNewModifier(hero, nil, "modifier_phased", {duration = 0.1})
				--镜头聚焦英雄后取消
				PlayerResource:SetCameraTarget(hero:GetPlayerID(), hero)
				Timers:CreateTimer(
					0.2,
					function()
						PlayerResource:SetCameraTarget(hero:GetPlayerID(), nil)
					end
				)
			end
		)
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
