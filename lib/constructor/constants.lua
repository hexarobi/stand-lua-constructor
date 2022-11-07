-- Constructor Constants

local SCRIPT_VERSION = "0.26b2"
local constants = {}

constants.particle_fxs = {
    {
        name="Fire",
        type="PARTICLE",
        particle_attributes={
            asset="core",
            effect_name="fire_wrecked_plane_cockpit",
        }
    },
    {
        name="Smoke",
        type="PARTICLE",
        particle_attributes={
            asset="scr_as_trans",
            effect_name="scr_as_trans_smoke",
            color = {
                r=100,
                g=100,
                b=100,
                a=100,
            }
        }
    },
    {
        name="Clown Appears",
        type="PARTICLE",
        particle_attributes={
            asset="scr_rcbarry2",
            effect_name="scr_clown_appears",
            scale=0.3,
            loop_timer=500,
        }
    },
    {
        name="Alien Impact",
        type="PARTICLE",
        particle_attributes={
            asset="scr_rcbarry1",
            effect_name="scr_alien_impact_bul",
            scale=1,
            loop_timer=50,
        },
    },
    {
        name="Blue Sparks",
        type="PARTICLE",
        particle_attributes={
            asset="core",
            effect_name="ent_dst_elec_fire_sp",
            scale=1,
            loop_timer=100,

        }
    },
    {
        name="Alien Disintegration",
        type="PARTICLE",
        particle_attributes={
            asset="scr_rcbarry1",
            effect_name="scr_alien_disintegrate",
            scale=0.1,
            loop_timer=400,

        }
    },
    {
        name="Firey Particles",
        type="PARTICLE",
        particle_attributes={
            asset="scr_rcbarry1",
            effect_name="scr_alien_teleport",
            scale=0.1,
            loop_timer=400,
        }
    },
    {
        name="Fireworks Burst",
        type="PARTICLE",
        particle_attributes={
            asset="scr_indep_fireworks",
            effect_name="scr_indep_firework_shotburst",
        }
    },
    {
        name="Flare Smoke Trail",
        type="PARTICLE",
        particle_attributes={
            asset="wpn_flare",
            effect_name="proj_heist_flare_trail",
        }
    },
    {
        name="Flamethrower Loop",
        type="PARTICLE",
        particle_attributes={
            asset="weap_xs_vehicle_weapons",
            effect_name="muz_xs_turret_flamethrower_looping",
        }
    },
    {
        name="muz_xs_turret_flamethrower_looping_sf",
        type="PARTICLE",
        particle_attributes={
            asset="weap_xs_vehicle_weapons",
            effect_name="muz_xs_turret_flamethrower_looping_sf",
        }
    },
    {
        name="Turbulent Water",
        type="PARTICLE",
        particle_attributes={
            asset="weap_sm_tula",
            effect_name="veh_tula_turbulance_water",
        }
    },
    {
        name="Railgun Charge",
        type="PARTICLE",
        particle_attributes={
            asset="veh_khanjali",
            effect_name="muz_xm_khanjali_railgun_charge",
        }
    },
    {
        name="Oil Jack Fire",
        type="PARTICLE",
        particle_attributes={
            asset="scr_xs_props",
            effect_name="scr_xs_oil_jack_fire",
        }
    },
    {
        name="scr_xs_sf_pit",
        type="PARTICLE",
        particle_attributes={
            asset="scr_xs_pits",
            effect_name="scr_xs_sf_pit",
        }
    },
    {
        name="Small Fire Pit",
        type="PARTICLE",
        particle_attributes={
            asset="scr_xs_pits",
            effect_name="scr_xs_fire_pit",
        }
    },
    {
        name="Large Fire Pit",
        type="PARTICLE",
        particle_attributes={
            asset="scr_xs_pits",
            effect_name="scr_xs_fire_pit_long",
        }
    },
    {
        name="Electric Pit",
        type="PARTICLE",
        particle_attributes={
            asset="scr_xs_pits",
            effect_name="scr_xs_sf_pit_long",
        }
    },
    {
        name="Money Rain",
        type="PARTICLE",
        particle_attributes={
            asset="xcr_xs_celebration",
            effect_name="scr_xs_money_rain",
        }
    },
    {
        name="Money Rain Celebration",
        type="PARTICLE",
        particle_attributes={
            asset="xcr_xs_celebration",
            effect_name="scr_xs_money_rain_celeb",
        }
    },
    {
        name="Champagne Spray",
        type="PARTICLE",
        particle_attributes={
            asset="xcr_xs_celebration",
            effect_name="scr_xs_champagne_spray",
        }
    },
    {
        name="Stromberg Scanner",
        type="PARTICLE",
        particle_attributes={
            asset="xcr_xm_submarine",
            effect_name="scr_xm_stromberg_scanner",
        }
    },
    {
        name="Plane Smoke Trail",
        type="PARTICLE",
        particle_attributes={
            asset="xcr_xm_spybomb",
            effect_name="scr_xm_spybomb_plane_smoke_trail",
        }
    },
    {
        name="Package Flare",
        type="PARTICLE",
        particle_attributes={
            asset="scr_xm_ht",
            effect_name="scr_xm_ht_package_flare",
        }
    },
    {
        name="Electric Crackle",
        type="PARTICLE",
        particle_attributes={
            asset="scr_xm_farm",
            effect_name="scr_xm_dst_elec_cracke",
        }
    },
    {
        name="Heat Camo",
        type="PARTICLE",
        particle_attributes={
            asset="scr_xm_heat",
            effect_name="scr_xm_heat_camo",
        }
    },
    {
        name="Final Kill Thruster",
        type="PARTICLE",
        particle_attributes={
            asset="scr_xm_aq",
            effect_name="scr_xm_aq_final_kill_thruster",
        }
    },
    {
        name="Weapon Highlight",
        type="PARTICLE",
        particle_attributes={
            asset="scr_sr_adversary",
            effect_name="scr_sr_lg_weapon_highlight",
        }
    },
    {
        name="Recrash Rescue",
        type="PARTICLE",
        particle_attributes={
            asset="scr_recrash_rescue",
            effect_name="scr_recrash_rescue",
        }
    },
    {
        name="Sparking Generator",
        type="PARTICLE",
        particle_attributes={
            asset="scr_reconstructionaccident",
            effect_name="scr_sparking_generator",
        }
    },
    {
        name="Debris Trail",
        type="PARTICLE",
        particle_attributes={
            asset="scr_rcnigel2",
            effect_name="scr_rcn2_debris_trail",
        }
    },
    {
        name="Alien Charging",
        type="PARTICLE",
        particle_attributes={
            asset="scr_rcbarry1",
            effect_name="scr_alien_charging",
        }
    },
    {
        name="Alien Impact",
        type="PARTICLE",
        particle_attributes={
            asset="scr_rcbarry1",
            effect_name="scr_alien_impact",
        }
    },
    {
        name="Fog Volume",
        type="PARTICLE",
        particle_attributes={
            asset="scr_jewelheist",
            effect_name="scr_jewel_fog_volume",
        }
    },
    {
        name="Car Wash Jet",
        type="PARTICLE",
        particle_attributes={
            asset="scr_carwash",
            effect_name="ent_amb_car_wash_jet",
        }
    },
    {
        name="Sauna Steam",
        type="PARTICLE",
        particle_attributes={
            asset="cut_amb_tv",
            effect_name="cs_amb_tv_sauna_steam",
        }
    },
    {
        name="Heli Wreck Fire",
        type="PARTICLE",
        particle_attributes={
            asset="scr_trevor2",
            effect_name="scr_trev2_heli_wreck",
        }
    },
    {
        name="Fire Ring",
        type="PARTICLE",
        particle_attributes={
            asset="scr_stunts",
            effect_name="scr_stunts_fire_ring",
        }
    },
}

constants.ped_props = {
    {index=0, name="Hats"},
    {index=1, name="Glasses"},
    {index=2, name="Earrings"},
    {index=6, name="Watch"},
    {index=7, name="Bracelet"},
}

constants.ped_components = {
    {index=1, name="Mask"},
    {index=2, name="Hair"},
    {index=8, name="Shirt"},
    {index=11, name="Jacket"},
    {index=4, name="Pants"},
    {index=6, name="Shoes"},
    {index=7, name="Necktie"},
    {index=3, name="Gloves"},
    {index=5, name="Parachute / Bag"},
    {index=9, name="Body Armor"},
    {index=10, name="Decals"},
}

constants.tire_position_names = {
    { name="Front Left", index=0 },
    { name="Front Right", index=1 },
    { name="Mid Left", index=2 },
    { name="Mid Right", index=3 },
    { name="Rear Left", index=4 },
    { name="Rear Right", index=5 },
    { name="6 Wheeler Left", index=45 },
    { name="6 Wheeler Right", index=47 },
}

constants.door_lock_status = {
    "None",
    "Unlocked",
    "Locked",
    "Lockout Player Only",
    "Locked Player Inside",
    "Locked Initially",
    "Force Shut Doors",
    "Locked by can be damaged",
    "Locked but trunk unlocked",
    "Locked, no passengers",
    "Cannot enter",
}

constants.bone_index_names = {
    {
        name="Ped",
        bone_names={
            "SKEL_ROOT",
            "SKEL_Pelvis",
            "SKEL_L_Thigh",
            "SKEL_L_Calf",
            "SKEL_L_Foot",
            "SKEL_L_Toe0",
            "IK_L_Foot",
            "PH_L_Foot",
            "MH_L_Knee",
            "SKEL_R_Thigh",
            "SKEL_R_Calf",
            "SKEL_R_Foot",
            "SKEL_R_Toe0",
            "IK_R_Foot",
            "PH_R_Foot",
            "MH_R_Knee",
            "RB_L_ThighRoll",
            "RB_R_ThighRoll",
            "SKEL_Spine_Root",
            "SKEL_Spine0",
            "SKEL_Spine1",
            "SKEL_Spine2",
            "SKEL_Spine3",
            "SKEL_L_Clavicle",
            "SKEL_L_UpperArm",
            "SKEL_L_Forearm",
            "SKEL_L_Hand",
            "SKEL_L_Finger00",
            "SKEL_L_Finger01",
            "SKEL_L_Finger02",
            "SKEL_L_Finger10",
            "SKEL_L_Finger11",
            "SKEL_L_Finger12",
            "SKEL_L_Finger20",
            "SKEL_L_Finger21",
            "SKEL_L_Finger22",
            "SKEL_L_Finger30",
            "SKEL_L_Finger31",
            "SKEL_L_Finger32",
            "SKEL_L_Finger40",
            "SKEL_L_Finger41",
            "SKEL_L_Finger42",
            "PH_L_Hand",
            "IK_L_Hand",
            "RB_L_ForeArmRoll",
            "RB_L_ArmRoll",
            "MH_L_Elbow",
            "SKEL_R_Clavicle",
            "SKEL_R_UpperArm",
            "SKEL_R_Forearm",
            "SKEL_R_Hand",
            "SKEL_R_Finger00",
            "SKEL_R_Finger01",
            "SKEL_R_Finger02",
            "SKEL_R_Finger10",
            "SKEL_R_Finger11",
            "SKEL_R_Finger12",
            "SKEL_R_Finger20",
            "SKEL_R_Finger21",
            "SKEL_R_Finger22",
            "SKEL_R_Finger30",
            "SKEL_R_Finger31",
            "SKEL_R_Finger32",
            "SKEL_R_Finger40",
            "SKEL_R_Finger41",
            "SKEL_R_Finger42",
            "PH_R_Hand",
            "IK_R_Hand",
            "RB_R_ForeArmRoll",
            "RB_R_ArmRoll",
            "MH_R_Elbow",
            "SKEL_Neck_1",
            "SKEL_Head",
            "IK_Head",
            "FACIAL_facialRoot",
            "FB_L_Brow_Out_000",
            "FB_L_Lid_Upper_000",
            "FB_L_Eye_000",
            "FB_L_CheekBone_000",
            "FB_L_Lip_Corner_000",
            "FB_R_Lid_Upper_000",
            "FB_R_Eye_000",
            "FB_R_CheekBone_000",
            "FB_R_Brow_Out_000",
            "FB_R_Lip_Corner_000",
            "FB_Brow_Centre_000",
            "FB_UpperLipRoot_000",
            "FB_UpperLip_000",
            "FB_L_Lip_Top_000",
            "FB_R_Lip_Top_000",
            "FB_Jaw_000",
            "FB_LowerLipRoot_000",
            "FB_LowerLip_000",
            "FB_L_Lip_Bot_000",
            "FB_R_Lip_Bot_000",
            "FB_Tongue_000",
            "RB_Neck_1",
            "IK_Root",
        }
    },
    {
        name="Vehicle",
        bone_names={
            "chassis",
            "chassis_lowlod",
            "chassis_dummy",
            "seat_dside_f",
            "seat_dside_r",
            "seat_dside_r1",
            "seat_dside_r2",
            "seat_dside_r3",
            "seat_dside_r4",
            "seat_dside_r5",
            "seat_dside_r6",
            "seat_dside_r7",
            "seat_pside_f",
            "seat_pside_r",
            "seat_pside_r1",
            "seat_pside_r2",
            "seat_pside_r3",
            "seat_pside_r4",
            "seat_pside_r5",
            "seat_pside_r6",
            "seat_pside_r7",
            "window_lf1",
            "window_lf2",
            "window_lf3",
            "window_rf1",
            "window_rf2",
            "window_rf3",
            "window_lr1",
            "window_lr2",
            "window_lr3",
            "window_rr1",
            "window_rr2",
            "window_rr3",
            "door_dside_f",
            "door_dside_r",
            "door_pside_f",
            "door_pside_r",
            "handle_dside_f",
            "handle_dside_r",
            "handle_pside_f",
            "handle_pside_r",
            "wheel_lf",
            "wheel_rf",
            "wheel_lm1",
            "wheel_rm1",
            "wheel_lm2",
            "wheel_rm2",
            "wheel_lm3",
            "wheel_rm3",
            "wheel_lr",
            "wheel_rr",
            "suspension_lf",
            "suspension_rf",
            "suspension_lm",
            "suspension_rm",
            "suspension_lr",
            "suspension_rr",
            "spring_rf",
            "spring_lf",
            "spring_rr",
            "spring_lr",
            "transmission_f",
            "transmission_m",
            "transmission_r",
            "hub_lf",
            "hub_rf",
            "hub_lm1",
            "hub_rm1",
            "hub_lm2",
            "hub_rm2",
            "hub_lm3",
            "hub_rm3",
            "hub_lr",
            "hub_rr",
            "windscreen",
            "windscreen_r",
            "window_lf",
            "window_rf",
            "window_lr",
            "window_rr",
            "window_lm",
            "window_rm",
            "bodyshell",
            "bumper_f",
            "bumper_r",
            "wing_rf",
            "wing_lf",
            "bonnet",
            "boot",
            "exhaust",
            "exhaust_2",
            "exhaust_3",
            "exhaust_4",
            "exhaust_5",
            "exhaust_6",
            "exhaust_7",
            "exhaust_8",
            "exhaust_9",
            "exhaust_10",
            "exhaust_11",
            "exhaust_12",
            "exhaust_13",
            "exhaust_14",
            "exhaust_15",
            "exhaust_16",
            "engine",
            "overheat",
            "overheat_2",
            "petrolcap",
            "petroltank",
            "petroltank_l",
            "petroltank_r",
            "steering",
            "hbgrip_l",
            "hbgrip_r",
            "headlight_l",
            "headlight_r",
            "taillight_l",
            "taillight_r",
            "indicator_lf",
            "indicator_rf",
            "indicator_lr",
            "indicator_rr",
            "brakelight_l",
            "brakelight_r",
            "brakelight_m",
            "reversinglight_l",
            "reversinglight_r",
            "extralight_1",
            "extralight_2",
            "extralight_3",
            "extralight_4",
            "numberplate",
            "interiorlight",
            "siren1",
            "siren2",
            "siren3",
            "siren4",
            "siren5",
            "siren6",
            "siren7",
            "siren8",
            "siren9",
            "siren10",
            "siren11",
            "siren12",
            "siren13",
            "siren14",
            "siren15",
            "siren16",
            "siren17",
            "siren18",
            "siren19",
            "siren20",
            "siren_glass1",
            "siren_glass2",
            "siren_glass3",
            "siren_glass4",
            "siren_glass5",
            "siren_glass6",
            "siren_glass7",
            "siren_glass8",
            "siren_glass9",
            "siren_glass10",
            "siren_glass11",
            "siren_glass12",
            "siren_glass13",
            "siren_glass14",
            "siren_glass15",
            "siren_glass16",
            "siren_glass17",
            "siren_glass18",
            "siren_glass19",
            "siren_glass20",
            "spoiler",
            "struts",
            "misc_a",
            "misc_b",
            "misc_c",
            "misc_d",
            "misc_e",
            "misc_f",
            "misc_g",
            "misc_h",
            "misc_i",
            "misc_j",
            "misc_k",
            "misc_l",
            "misc_m",
            "misc_n",
            "misc_o",
            "misc_p",
            "misc_q",
            "misc_r",
            "misc_s",
            "misc_t",
            "misc_u",
            "misc_v",
            "misc_w",
            "misc_x",
            "misc_y",
            "misc_z",
            "misc_1",
            "misc_2",
            "weapon_1a",
            "weapon_1b",
            "weapon_1c",
            "weapon_1d",
            "weapon_1a_rot",
            "weapon_1b_rot",
            "weapon_1c_rot",
            "weapon_1d_rot",
            "weapon_2a",
            "weapon_2b",
            "weapon_2c",
            "weapon_2d",
            "weapon_2a_rot",
            "weapon_2b_rot",
            "weapon_2c_rot",
            "weapon_2d_rot",
            "weapon_3a",
            "weapon_3b",
            "weapon_3c",
            "weapon_3d",
            "weapon_3a_rot",
            "weapon_3b_rot",
            "weapon_3c_rot",
            "weapon_3d_rot",
            "weapon_4a",
            "weapon_4b",
            "weapon_4c",
            "weapon_4d",
            "weapon_4a_rot",
            "weapon_4b_rot",
            "weapon_4c_rot",
            "weapon_4d_rot",
            "turret_1base",
            "turret_1barrel",
            "turret_2base",
            "turret_2barrel",
            "turret_3base",
            "turret_3barrel",
            "ammobelt",
            "searchlight_base",
            "searchlight_light",
            "attach_female",
            "roof",
            "roof2",
            "soft_1",
            "soft_2",
            "soft_3",
            "soft_4",
            "soft_5",
            "soft_6",
            "soft_7",
            "soft_8",
            "soft_9",
            "soft_10",
            "soft_11",
            "soft_12",
            "soft_13",
            "forks",
            "mast",
            "carriage",
            "fork_l",
            "fork_r",
            "forks_attach",
            "frame_1",
            "frame_2",
            "frame_3",
            "frame_pickup_1",
            "frame_pickup_2",
            "frame_pickup_3",
            "frame_pickup_4",
            "freight_cont",
            "freight_bogey",
            "freightgrain_slidedoor",
            "door_hatch_r",
            "door_hatch_l",
            "tow_arm",
            "tow_mount_a",
            "tow_mount_b",
            "tipper",
            "combine_reel",
            "combine_auger",
            "slipstream_l",
            "slipstream_r",
            "arm_1",
            "arm_2",
            "arm_3",
            "arm_4",
            "scoop",
            "boom",
            "stick",
            "bucket",
            "shovel_2",
            "shovel_3",
            "Lookat_UpprPiston_head",
            "Lookat_LowrPiston_boom",
            "Boom_Driver",
            "cutter_driver",
            "vehicle_blocker",
            "extra_1",
            "extra_2",
            "extra_3",
            "extra_4",
            "extra_5",
            "extra_6",
            "extra_7",
            "extra_8",
            "extra_9",
            "extra_ten",
            "extra_11",
            "extra_12",
            "break_extra_1",
            "break_extra_2",
            "break_extra_3",
            "break_extra_4",
            "break_extra_5",
            "break_extra_6",
            "break_extra_7",
            "break_extra_8",
            "break_extra_9",
            "break_extra_10",
            "mod_col_1",
            "mod_col_2",
            "mod_col_3",
            "mod_col_4",
            "mod_col_5",
            "handlebars",
            "forks_u",
            "forks_l",
            "wheel_f",
            "swingarm",
            "wheel_r",
            "crank",
            "pedal_r",
            "pedal_l",
            "static_prop",
            "moving_prop",
            "static_prop2",
            "moving_prop2",
            "rudder",
            "rudder2",
            "wheel_rf1_dummy",
            "wheel_rf2_dummy",
            "wheel_rf3_dummy",
            "wheel_rb1_dummy",
            "wheel_rb2_dummy",
            "wheel_rb3_dummy",
            "wheel_lf1_dummy",
            "wheel_lf2_dummy",
            "wheel_lf3_dummy",
            "wheel_lb1_dummy",
            "wheel_lb2_dummy",
            "wheel_lb3_dummy",
            "bogie_front",
            "bogie_rear",
            "rotor_main",
            "rotor_rear",
            "rotor_main_2",
            "rotor_rear_2",
            "elevators",
            "tail",
            "outriggers_l",
            "outriggers_r",
            "rope_attach_a",
            "rope_attach_b",
            "prop_1",
            "prop_2",
            "elevator_l",
            "elevator_r",
            "rudder_l",
            "rudder_r",
            "prop_3",
            "prop_4",
            "prop_5",
            "prop_6",
            "prop_7",
            "prop_8",
            "rudder_2",
            "aileron_l",
            "aileron_r",
            "airbrake_l",
            "airbrake_r",
            "wing_l",
            "wing_r",
            "wing_lr",
            "wing_rr",
            "engine_l",
            "engine_r",
            "nozzles_f",
            "nozzles_r",
            "afterburner",
            "wingtip_1",
            "wingtip_2",
            "gear_door_fl",
            "gear_door_fr",
            "gear_door_rl1",
            "gear_door_rr1",
            "gear_door_rl2",
            "gear_door_rr2",
            "gear_door_rml",
            "gear_door_rmr",
            "gear_f",
            "gear_rl",
            "gear_lm1",
            "gear_rr",
            "gear_rm1",
            "gear_rm",
            "prop_left",
            "prop_right",
            "legs",
            "attach_male",
            "draft_animal_attach_lr",
            "draft_animal_attach_rr",
            "draft_animal_attach_lm",
            "draft_animal_attach_rm",
            "draft_animal_attach_lf",
            "draft_animal_attach_rf",
            "wheelcover_l",
            "wheelcover_r",
            "barracks",
            "pontoon_l",
            "pontoon_r",
            "no_ped_col_step_l",
            "no_ped_col_strut_1_l",
            "no_ped_col_strut_2_l",
            "no_ped_col_step_r",
            "no_ped_col_strut_1_r",
            "no_ped_col_strut_2_r",
            "light_cover",
            "emissives",
            "neon_l",
            "neon_r",
            "neon_f",
            "neon_b",
            "dashglow",
            "doorlight_lf",
            "doorlight_rf",
            "doorlight_lr",
            "doorlight_rr",
            "unknown_id",
            "dials",
            "engineblock",
            "bobble_head",
            "bobble_base",
            "bobble_hand",
            "chassis_Control"
        }
    },
    {
        name = "Weapon",
        bone_names = {
            "gun_root",
            "gun_gripr",
            "gun_gripl",
            "gun_muzzle",
            "gun_vfx_eject",
            "gun_magazine",
            "gun_ammo",
            "gun_vfx_projtrail",
            "gun_barrels",
            "WAPClip",
            "WAPClip_2",
            "WAPScop",
            "WAPScop_2",
            "WAPGrip",
            "WAPGrip_2",
            "WAPSupp",
            "WAPSupp_2",
            "WAPFlsh",
            "WAPFlsh_2",
            "WAPStck",
            "WAPSeWp",
            "WAPLasr",
            "WAPLasr_2",
            "WAPFlshLasr",
            "WAPFlshLasr_2",
            "NM_Butt_Marker",
            "Gun_GripR",
            "Gun_Nuzzle",
            "gun_drum",
        },
    },
}

constants.CONSTRUCTS_INSTALLER_SCRIPT = "-- Curated Constructs Installer\
menu.divider(menu.my_root(), \"Downloading curated constructs.\")\
menu.divider(menu.my_root(), \"When the download is complete, the files\")\
menu.divider(menu.my_root(), \"will be extracted to your Constructs folder.\")\
menu.divider(menu.my_root(), \"This will take a few minutes.\")\
menu.divider(menu.my_root(), \"Please wait...\")\
local status_auto_updater, auto_updater = pcall(require, \"auto-updater\")\
if not status_auto_updater then error(\"Could not load auto-updater\") end\
\
local CONSTRUCTS_DIR = filesystem.stand_dir() .. 'Constructs/'\
local CURATED_CONSTRUCTS_DIR = CONSTRUCTS_DIR..'/Curated'\
filesystem.mkdirs(CURATED_CONSTRUCTS_DIR)\
\
local function download_and_extract_curated_constructs()\
    local ZIP_FILE_STORE_PATH = \"/Constructor/downloads/CuratedConstructs.zip\"\
    local DOWNLOADED_ZIP_FILE_PATH = filesystem.store_dir() .. ZIP_FILE_STORE_PATH\
\
    util.toast(\"Downloading curated constructs...\", TOAST_ALL)\
    auto_updater.run_auto_update({\
        source_url=\"https://codeload.github.com/hexarobi/stand-curated-constructs/zip/refs/heads/main\",\
        script_relpath=\"store\"..ZIP_FILE_STORE_PATH,\
        http_timeout=120000,\
    })\
\
    if not filesystem.exists(DOWNLOADED_ZIP_FILE_PATH) then\
        error(\"Missing downloaded file \"..DOWNLOADED_ZIP_FILE_PATH)\
    end\
    util.toast(\"Successfully downloaded curated constructs \"..DOWNLOADED_ZIP_FILE_PATH, TOAST_ALL)\
\
    util.toast(\"Extracting curated constructs...\", TOAST_ALL)\
    -- I could not find a way to extract a zip using simple lua. Running an OS command requires special user auth, but seems worth it.\
    -- To avoid requiring these permissions, comment out the following line. The only effect will be lack of auto-installing curated constructs.\
    util.i_really_need_manual_access_to_process_apis()\
    local command = 'tar -C \"'..CURATED_CONSTRUCTS_DIR..'\" -xf \"'..DOWNLOADED_ZIP_FILE_PATH..'\" --strip-components=1'\
    util.log(\"Running command: \"..command)\
    if os.execute(command) then\
        util.toast(\"Successfully installed curated constructs!\", TOAST_ALL)\
        util.log(\"Cleaning up zip...\", TOAST_ALL)\
        os.remove(DOWNLOADED_ZIP_FILE_PATH)\
        util.log(\"Cleaning up script...\", TOAST_ALL)\
        os.remove(filesystem.scripts_dir()..SCRIPT_RELPATH)\
        util.log(\"Clean up complete.\", TOAST_ALL)\
        if CONSTRUCTOR_LOAD_CONSTRUCTS_MENU ~= nil then\
            pcall(menu.focus, CONSTRUCTOR_LOAD_CONSTRUCTS_MENU)\
        end\
        menu.trigger_commands(\"constructorloadconstruct\")\
        util.stop_script()\
    else\
        util.toast(\"There was a problem extracting the curated constructs\", TOAST_ALL)\
    end\
end\
\
util.yield(1)\
download_and_extract_curated_constructs()\
"

constants.ped_weapons = {
    {
        name="Pistol",
        is_folder = true,
        items ={
            {
                name="Pistol",
                model="weapon_pistol",
                type="WEAPON",
            },
            {
                name="Pistol (Luxury)",
                model="weapon_pistol",
                component="COMPONENT_PISTOL_VARMOD_LUXE",
                type="WEAPON",
            },
            {
                name="Combat Pistol",
                model="COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER",
                type="WEAPON",
            },
            {
                name="AP Pistol",
                model="COMPONENT_APPISTOL_VARMOD_LUXE",
                type="WEAPON",
            },
            {
                name="Pistol .50",
                model="COMPONENT_PISTOL50_VARMOD_LUXE",
                type="WEAPON",
            },
            {
                name="SNS Pistol",
                model="COMPONENT_SNSPISTOL_VARMOD_LOWRIDER",
                type="WEAPON",
            },
            {
                name="Heavy Pistol",
                model="COMPONENT_HEAVYPISTOL_VARMOD_LUXE",
                type="WEAPON",
            },
            {
                name="SNS Pistol Mk II",
                model="WEAPON_SNSPISTOL_MK2",
                type="WEAPON",
            },
            {
                name="Up-n-Atomizer",
                model="COMPONENT_RAYPISTOL_VARMOD_XMAS18",
                type="WEAPON",
            },
            {
                name="Heavy Revolver Mk II",
                model="WEAPON_REVOLVER_MK2",
                type="WEAPON",
            },
            {
                name="Vintage Pistol",
                model="WEAPON_VINTAGEPISTOL",
                type="WEAPON",
            },
            {
                name="Double-Action Revolver",
                model="WEAPON_DOUBLEACTION",
                type="WEAPON",
            },
            {
                name="Ceramic Pistol",
                model="WEAPON_CERAMICPISTOL",
                type="WEAPON",
            },
            {
                name="Perico Pistol",
                model="WEAPON_GADGETPISTOL",
                type="WEAPON",
            },
            {
                name="Flare Gun",
                model="WEAPON_FLAREGUN",
                type="WEAPON",
            },
            {
                name="Navy Revolver",
                model="WEAPON_NAVYREVOLVER",
                type="WEAPON",
            },
            {
                name="Marksman Pistol",
                model="WEAPON_MARKSMANPISTOL",
                type="WEAPON",
            },
            {
                name="Heavy Revolver",
                model="COMPONENT_REVOLVER_VARMOD_BOSS",
                type="WEAPON",
            },
            {
                name="Pistol Mk II",
                model="WEAPON_PISTOL_MK2",
                type="WEAPON",
            }
        }
    },
    {
        name="Sub Machine Gun",
        is_folder = true,
        items = {
            {
                name="Micro SMG",
                model="COMPONENT_MICROSMG_VARMOD_LUXE",
                type="WEAPON",
            },
            {
                name="SMG",
                model="COMPONENT_SMG_VARMOD_LUXE",
                type="WEAPON",
            },
            {
                name="Assault SMG",
                model="COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER",
                type="WEAPON",
            },
            {
                name="Combat PDW",
                model="WEAPON_COMBATPDW",
                type="WEAPON",
            },
            {
                name="Machine Pistol",
                model="WEAPON_MACHINEPISTOL",
                type="WEAPON",
            },
            {
                name="Mini SMG",
                model="WEAPON_MINISMG",
                type="WEAPON",
            },
            {
                name="SMG Mk II",
                model="WEAPON_SMG_MK2",
                type="WEAPON",
            },
        }
    },
    {
        name="Machine Gun (MG)",
        is_folder = true,
        items ={
            {
                name="MG",
                model="COMPONENT_MG_VARMOD_LOWRIDER",
                type="WEAPON",
            },
            {
                name="Combat MG",
                model="WEAPON_COMBATMG",
                type="WEAPON",
            },
            {
                name="Unholy Hellbringer",
                model="WEAPON_RAYCARBINE",
                type="WEAPON",
            },
            {
                name="Gusenberg Sweeper",
                model="WEAPON_GUSENBERG",
                type="WEAPON",
            },
            {
                name="Combat MG Mk II",
                model="WEAPON_COMBATMG_MK2",
                type="WEAPON",
            },
        }
    },
    {
        name="Rifles",
        is_folder = true,
        items ={
            {
                name="Assault Rifle",
                model="COMPONENT_ASSAULTRIFLE_VARMOD_LUXE",
                type="WEAPON",
            },
            {
                name="Carbine Rifle",
                model="COMPONENT_CARBINERIFLE_VARMOD_LUXE",
                type="WEAPON",
            },
            {
                name="Advanced Rifle",
                model="WEAPON_ADVANCEDRIFLE",
                type="WEAPON",
            },
            {
                name="Bullpup Rifle",
                model="COMPONENT_BULLPUPRIFLE_VARMOD_LOW",
                type="WEAPON",
            },
            {
                name="Special Carbine",
                model="COMPONENT_SPECIALCARBINE_VARMOD_LOWRIDER",
                type="WEAPON",
            },
            {
                name="Special Carbine Mk II",
                model="WEAPON_SPECIALCARBINE_MK2",
                type="WEAPON",
            },
            {
                name="Bullpup Rifle Mk II",
                model="WEAPON_BULLPUPRIFLE_MK2",
                type="WEAPON",
            },
            {
                name="Military Rifle",
                model="WEAPON_MILITARYRIFLE",
                type="WEAPON",
            },
            {
                name="Compact Rifle",
                model="WEAPON_COMPACTRIFLE",
                type="WEAPON",
            },
            {
                name="Carbine Rifle Mk II",
                model="WEAPON_CARBINERIFLE_MK2",
                type="WEAPON",
            },
            {
                name="Assault Rifle Mk II",
                model="WEAPON_ASSAULTRIFLE_MK2",
                type="WEAPON",
            },
            {
                name="Service Carbine",
                model="WEAPON_TACTICALRIFLE",
                type="WEAPON",
            },
            {
                name="Heavy Rifle",
                model="WEAPON_HEAVYRIFLE",
                type="WEAPON",
            },
        }
    },
    {
        name="Sniper",
        is_folder = true,
        items ={
            {
                name="Sniper Rifle",
                model="WEAPON_SNIPERRIFLE",
                type="WEAPON",
            },
            {
                name="Heavy Sniper",
                model="WEAPON_HEAVYSNIPER",
                type="WEAPON",
            },
            {
                name="Marksman Rifle Mk II",
                model="WEAPON_MARKSMANRIFLE_MK2",
                type="WEAPON",
            },
            {
                name="Musket",
                model="WEAPON_MUSKET",
                type="WEAPON",
            },
            {
                name="Marksman Rifle",
                model="WEAPON_MARKSMANRIFLE",
                type="WEAPON",
            },
            {
                name="Heavy Sniper Mk II",
                model="WEAPON_HEAVYSNIPER_MK2",
                type="WEAPON",
            },
            {
                name="Precision Rifle",
                model="WEAPON_PRECISIONRIFLE",
                type="WEAPON",
            },
        }
    },
    {
        name="Melee",
        is_folder = true,
        items ={
            {
                name="Knife",
                model="WEAPON_KNIFE",
                type="WEAPON",
            },
            {
                name="Nightstick",
                model="WEAPON_NIGHTSTICK",
                type="WEAPON",
            },
            {
                name="Hammer",
                model="WEAPON_HAMMER",
                type="WEAPON",
            },
            {
                name="Baseball Bat",
                model="WEAPON_BAT",
                type="WEAPON",
            },
            {
                name="Golf Club",
                model="WEAPON_GOLFCLUB",
                type="WEAPON",
            },
            {
                name="Crowbar",
                model="WEAPON_CROWBAR",
                type="WEAPON",
            },
            {
                name="Bottle",
                model="WEAPON_BOTTLE",
                type="WEAPON",
            },
            {
                name="Antique Cavalry Dagger",
                model="WEAPON_DAGGER",
                type="WEAPON",
            },
            {
                name="Hatchet",
                model="WEAPON_HATCHET",
                type="WEAPON",
            },
            {
                name="Machete",
                model="WEAPON_MACHETE",
                type="WEAPON",
            },
            {
                name="Flashlight",
                model="WEAPON_FLASHLIGHT",
                type="WEAPON",
            },
            {
                name="Switchblade",
                model="COMPONENT_SWITCHBLADE_VARMOD_VAR1",
                type="WEAPON",
            },
            {
                name=" Battle Axe",
                model="WEAPON_BATTLEAXE",
                type="WEAPON",
            },
            {
                name="Pipe Wrench",
                model="WEAPON_WRENCH",
                type="WEAPON",
            },
            {
                name="Pool Cue ",
                model="WEAPON_POOLCUE",
                type="WEAPON",
            },
            {
                name="Stone Hatchet",
                model="WEAPON_STONE_HATCHET",
                type="WEAPON",
            },
        }
    },
    {
        name="Shotguns",
        is_folder = true,
        items ={
            {
                name="Pump Shotgun",
                model="WEAPON_PUMPSHOTGUN",
                type="WEAPON",
            },
            {
                name="Sawed-Off Shotgun",
                model="COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE",
                type="WEAPON",
            },
            {
                name="Assault Shotgun",
                model="WEAPON_ASSAULTSHOTGUN",
                type="WEAPON",
            },
            {
                name="Bullpup Shotgun",
                model="WEAPON_BULLPUPSHOTGUN",
                type="WEAPON",
            },
            {
                name="Pump Shotgun Mk II",
                model="WEAPON_PUMPSHOTGUN_MK2",
                type="WEAPON",
            },
            {
                name="Heavy Shotgun",
                model="WEAPON_HEAVYSHOTGUN",
                type="WEAPON",
            },
            {
                name="Combat Shotgun",
                model="WEAPON_COMBATSHOTGUN",
                type="WEAPON",
            },
            {
                name="Double Barrel Shotgun",
                model="WEAPON_DBSHOTGUN",
                type="WEAPON",
            },
            {
                name="Sweeper Shotgun",
                model="WEAPON_AUTOSHOTGUN",
                type="WEAPON",
            },
        }
    },
    {
        name="Heavy",
        is_folder = true,
        items ={
            {
                name="Grenade Launcher",
                model="WEAPON_GRENADELAUNCHER",
                type="WEAPON",
            },
            {
                name="Tear Gas Launcher",
                model="WEAPON_GRENADELAUNCHER_SMOKE",
                type="WEAPON",
            },
            {
                name="RPG",
                model="WEAPON_RPG",
                type="WEAPON",
            },
            {
                name="Minigun",
                model="WEAPON_MINIGUN",
                type="WEAPON",
            },
            {
                name="Widowmaker",
                model="WEAPON_RAYMINIGUN",
                type="WEAPON",
            },
            {
                name="Homing Launcher",
                model="WEAPON_HOMINGLAUNCHER",
                type="WEAPON",
            },
            {
                name="Firework Launcher",
                model="WEAPON_FIREWORK",
                type="WEAPON",
            },
            {
                name="Railgun",
                model="WEAPON_RAILGUN",
                type="WEAPON",
            },
            {
                name="Compact Grenade Launcher",
                model="WEAPON_COMPACTLAUNCHER",
                type="WEAPON",
            },
            {
                name="Compact EMP Launcher",
                model="WEAPON_EMPLAUNCHER",
                type="WEAPON",
            },
        }
    },
    {
        name="Throwables",
        is_folder = true,
        items ={
            {
                name="Grenade",
                model="WEAPON_GRENADE",
                type="WEAPON",
            },
            {
                name="Sticky Bomb",
                model="WEAPON_STICKYBOMB",
                type="WEAPON",
            },
            {
                name="Tear Gas",
                model="WEAPON_SMOKEGRENADE",
                type="WEAPON",
            },
            {
                name="Molotov",
                model="WEAPON_MOLOTOV",
                type="WEAPON",
            },
            {
                name="Baseball",
                model="WEAPON_BALL",
                type="WEAPON",
            },
            {
                name="Flare",
                model="WEAPON_FLARE",
                type="WEAPON",
            },
            {
                name="Snowball",
                model="WEAPON_SNOWBALL",
                type="WEAPON",
            },
            {
                name="Proximity Mine",
                model="WEAPON_PROXMINE",
                type="WEAPON",
            },
            {
                name="Pipe Bomb",
                model="WEAPON_PIPEBOMB",
                type="WEAPON",
            },
        }
    }
}

return constants
