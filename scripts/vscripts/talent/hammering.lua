function init_data(keys)
    local ability = keys.ability
    local all_items = {
        "item_branches",
        "item_gauntlets",
        "item_slippers",
        "item_mantle",
        "item_circlet",
        "item_belt_of_strength",
        "item_boots_of_elves",
        "item_robe",
        "item_crown",
        "item_ogre_axe",
        "item_blade_of_alacrity",
        "item_staff_of_wizardry",
        "item_ring_of_protection",
        "item_stout_shield",
        "item_quelling_blade",
        "item_infused_raindrop",
        "item_orb_of_venom",
        "item_blight_stone",
        "item_blades_of_attack",
        "item_chainmail",
        "item_quarterstaff",
        "item_helm_of_iron_will",
        "item_broadsword",
        "item_javelin",
        "item_claymore",
        "item_mithril_hammer",
        "item_magic_stick",
        "item_wind_lace",
        "item_ring_of_regen",
        "item_sobi_mask",
        "item_boots",
        "item_gloves",
        "item_cloak",
        "item_ring_of_tarrasque",
        "item_gem",
        "item_lifesteal",
        "item_shadow_amulet",
        "item_ghost",
        "item_blink",
        "item_magic_wand",
        "item_null_talisman",
        "item_wraith_band",
        "item_bracer",
        "item_soul_ring",
        "item_power_treads",
        "item_phase_boots",
        "item_oblivion_staff",
        "item_pers",
        "item_mask_of_madness",
        "item_helm_of_the_dominator",
        "item_hand_of_midas",
        "item_travel_boots",
        "item_moon_shard",
        "item_ring_of_basilius",
        "item_headdress",
        "item_buckler",
        "item_urn_of_shadows",
        "item_tranquil_boots",
        "item_medallion_of_courage",
        "item_arcane_boots",
        "item_ancient_janggo",
        "item_vladmir",
        "item_mekansm",
        "item_holy_locket",
        "item_spirit_vessel",
        "item_pipe",
        "item_guardian_greaves",
        "item_glimmer_cape",
        "item_veil_of_discord",
        "item_force_staff",
        "item_aether_lens",
        "item_necronomicon",
        "item_dagon",
        "item_cyclone",
        "item_rod_of_atos",
        "item_solar_crest",
        "item_orchid",
        "item_ultimate_scepter",
        "item_nullifier",
        "item_refresher",
        "item_sheepstick",
        "item_octarine_core",
        "item_hood_of_defiance",
        "item_vanguard",
        "item_blade_mail",
        "item_soul_booster",
        "item_aeon_disk",
        "item_crimson_guard",
        "item_lotus_orb",
        "item_black_king_bar",
        "item_hurricane_pike",
        "item_shivas_guard",
        "item_manta",
        "item_bloodstone",
        "item_sphere",
        "item_heart",
        "item_assault",
        "item_lesser_crit",
        "item_armlet",
        "item_meteor_hammer",
        "item_invis_sword",
        "item_basher",
        "item_monkey_king_bar",
        "item_bfury",
        "item_ethereal_blade",
        "item_radiance",
        "item_greater_crit",
        "item_butterfly",
        "item_silver_edge",
        "item_rapier",
        "item_abyssal_blade",
        "item_bloodthorn",
        "item_dragon_lance",
        "item_sange",
        "item_yasha",
        "item_kaya",
        "item_echo_sabre",
        "item_maelstrom",
        "item_diffusal_blade",
        "item_heavens_halberd",
        "item_desolator",
        "item_kaya_and_sange",
        "item_sange_and_yasha",
        "item_yasha_and_kaya",
        "item_satanic",
        "item_skadi",
        "item_mjollnir",
        "item_ring_of_health",
        "item_void_stone",
        "item_energy_booster",
        "item_vitality_booster",
        "item_point_booster",
        "item_platemail",
        "item_talisman_of_evasion",
        "item_hyperstone",
        "item_ultimate_orb",
        "item_demon_edge",
        "item_mystic_staff",
        "item_reaver",
        "item_eagle",
        "item_relic"
    }
    local lv_gold_1 = ability:GetSpecialValueFor("lv_gold_1")
    local lv_gold_2 = ability:GetSpecialValueFor("lv_gold_2")
    local lv_gold_3 = ability:GetSpecialValueFor("lv_gold_3")
    ability.items_1 = {}
    ability.items_2 = {}
    ability.items_3 = {}
    ability.items_4 = {}
    for _, item in ipairs(all_items) do
        local cost = GetItemCost(item)
        if cost < lv_gold_1 then
            table.insert(ability.items_1, item)
        elseif cost >= lv_gold_1 and cost < lv_gold_2 then
            table.insert(ability.items_2, item)
        elseif cost >= lv_gold_2 and cost < lv_gold_3 then
            table.insert(ability.items_3, item)
        elseif cost >= lv_gold_3 then
            table.insert(ability.items_4, item)
        end
    end
end

function hammering(keys)
    local caster = keys.caster
    local ability = keys.ability
    if caster:HasModifier("modifier_hammering") then
        local lvl = caster:GetLevel()
        local lvl_1 = ability:GetSpecialValueFor("lvl_1")
        local lvl_2 = ability:GetSpecialValueFor("lvl_2")
        local lvl_3 = ability:GetSpecialValueFor("lvl_3")
        if lvl < lvl_1 then
            caster:AddItemByName(ability.items_1[RandomInt(1, Utils:count_nums(ability.items_1))])
        elseif lvl >= lvl_1 and lvl < lvl_2 then
            caster:AddItemByName(ability.items_2[RandomInt(1, Utils:count_nums(ability.items_2))])
        elseif lvl >= lvl_2 and lvl < lvl_3 then
            caster:AddItemByName(ability.items_3[RandomInt(1, Utils:count_nums(ability.items_3))])
        elseif lvl >= lvl_3 then
            caster:AddItemByName(ability.items_4[RandomInt(1, Utils:count_nums(ability.items_4))])
        end
        if caster:HasModifier("modifier_hammering_cd") then
            caster:RemoveModifierByName("modifier_hammering_cd")
        end
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_hammering_cd", {})
        caster:EmitSound("ui.treasure_03")
        local caster_location = caster:GetOrigin()
        local particle =
            ParticleManager:CreateParticle("particles/ui/ui_generic_treasure_impact.vpcf", PATTACH_CUSTOMORIGIN, caster)
        ParticleManager:SetParticleControlEnt(
            particle,
            0,
            caster,
            PATTACH_POINT_FOLLOW,
            "attach_hitloc",
            caster_location,
            true
        )
        ParticleManager:SetParticleControlEnt(
            particle,
            1,
            caster,
            PATTACH_POINT_FOLLOW,
            "attach_hitloc",
            caster_location,
            true
        )
        ParticleManager:ReleaseParticleIndex(particle)
    end
end
