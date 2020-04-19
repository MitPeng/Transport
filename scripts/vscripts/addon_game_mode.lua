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
	_G.map_name = GetMapName()
	--全局变量
	-- 载入kv
	_G.load_kv = LoadKeyValues("scripts/vscripts/kv/load_kv.txt")
	--根据地图名载入地图信息
	_G.load_map = LoadKeyValues("scripts/vscripts/kv/load_map_" .. _G.map_name .. ".txt")
	--载入经验表
	_G.load_lvlup_xp = LoadKeyValues("scripts/vscripts/kv/load_lvlup_xp.txt")
	--保存路段
	_G.road_section_num = 1
	--天赋技能
	_G.talent_abilities = _G.load_map["talent_abilities"]
	--天赋技能个数
	_G.abilities_num = 0
	for _, _ in pairs(_G.talent_abilities) do
		_G.abilities_num = _G.abilities_num + 1
	end

	--保存上一路点和下一路点
	_G.pre_corner = 1
	_G.next_corner = 2

	--推进时间
	_G.push_time = tonumber(_G.load_map["push_time_" .. _G.road_section_num])

	--记录路段点
	_G.map_sections = {}
	local i = 1
	for _, v in pairs(_G.load_map) do
		if type(v) == "string" then
			if string.find(v, "section") == 1 then
				_G.map_sections[i] = Entities:FindByName(nil, v):GetAbsOrigin()
				i = i + 1
			end
		end
	end

	--记录初次出生所需等级经验
	local first_spawn_hero_lvl = tonumber(_G.load_kv["first_spawn_hero_lvl"])
	local total_xp = 0
	for k = 1, first_spawn_hero_lvl - 1 do
		--每级增加经验从经验表中获取
		local lvlup_xp = tonumber(_G.load_lvlup_xp[tostring(k)])
		total_xp = total_xp + lvlup_xp
	end
	_G.first_spawn_xp = total_xp

	--商店范围扩大
	-- for num = 1, tonumber(_G.load_map["spawn_num"]) do
	-- 	local spawn_point_good = Entities:FindByName(nil, "good_spawn_" .. num):GetOrigin()
	-- 	SpawnDOTAShopTriggerRadiusApproximate(spawn_point_good, 800)
	-- 	local spawn_point_bad = Entities:FindByName(nil, "bad_spawn_" .. num):GetOrigin()
	-- 	SpawnDOTAShopTriggerRadiusApproximate(spawn_point_bad, 800)
	-- end

	-- 监听事件
	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(TransportGameMode, "OnGameRulesStateChange"), self)
	-- 监听单位重生或者创建事件
	ListenToGameEvent("npc_spawned", Dynamic_Wrap(TransportGameMode, "OnNPCSpawned"), self)
	-- 监听玩家聊天事件
	ListenToGameEvent("player_chat", Dynamic_Wrap(TransportGameMode, "PlayerChat"), self)

	CustomGameEventManager:RegisterListener(
		"player_select_ability",
		function(_, keys)
			self:OnPlayerSelectAbility(keys)
		end
	)

	-- 设置选择英雄时间
	GameRules:SetHeroSelectionTime(90)
	-- 设置决策时间
	GameRules:SetStrategyTime(0)
	-- 设置展示时间
	GameRules:SetShowcaseTime(0)
	-- 设置游戏准备时间
	GameRules:SetPreGameTime(60)
	-- 设置不能买活
	GameRules:GetGameModeEntity():SetBuybackEnabled(false)
	-- 设置复活时间
	GameRules:GetGameModeEntity():SetFixedRespawnTime(10.0)
	--设置泉水回蓝回血
	GameRules:GetGameModeEntity():SetFountainPercentageManaRegen(10.0)
	GameRules:GetGameModeEntity():SetFountainPercentageHealthRegen(10.0)
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

function TransportGameMode:OnPlayerSelectAbility(keys)
	local abilityName = keys.AbilityName
	--随机一个技能
	if abilityName == "Random" then
		local rd = RandomInt(1, _G.abilities_num)
		abilityName = _G.talent_abilities[tostring(rd)]
	end
	--取消更换
	if abilityName == "Cancel" then
		return
	end
	local playerID = keys.PlayerID
	local player = PlayerResource:GetPlayer(playerID)
	local hero = player:GetAssignedHero()
	if not hero then
		return
	end

	if hero.talent_ability then
		--删除原有的天赋技能
		for i = 0, hero:GetModifierCount() do
			local modifier_name = hero:GetModifierNameByIndex(i)
			-- print(i .. ":" .. modifier_name)
			if modifier_name ~= nil and string.find(modifier_name, hero.talent_ability:GetAbilityName()) then
				hero:RemoveModifierByName(modifier_name)
			end
		end
		hero:RemoveAbilityByHandle(hero.talent_ability)
		hero.talent_ability = nil
	end

	--添加新的天赋技能
	local ability = hero:AddAbility(abilityName)
	ability:SetLevel(1)
	hero.talent_ability = ability
end

function TransportGameMode:OnGameRulesStateChange(keys)
	-- 获取游戏进度
	local newState = GameRules:State_Get()
	if newState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
	elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		-- print("Player begin select hero") -- 玩家处于选择英雄界面
		Timers:CreateTimer(
			1.0,
			function()
				--显示所有天赋技能
				local all_talent_abilities = {}
				for num = 1, _G.abilities_num do
					table.insert(all_talent_abilities, _G.talent_abilities[tostring(num)])
				end
				CustomGameEventManager:Send_ServerToAllClients(
					"show_all_talent_abilities",
					{
						Abilities = all_talent_abilities
					}
				)
			end
		)
	elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then
		-- print("Player ready game begin") -- 玩家处于游戏准备状态
		Timers:CreateTimer(
			4.0,
			function()
				--准备时间提示
				Notifications:TopToAll({text = "#glhf", duration = 6.0, style = {color = "yellow", ["font-size"] = "40px"}})
			end
		)
		Timers:CreateTimer(
			12.0,
			function()
				--玩家准备提示
				Notifications:TopToAll(
					{text = "#player_prepare", duration = 6.0, style = {color = "yellow", ["font-size"] = "40px"}}
				)
			end
		)
		Timers:CreateTimer(
			20.0,
			function()
				--运输车出生提示
				Notifications:TopToAll({text = "#car_spawn", duration = 30.0, style = {color = "yellow", ["font-size"] = "40px"}})
				local start_vec = Path:get_corner(_G.pre_corner):GetAbsOrigin()
				for i = 0, 10 do
					Timers:CreateTimer(
						i * 3,
						function()
							CustomGameEventManager:Send_ServerToAllClients("frd_ping_minimap", {loc = start_vec})
						end
					)
				end
			end
		)
	elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		-- print("Player game begin") -- 玩家开始游戏
		-- 添加自动获取经验金钱
		for i = 0, 9 do
			local player = PlayerResource:GetPlayer(i)
			if player then
				local hero = player:GetAssignedHero()
				local ability = hero:AddAbility("hero_gold_xp")
				ability:SetLevel(1)
			end
		end
		-- 游戏开始后生成运输车
		local vec = Path:get_corner_vector(_G.pre_corner)
		local car = Utils:create_unit_simple(_G.load_map["car_name"], vec, true, DOTA_TEAM_GOODGUYS)
		car:SetForwardVector(Path:get_corner_vector(_G.next_corner) - Path:get_corner_vector(_G.pre_corner))
		--保存运输车实体
		_G.transport_car = car
		--开始运输提示
		Notifications:TopToAll(
			{text = "#start_transport", duration = 3.0, style = {color = "yellow", ["font-size"] = "50px"}}
		)
	end
end

-- 单位出生
function TransportGameMode:OnNPCSpawned(keys)
	local hero = EntIndexToHScript(keys.entindex)
	if hero:IsRealHero() then
		-- 初次重生
		if hero.is_first_spawn == nil then
			hero.is_first_spawn = false
			--升至指定等级
			hero:AddExperience(_G.first_spawn_xp, 0, false, false)
			--加初始天赋药水
			Timers:CreateTimer(
				2.0,
				function()
					hero:AddItemByName("item_talent_potion_2")
				end
			)
		end

		--处理骷髅王大招
		if hero:GetUnitName() == "npc_dota_hero_skeleton_king" then
			print("skt")
			local ability = hero:FindAbilityByName("skeleton_king_reincarnation")
			local cd = ability:GetCooldownTimeRemaining()
			local ability_level = ability:GetLevel()
			print("ability_lvl:" .. ability_level)
			print("cd:" .. cd)
			if ability_level > 0 and cd > (ability:GetCooldown(ability_level) * hero:GetCooldownReduction() - 5) then
				return
			end
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
			0.2,
			function()
				hero:SetOrigin(vec)
				--加个相位效果，防止英雄卡位
				if not hero:HasAbility("keen") and not hero:HasAbility("rebirth") then
					hero:AddNewModifier(hero, nil, "modifier_phased", {duration = 0.1})
				end
				--镜头聚焦英雄后取消
				PlayerResource:SetCameraTarget(hero:GetPlayerID(), hero)
			end
		)
		Timers:CreateTimer(
			0.4,
			function()
				PlayerResource:SetCameraTarget(hero:GetPlayerID(), nil)
			end
		)
	end
end

function TransportGameMode:PlayerChat(keys)
	if _G.map_name == "map_1" then
		--添加天赋技能
		--猛然一击
		if keys.text == "suddenly_strike" then
			local hero = PlayerResource:GetPlayer(keys.userid - 1):GetAssignedHero()
			local ability = hero:AddAbility("suddenly_strike")
			ability:SetLevel(1)
			hero.talent_ability = ability
		end
		--嗜血
		if keys.text == "bloodthirsty" then
			local hero = PlayerResource:GetPlayer(keys.userid - 1):GetAssignedHero()
			local ability = hero:AddAbility("bloodthirsty")
			ability:SetLevel(1)
			hero.talent_ability = ability
		end
		--暗黑粉碎
		if keys.text == "dark_breaking" then
			local hero = PlayerResource:GetPlayer(keys.userid - 1):GetAssignedHero()
			local ability = hero:AddAbility("dark_breaking")
			ability:SetLevel(1)
			hero.talent_ability = ability
		end
		--冲锋
		if keys.text == "charge" then
			local hero = PlayerResource:GetPlayer(keys.userid - 1):GetAssignedHero()
			local ability = hero:AddAbility("charge")
			ability:SetLevel(1)
			hero.talent_ability = ability
		end
		--狂热
		if keys.text == "fanaticism" then
			local hero = PlayerResource:GetPlayer(keys.userid - 1):GetAssignedHero()
			local ability = hero:AddAbility("fanaticism")
			ability:SetLevel(1)
			hero.talent_ability = ability
		end
		--坚毅不屈
		if keys.text == "unyielding" then
			local hero = PlayerResource:GetPlayer(keys.userid - 1):GetAssignedHero()
			local ability = hero:AddAbility("unyielding_lua")
			ability:SetLevel(1)
			hero.talent_ability = ability
		end
		-- 生命源泉
		if keys.text == "source_of_life" then
			local hero = PlayerResource:GetPlayer(keys.userid - 1):GetAssignedHero()
			local ability = hero:AddAbility("source_of_life")
			ability:SetLevel(1)
			hero.talent_ability = ability
		end
		-- 格挡大师
		if keys.text == "block_master" then
			local hero = PlayerResource:GetPlayer(keys.userid - 1):GetAssignedHero()
			local ability = hero:AddAbility("block_master")
			ability:SetLevel(1)
			hero.talent_ability = ability
		end
		-- 势不可挡
		if keys.text == "unstoppable" then
			local hero = PlayerResource:GetPlayer(keys.userid - 1):GetAssignedHero()
			local ability = hero:AddAbility("unstoppable_lua")
			ability:SetLevel(1)
			hero.talent_ability = ability
		end
		-- 沸腾之血
		if keys.text == "boiling_blood" then
			local hero = PlayerResource:GetPlayer(keys.userid - 1):GetAssignedHero()
			local ability = hero:AddAbility("boiling_blood")
			ability:SetLevel(1)
			hero.talent_ability = ability
		end
		-- 敏锐
		if keys.text == "keen" then
			local hero = PlayerResource:GetPlayer(keys.userid - 1):GetAssignedHero()
			local ability = hero:AddAbility("keen")
			ability:SetLevel(1)
			hero.talent_ability = ability
		end
		-- 法力澎湃
		if keys.text == "mana_surging" then
			local hero = PlayerResource:GetPlayer(keys.userid - 1):GetAssignedHero()
			local ability = hero:AddAbility("mana_surging")
			ability:SetLevel(1)
			hero.talent_ability = ability
		end
		-- 奥术领悟
		if keys.text == "arcane_comprehension" then
			local hero = PlayerResource:GetPlayer(keys.userid - 1):GetAssignedHero()
			local ability = hero:AddAbility("arcane_comprehension_lua")
			ability:SetLevel(1)
			hero.talent_ability = ability
		end
		-- 灵魂收割
		if keys.text == "soul_harvest" then
			local hero = PlayerResource:GetPlayer(keys.userid - 1):GetAssignedHero()
			local ability = hero:AddAbility("soul_harvest")
			ability:SetLevel(1)
			hero.talent_ability = ability
		end
		-- 重生之欲
		if keys.text == "rebirth" then
			local hero = PlayerResource:GetPlayer(keys.userid - 1):GetAssignedHero()
			local ability = hero:AddAbility("rebirth")
			ability:SetLevel(1)
			hero.talent_ability = ability
		end
		-- 守财奴
		if keys.text == "miser" then
			local hero = PlayerResource:GetPlayer(keys.userid - 1):GetAssignedHero()
			local ability = hero:AddAbility("miser")
			ability:SetLevel(1)
			hero.talent_ability = ability
		end
		--删除天赋技能
		if keys.text == "delete_talent" then
			local hero = PlayerResource:GetPlayer(keys.userid - 1):GetAssignedHero()
			for i = 0, hero:GetModifierCount() do
				local modifier_name = hero:GetModifierNameByIndex(i)
				-- print(i .. ":" .. modifier_name)
				if modifier_name ~= nil and string.find(modifier_name, hero.talent_ability:GetAbilityName()) then
					hero:RemoveModifierByName(modifier_name)
				end
			end
			hero:RemoveAbilityByHandle(hero.talent_ability)
			hero.talent_ability = nil
		end
		--调出天赋选择面板
		if keys.text == "select_talent" then
			local hero = PlayerResource:GetPlayer(keys.userid - 1):GetAssignedHero()
			local abilities = {}
			while true do
				local rd = RandomInt(1, _G.abilities_num)
				local isHave = false
				for i = 0, #abilities do
					if abilities[i] and abilities[i] == _G.talent_abilities[tostring(rd)] then
						isHave = true
						break
					end
				end
				if not isHave then
					table.insert(abilities, _G.talent_abilities[tostring(rd)])
				end
				if #abilities == 4 then
					break
				end
			end
			--选择天赋技能
			CustomGameEventManager:Send_ServerToPlayer(
				PlayerResource:GetPlayer(hero:GetPlayerID()),
				"show_ability_selector",
				{
					PlayerID = hero:GetPlayerID(),
					Abilities = abilities,
					is_first = false
				}
			)
		end
	end
end

-- Evaluate the state of the game
function TransportGameMode:OnThink()
	--每个路段点提供视野
	for _, v in ipairs(_G.map_sections) do
		local loc = v
		local radius = 600
		local interval = 1.0
		AddFOWViewer(DOTA_TEAM_GOODGUYS, loc, radius, interval, false)
		AddFOWViewer(DOTA_TEAM_BADGUYS, loc, radius, interval, false)
	end

	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end
