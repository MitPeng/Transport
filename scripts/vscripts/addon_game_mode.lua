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
	PrecacheResource("soundfile", "soundevents/game_sounds_items.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_undying.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_axe.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_lina.vsndevts", context)

	PrecacheResource("particle", "particles/author_effect.vpcf", context)
	PrecacheResource("particle", "particles/heart.vpcf", context)
	PrecacheResource("particle", "particles/desert_sands.vpcf", context)
	PrecacheResource("particle", "particles/frost.vpcf", context)
	PrecacheResource("particle", "particles/cave_crystal.vpcf", context)
	PrecacheResource("particle", "particles/darkmoon.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_oculopus/courier_oculopus_ambient.vpcf", context)
	PrecacheResource(
		"particle",
		"particles/econ/courier/courier_hyeonmu_ambient/courier_hyeonmu_ambient_gold.vpcf",
		context
	)
	PrecacheResource(
		"particle",
		"particles/econ/courier/courier_hyeonmu_ambient/courier_hyeonmu_ambient_blue_plus.vpcf",
		context
	)
	PrecacheResource(
		"particle",
		"particles/econ/courier/courier_hyeonmu_ambient/courier_hyeonmu_ambient_green.vpcf",
		context
	)
	PrecacheResource(
		"particle",
		"particles/econ/courier/courier_hyeonmu_ambient/courier_hyeonmu_ambient_red_plus.vpcf",
		context
	)
	PrecacheResource("particle", "particles/particles/bee_flying.vpcf", context)
	PrecacheResource("particle", "particles/particles/christmas.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_baekho/courier_baekho_ambient.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti7/ti7_hero_effect.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti8/ti8_hero_effect.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti9/ti9_emblem_effect.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti6/radiance_owner_ti6.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti7/radiance_owner_ti7.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti8/radiance_owner_ti8.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti9/radiance_owner_ti9.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti10/radiance_owner_ti10.vpcf", context)

	LinkLuaModifier("author_effect", "effect_modifiers/author_effect.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("desert_sands", "effect_modifiers/desert_sands.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("frost", "effect_modifiers/frost.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("cave_crystal", "effect_modifiers/cave_crystal.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("darkmoon", "effect_modifiers/darkmoon.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("void_mist", "effect_modifiers/void_mist.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("golden_fire", "effect_modifiers/golden_fire.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("blue_fire", "effect_modifiers/blue_fire.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("green_fire", "effect_modifiers/green_fire.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("red_fire", "effect_modifiers/red_fire.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("bee_flying", "effect_modifiers/bee_flying.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("christmas", "effect_modifiers/christmas.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("pink_memories", "effect_modifiers/pink_memories.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("ti10_effect", "effect_modifiers/ti10_effect.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("ti9_effect", "effect_modifiers/ti9_effect.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("ti8_effect", "effect_modifiers/ti8_effect.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("ti7_effect", "effect_modifiers/ti7_effect.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("ti10_radiance", "effect_modifiers/ti10_radiance.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("ti9_radiance", "effect_modifiers/ti9_radiance.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("ti8_radiance", "effect_modifiers/ti8_radiance.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("ti7_radiance", "effect_modifiers/ti7_radiance.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("ti6_radiance", "effect_modifiers/ti6_radiance.lua", LUA_MODIFIER_MOTION_NONE)
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
	--倒计时
	_G.countdown = tonumber(_G.load_map["countdown"])
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
	--nettable里的属性,结束面板数据
	_G.newStats = newStats or {}
	--记录初次出生所需等级经验
	local first_spawn_hero_lvl = tonumber(_G.load_kv["first_spawn_hero_lvl"])
	local total_xp = 0
	for k = 1, first_spawn_hero_lvl - 1 do
		--每级增加经验从经验表中获取
		local lvlup_xp = tonumber(_G.load_lvlup_xp[tostring(k)])
		total_xp = total_xp + lvlup_xp
	end
	_G.first_spawn_xp = total_xp

	-- 监听事件
	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(TransportGameMode, "OnGameRulesStateChange"), self)
	-- 监听单位重生或者创建事件
	ListenToGameEvent("npc_spawned", Dynamic_Wrap(TransportGameMode, "OnNPCSpawned"), self)
	-- 监听玩家聊天事件
	ListenToGameEvent("player_chat", Dynamic_Wrap(TransportGameMode, "PlayerChat"), self)
	-- 重连事件
	ListenToGameEvent("player_reconnected", Dynamic_Wrap(TransportGameMode, "OnPlayerReconnected"), self)
	-- 玩家全部连接
	ListenToGameEvent("player_connect_full", Dynamic_Wrap(TransportGameMode, "OnPlayerConnectFull"), self)
	-- 击杀事件
	ListenToGameEvent("entity_killed", Dynamic_Wrap(TransportGameMode, "OnEntityKilled"), self)
	-- 设置伤害过滤器
	GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(TransportGameMode, "DamageFilter"), self)
	-- 设置金币过滤器
	GameRules:GetGameModeEntity():SetModifyGoldFilter(Dynamic_Wrap(TransportGameMode, "GoldFilter"), self)
	-- 选择天赋技能
	CustomGameEventManager:RegisterListener(
		"player_select_ability",
		function(_, keys)
			self:OnPlayerSelectAbility(keys)
		end
	)
	-- 选择特效
	CustomGameEventManager:RegisterListener(
		"player_select_effect",
		function(_, keys)
			self:OnPlayerSelectEffect(keys)
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
	GameRules:GetGameModeEntity():SetFixedRespawnTime(15.0)
	-- 设置泉水回蓝回血
	GameRules:GetGameModeEntity():SetFountainPercentageManaRegen(10.0)
	GameRules:GetGameModeEntity():SetFountainPercentageHealthRegen(10.0)
	-- 神符刷新间隔
	-- GameRules:SetRuneSpawnTime(60)
	-- 功能神符刷新间隔
	-- GameRules:GetGameModeEntity():SetPowerRuneSpawnInterval(120)
	-- 设置初始金钱
	GameRules:SetStartingGold(tonumber(_G.load_kv["first_spawn_hero_gold"]))
	-- 开启宇宙商店模式
	GameRules:SetUseUniversalShopMode(true)
	-- 设置死亡不掉钱
	GameRules:GetGameModeEntity():SetLoseGoldOnDeath(false)
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

function TransportGameMode:OnPlayerSelectEffect(keys)
	local effectName = keys.EffectName
	local playerID = keys.PlayerID
	local player = PlayerResource:GetPlayer(playerID)
	local hero = player:GetAssignedHero()
	if not hero then
		return
	end
	if hero.effect_modifier ~= nil then
		hero:RemoveModifierByName(hero.effect_modifier:GetName())
	end
	local modifier = hero:AddNewModifier(hero, nil, effectName, {duration = -1})
	hero.effect_modifier = modifier
end

-- 当玩家连接完成
function TransportGameMode:OnPlayerConnectFull(keys)
	_G.players = _G.players or {}
	local player = {}
	player.userid = keys.index + 1
	player.playerid = keys.PlayerID
	player.steamid = PlayerResource:GetSteamAccountID(keys.PlayerID)
	_G.players[keys.userid] = player
end

-- 重连事件
function TransportGameMode:OnPlayerReconnected(event)
	-- 判断游戏进度
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		local hPlayer = PlayerResource:GetPlayer(event.PlayerID)
		if hPlayer ~= nil then
			-- 获取英雄
			local hPlayerHero = hPlayer:GetAssignedHero()
			-- 如果没金钱buff则加金钱buff
			if not hPlayerHero:HasAbility("hero_gold_xp") then
				local ability = hPlayerHero:AddAbility("hero_gold_xp")
				ability:SetLevel(1)
			end
		end
	end
end

function TransportGameMode:OnGameRulesStateChange(keys)
	-- 获取游戏进度
	local newState = GameRules:State_Get()
	if newState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
	elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		-- print("Player begin select hero") -- 玩家处于选择英雄界面
	elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then
		-- print("Player ready game begin") -- 玩家处于游戏准备状态
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
				--显示所有特效
				local all_effects = {
					"ti10_effect",
					"ti9_effect",
					"ti8_effect",
					"ti7_effect",
					"ti10_radiance",
					"ti9_radiance",
					"ti8_radiance",
					"ti7_radiance",
					"ti6_radiance",
					"bee_flying",
					"blue_fire",
					"cave_crystal",
					"christmas",
					"darkmoon",
					"desert_sands",
					"frost",
					"golden_fire",
					"green_fire",
					"pink_memories",
					"red_fire",
					"void_mist"
				}
				CustomGameEventManager:Send_ServerToAllClients(
					"show_all_effects",
					{
						Effects = all_effects
					}
				)
			end
		)
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
	if newState == DOTA_GAMERULES_STATE_POST_GAME then
		for i = 0, 12 do
			if PlayerResource:IsValidPlayer(i) then
				local networth = 0
				local hero = PlayerResource:GetSelectedHeroEntity(i)
				networth = networth + PlayerResource:GetGold(i)
				for s = 0, 8 do
					local item = hero:GetItemInSlot(s)

					if item then
						networth = networth + item:GetCost()
					end
				end
				local stats = {
					networth = networth,
					total_damage = PlayerResource:GetRawPlayerDamage(i),
					total_healing = PlayerResource:GetHealing(i),
					push_score = PlayerResource:GetPlayer(i):GetAssignedHero().push_score
				}

				if newStats and newStats[i] then
					stats.sentries_count = newStats[i].npc_dota_sentry_wards
					stats.observers_count = newStats[i].npc_dota_observer_wards
					stats.killed_hero = newStats[i].killed_hero
				end

				CustomNetTables:SetTableValue("custom_stats", tostring(i), stats)
				print_r(CustomNetTables:GetTableValue("custom_stats", tostring(i)))
			end
		end
	end
end

-- 击杀事件
function TransportGameMode:OnEntityKilled(event)
	local killedUnit = EntIndexToHScript(event.entindex_killed)
	local hero
	if event.entindex_attacker then
		hero = EntIndexToHScript(event.entindex_attacker)
	end
	if killedUnit:IsRealHero() and not killedUnit:IsReincarnating() then
		local player_id = -1
		if hero and hero:IsRealHero() and hero.GetPlayerID then
			player_id = hero:GetPlayerID()
		else
			if hero:GetPlayerOwnerID() ~= -1 then
				player_id = hero:GetPlayerOwnerID()
			end
		end
		if player_id ~= -1 then
			local name = killedUnit:GetUnitName()

			newStats[player_id] =
				newStats[player_id] or
				{
					npc_dota_sentry_wards = 0,
					npc_dota_observer_wards = 0,
					killed_hero = {}
				}

			local kh = newStats[player_id].killed_hero

			kh[name] = kh[name] and kh[name] + 1 or 1
		end
	end
end

-- 单位出生
function TransportGameMode:OnNPCSpawned(keys)
	local hero = EntIndexToHScript(keys.entindex)

	-- 记录插眼个数
	local owner = hero:GetOwner()
	local name = hero:GetUnitName()
	if owner and owner.GetPlayerID and (name == "npc_dota_sentry_wards" or name == "npc_dota_observer_wards") then
		local player_id = owner:GetPlayerID()

		newStats[player_id] =
			newStats[player_id] or
			{
				npc_dota_sentry_wards = 0,
				npc_dota_observer_wards = 0,
				killed_hero = {}
			}

		newStats[player_id][name] = newStats[player_id][name] + 1
	end

	if Utils:is_real_hero(hero) then
		-- 初次重生
		if hero.is_first_spawn == nil then
			hero.is_first_spawn = false

			--升至指定等级
			hero:AddExperience(_G.first_spawn_xp, 0, false, false)
			hero.push_score = 0
			-- 根据英雄属性添加英雄奖励
			local ability = hero:AddAbility("hero_bonus")
			ability:SetLevel(1)

			Timers:CreateTimer(
				0.5,
				function()
					--加初始天赋药水
					hero:AddItemByName("item_talent_potion_2")
					--加特效
					-- local steamid = PlayerResource:GetSteamAccountID(hero:GetPlayerID())
					-- if steamid == 179637729 or steamid == 111384022 then
					-- 	local modifier = hero:AddNewModifier(hero, nil, "author_effect", {duration = -1})
					-- 	hero.effect_modifier = modifier
					-- end
				end
			)
		-- 测试技能
		-- if _G.map_name == "map_1" then
		-- 	local ability = hero:AddAbility("feral_aura")
		-- 	ability:SetLevel(1)
		-- 	hero.talent_ability = ability
		-- end
		--加个技能，处理存在多个英雄天赋技能的情况
		-- local ability = hero:AddAbility("deal_talent")
		-- ability:SetLevel(1)
		end

		--处理骷髅王大招
		if hero:GetUnitName() == "npc_dota_hero_skeleton_king" then
			local ability = hero:FindAbilityByName("skeleton_king_reincarnation")
			local cd = ability:GetCooldownTimeRemaining()
			local ability_level = ability:GetLevel()
			if ability_level > 0 and cd > (ability:GetCooldown(ability_level) * hero:GetCooldownReduction() - 5) then
				return
			end
		end

		--处理尸王重生
		if hero:GetUnitName() == "npc_dota_hero_undying" then
			local ability = hero:FindAbilityByName("special_bonus_reincarnation_300")
			if ability:GetLevel() == 1 then
				local cd = hero:FindModifierByName("modifier_special_bonus_reincarnation"):GetRemainingTime()
				print(cd)
				if cd > 294.8 then
					return
				end
			end
		end
		Timers:CreateTimer(
			0.1,
			function()
				--加个相位效果，防止英雄卡位
				if not hero:HasAbility("keen") and not hero:HasAbility("rebirth") then
					hero:AddNewModifier(hero, nil, "modifier_phased", {duration = 0.1})
				end
			end
		)
	end
end

function TransportGameMode:PlayerChat(keys)
	-- 作者才能用
	local player = _G.players[keys.userid]
	if player.steamid == 179637729 or player.steamid == 111384022 then
		if keys.text == "push" then
			_G.push_time = 10
		end
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
		-- 处决
		if keys.text == "execution" then
			local hero = PlayerResource:GetPlayer(keys.userid - 1):GetAssignedHero()
			local ability = hero:AddAbility("execution")
			ability:SetLevel(1)
			hero.talent_ability = ability
		end
		-- 巨人杀手
		if keys.text == "giant_killer" then
			local hero = PlayerResource:GetPlayer(keys.userid - 1):GetAssignedHero()
			local ability = hero:AddAbility("giant_killer")
			ability:SetLevel(1)
			hero.talent_ability = ability
		end
		-- 野性光环
		if keys.text == "feral_aura" then
			local hero = PlayerResource:GetPlayer(keys.userid - 1):GetAssignedHero()
			local ability = hero:AddAbility("feral_aura")
			ability:SetLevel(1)
			hero.talent_ability = ability
		end
		-- 召唤丧尸
		if keys.text == "summon_zombie" then
			local hero = PlayerResource:GetPlayer(keys.userid - 1):GetAssignedHero()
			local ability = hero:AddAbility("summon_zombie")
			ability:SetLevel(1)
			hero.talent_ability = ability
		end
		-- 侍奉
		if keys.text == "serve" then
			local hero = PlayerResource:GetPlayer(keys.userid - 1):GetAssignedHero()
			local ability = hero:AddAbility("serve")
			ability:SetLevel(1)
			hero.talent_ability = ability
		end
		-- 迷雾
		if keys.text == "mist" then
			local hero = PlayerResource:GetPlayer(keys.userid - 1):GetAssignedHero()
			local ability = hero:AddAbility("mist")
			ability:SetLevel(1)
			hero.talent_ability = ability
		end
		-- 孤立无援
		if keys.text == "isolated" then
			local hero = PlayerResource:GetPlayer(keys.userid - 1):GetAssignedHero()
			local ability = hero:AddAbility("isolated")
			ability:SetLevel(1)
			hero.talent_ability = ability
		end
		-- 锻造
		if keys.text == "hammering" then
			local hero = PlayerResource:GetPlayer(keys.userid - 1):GetAssignedHero()
			local ability = hero:AddAbility("hammering")
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
				if #abilities == 5 then
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

		--特效测试
		if
			keys.text == "author_effect" or keys.text == "desert_sands" or keys.text == "frost" or keys.text == "cave_crystal" or
				keys.text == "darkmoon" or
				keys.text == "void_mist" or
				keys.text == "golden_fire" or
				keys.text == "blue_fire" or
				keys.text == "green_fire" or
				keys.text == "red_fire" or
				keys.text == "bee_flying" or
				keys.text == "christmas" or
				keys.text == "pink_memories" or
				keys.text == "star_magic"
		 then
			local hero = PlayerResource:GetPlayer(player.playerid):GetAssignedHero()
			if hero.effect_modifier ~= nil then
				hero:RemoveModifierByName(hero.effect_modifier:GetName())
			end
			local modifier = hero:AddNewModifier(hero, nil, keys.text, {duration = -1})
			hero.effect_modifier = modifier
		end
	end
end

-- 伤害过滤器
function TransportGameMode:DamageFilter(damageTable)
	if not damageTable.entindex_attacker_const then
		return true
	end
	if not damageTable.entindex_victim_const then
		return true
	end

	local attacker = EntIndexToHScript(damageTable.entindex_attacker_const)
	local victim = EntIndexToHScript(damageTable.entindex_victim_const)

	--处理处决技能
	if attacker:HasAbility("execution") and attacker:HasModifier("modifier_execution") and victim:IsRealHero() then
		--自己打自己不触发
		if attacker:GetOwnerEntity() == victim:GetOwnerEntity() then
			return true
		end
		--还在cd不触发
		if attacker:HasModifier("modifier_execution_cd") then
			return true
		end
		local ability = attacker:FindAbilityByName("execution")
		local hp_percent = ability:GetSpecialValueFor("hp_percent")
		--判断造成伤害后的血量
		local hp = victim:GetHealth() - damageTable.damage
		local percent = hp * 100 / victim:GetMaxHealth()
		--小于等于处决血量百分比
		if percent <= hp_percent then
			ability:ApplyDataDrivenModifier(attacker, victim, "modifier_execution_apply", {duration = 0.1})
		end
	end

	--处理巨人杀手技能
	if attacker:HasAbility("giant_killer") and attacker:HasModifier("modifier_giant_killer") then
		local ability = attacker:FindAbilityByName("giant_killer")
		local hp_difference = ability:GetSpecialValueFor("hp_difference")
		--计算差值提供的百分比伤害提升
		local victim_hp = victim:GetMaxHealth()
		local attacker_hp = attacker:GetMaxHealth()
		local diff = victim_hp - attacker_hp
		if diff > 0 then
			local percent = math.ceil(diff / hp_difference) / 100
			PopupDamage(victim, math.ceil(percent * damageTable.damage))
			damageTable.damage = damageTable.damage * (1 + percent)
		end
	end

	--处理格挡大师技能
	if victim:HasAbility("block_master") and victim:HasModifier("modifier_block_master") then
		local ability = victim:FindAbilityByName("block_master")
		--如果没cd
		if not victim:HasModifier("modifier_block_master_cd") then
			--计算剩余触发伤害
			ability.trigger_damage = ability.trigger_damage - damageTable.damage
			--触发伤害小于等于0
			if ability.trigger_damage <= 0 then
				--给攻击者反弹格挡伤害
				local block_damage =
					(ability:GetSpecialValueFor("base_block_damage") +
					ability:GetSpecialValueFor("lvl_block_damage") * victim:GetLevel()) *
					ability:GetSpecialValueFor("damage_times")
				local damage_table = {
					victim = attacker,
					attacker = victim,
					damage = block_damage,
					damage_type = DAMAGE_TYPE_PURE,
					ability = ability
				}
				ApplyDamage(damage_table)
				local amp = victim:GetSpellAmplification(false)
				PopupDamage(attacker, math.ceil((1 + amp) * block_damage))
				--去掉格挡buff
				victim:RemoveModifierByName("modifier_block_master_block_damage")
				--反击特效
				local particle_return_fx =
					ParticleManager:CreateParticle(
					"particles/units/heroes/hero_centaur/centaur_return.vpcf",
					PATTACH_ABSORIGIN,
					victim
				)
				ParticleManager:SetParticleControlEnt(
					particle_return_fx,
					0,
					victim,
					PATTACH_POINT_FOLLOW,
					"attach_hitloc",
					victim:GetAbsOrigin(),
					true
				)
				ParticleManager:SetParticleControlEnt(
					particle_return_fx,
					1,
					attacker,
					PATTACH_POINT_FOLLOW,
					"attach_hitloc",
					attacker:GetAbsOrigin(),
					true
				)
				ParticleManager:ReleaseParticleIndex(particle_return_fx)
				--技能进入cd，cd好了以后，如果技能还在，加格挡buff
				local cd = ability:GetCooldown(ability:GetLevel() - 1)
				ability:ApplyDataDrivenModifier(victim, victim, "modifier_block_master_cd", {duration = cd})
				ability:StartCooldown(cd)
			end
		end
	end

	--处理孤立无援技能
	if attacker:HasAbility("isolated") and attacker:HasModifier("modifier_isolated") then
		local ability = attacker:FindAbilityByName("isolated")
		local heroes =
			FindUnitsInRadius(
			attacker:GetTeamNumber(),
			victim:GetAbsOrigin(),
			victim,
			ability:GetSpecialValueFor("radius"),
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO,
			0,
			0,
			false
		)
		--触发孤立无援
		if #heroes == 1 then
			local base_damage_percent = ability:GetSpecialValueFor("base_damage_percent")
			local lvl_damage_percent = ability:GetSpecialValueFor("lvl_damage_percent")
			local total_damage_percent = (base_damage_percent + lvl_damage_percent * attacker:GetLevel()) / 100
			damageTable.damage = math.ceil(damageTable.damage * (1 + total_damage_percent))
			PopupDamage(victim, math.ceil(damageTable.damage * total_damage_percent))
			local particle =
				ParticleManager:CreateParticle(
				"particles/units/heroes/hero_sven/sven_storm_bolt_projectile_explosion_trail.vpcf",
				PATTACH_ABSORIGIN,
				victim
			)
			ParticleManager:SetParticleControl(particle, 3, victim:GetAbsOrigin())

			ParticleManager:ReleaseParticleIndex(particle)
		end
	end

	return true
end

-- 金币过滤器
function TransportGameMode:GoldFilter(keys)
	-- 扣钱不算
	if keys.gold <= 0 then
		return false
	end

	if keys.reason_const == DOTA_ModifyGold_NeutralKill then
		keys.gold = keys.gold * 3
		return true
	end

	return true
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
