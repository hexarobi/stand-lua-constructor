-- Curated Attachments
-- v1.3

return {
    {
        name = "Objects",
        is_folder = true,
        items = {
            {
                name = "Lights",
                is_folder = true,
                items = {
                    {
                        name = "Red Spinning Light",
                        model = "hei_prop_wall_light_10a_cr",
                        offset = { x = 0, y = 0, z = 1 },
                        rotation = { x = 180, y = 0, z = 0 },
                        options = {
                            is_light_disabled = true,
                            has_collision = false,
                        },
                        children = {
                            {
                                model = "prop_wall_light_10a",
                                offset = { x = 0, y = 0.01, z = 0 },
                                options = {
                                    is_light_disabled = false,
                                    bone_index = 1,
                                    has_collision = false,
                                },
                            },
                        },
                    },
                    {
                        name = "Blue Spinning Light",
                        model = "hei_prop_wall_light_10a_cr",
                        offset = { x = 0, y = 0, z = 1 },
                        rotation = { x = 180, y = 0, z = 0 },
                        options = {
                            is_light_disabled = true,
                            has_collision = false,
                        },
                        children = {
                            {
                                model = "prop_wall_light_10b",
                                offset = { x = 0, y = 0.01, z = 0 },
                                options = {
                                    is_light_disabled = false,
                                    bone_index = 1,
                                    has_collision = false,
                                },
                            },
                        },
                    },
                    {
                        name = "Yellow Spinning Light",
                        model = "hei_prop_wall_light_10a_cr",
                        offset = { x = 0, y = 0, z = 1 },
                        rotation = { x = 180, y = 0, z = 0 },
                        options = {
                            is_light_disabled = true,
                            has_collision = false,
                        },
                        children = {
                            {
                                model = "prop_wall_light_10c",
                                offset = { x = 0, y = 0.01, z = 0 },
                                options = {
                                    is_light_disabled = false,
                                    bone_index = 1,
                                    has_collision = false,
                                },
                            },
                        },
                    },

                    {
                        name = "Combo Red+Blue Spinning Light",
                        model = "hei_prop_wall_light_10a_cr",
                        offset = { x = 0, y = 0, z = 1 },
                        rotation = { x = 180, y = 0, z = 0 },
                        options = {
                            is_light_disabled = true,
                            has_collision = false,
                        },
                        children = {
                            {
                                model = "prop_wall_light_10b",
                                offset = { x = 0, y = 0.01, z = 0 },
                                options = {
                                    is_light_disabled = false,
                                    bone_index = 1,
                                    has_collision = false,
                                },
                            },
                            {
                                model = "prop_wall_light_10a",
                                offset = { x = 0, y = 0.01, z = 0 },
                                rotation = { x = 0, y = 0, z = 180 },
                                options = {
                                    is_light_disabled = false,
                                    bone_index = 1,
                                    has_collision = false,
                                },
                            },
                        },
                        --reflection = {
                        --    model = "hei_prop_wall_light_10a_cr",
                        --    reflection_axis = { x = true, y = false, z = false },
                        --    options = { is_light_disabled = true },
                        --    children = {
                        --        {
                        --            model = "prop_wall_light_10a",
                        --            offset = { x = 0, y = 0.01, z = 0 },
                        --            rotation = { x = 0, y = 0, z = 180 },
                        --            options = { is_light_disabled = false },
                        --            bone_index = 1,
                        --        },
                        --    },
                        --}
                    },

                    {
                        name = "Pair of Spinning Lights",
                        model = "hei_prop_wall_light_10a_cr",
                        offset = { x = 0.3, y = 0, z = 1 },
                        rotation = { x = 180, y = 0, z = 0 },
                        options = {
                            is_light_disabled = true,
                            has_collision = false,
                        },
                        children = {
                            {
                                model = "prop_wall_light_10b",
                                offset = { x = 0, y = 0.01, z = 0 },
                                options = {
                                    is_light_disabled = false,
                                    bone_index = 1,
                                    has_collision = false,
                                },
                            },
                            {
                                model = "hei_prop_wall_light_10a_cr",
                                reflection_axis = { x = true, y = false, z = false },
                                options = {
                                    is_light_disabled = true,
                                    has_collision = false,
                                },
                                children = {
                                    {
                                        model = "prop_wall_light_10a",
                                        offset = { x = 0, y = 0.01, z = 0 },
                                        rotation = { x = 0, y = 0, z = 180 },
                                        options = {
                                            is_light_disabled = false,
                                            bone_index = 1,
                                            has_collision = false,
                                        },
                                    },
                                },
                            }
                        },
                    },

                    {
                        name = "Short Spinning Red Light",
                        model = "hei_prop_wall_alarm_on",
                        offset = { x = 0, y = 0, z = 1 },
                        rotation = { x = -90, y = 0, z = 0 },
                    },
                    {
                        name = "Small Red Warning Light",
                        model = "prop_warninglight_01",
                        offset = { x = 0, y = 0, z = 1 },
                    },

                    {
                        name = "Blue Recessed Light",
                        model = "h4_prop_battle_lights_floorblue",
                        offset = { x = 0, y = 0, z = 0.75 },
                    },
                    {
                        name = "Red Recessed Light",
                        model = "h4_prop_battle_lights_floorred",
                        offset = { x = 0, y = 0, z = 0.75 },
                    },
                    {
                        name = "Red/Blue Pair of Recessed Lights",
                        model = "h4_prop_battle_lights_floorred",
                        offset = { x = 0.3, y = 0, z = 1 },
                        children = {
                            {
                                model = "h4_prop_battle_lights_floorblue",
                                reflection_axis = { x = true, y = false, z = false },
                            }
                        }
                    },
                    {
                        name = "Blue/Red Pair of Recessed Lights",
                        model = "h4_prop_battle_lights_floorblue",
                        offset = { x = 0.3, y = 0, z = 1 },
                        children = {
                            {
                                model = "h4_prop_battle_lights_floorred",
                                reflection_axis = { x = true, y = false, z = false },
                            }
                        }
                    },

                    -- Flashing is still kinda wonky for networking
                    {
                        name = "Flashing Recessed Lights",
                        model = "h4_prop_battle_lights_floorred",
                        offset = { x = 0.3, y = 0, z = 1 },
                        flash_start_on = false,
                        children = {
                            {
                                model = "h4_prop_battle_lights_floorblue",
                                reflection_axis = { x = true, y = false, z = false },
                                flash_start_on = true,
                            }
                        }
                    },
                    {
                        name = "Alternating Pair of Recessed Lights",
                        model = "h4_prop_battle_lights_floorred",
                        offset = { x = 0.3, y = 0, z = 1 },
                        flash_start_on = true,
                        children = {
                            {
                                model = "h4_prop_battle_lights_floorred",
                                reflection_axis = { x = true, y = false, z = false },
                                flash_start_on = false,
                                children = {
                                    {
                                        model = "h4_prop_battle_lights_floorblue",
                                        flash_start_on = true,
                                    }
                                }
                            },
                            {
                                model = "h4_prop_battle_lights_floorblue",
                                flash_start_on = true,
                            }
                        }
                    },

                    {
                        name = "Red Disc Light",
                        model = "prop_runlight_r",
                        offset = { x = 0, y = 0, z = 1 },
                    },
                    {
                        name = "Blue Disc Light",
                        model = "prop_runlight_b",
                        offset = { x = 0, y = 0, z = 1 },
                    },

                    {
                        name = "Blue Pole Light",
                        model = "prop_air_lights_02a",
                        offset = { x = 0, y = 0, z = 1 },
                    },
                    {
                        name = "Red Pole Light",
                        model = "prop_air_lights_02b",
                        offset = { x = 0, y = 0, z = 1 },
                    },

                    {
                        name = "Red Angled Light",
                        model = "prop_air_lights_04a",
                        offset = { x = 0, y = 0, z = 1 },
                    },
                    {
                        name = "Blue Angled Light",
                        model = "prop_air_lights_05a",
                        offset = { x = 0, y = 0, z = 1 },
                    },

                    {
                        name = "Cone Light",
                        model = "prop_air_conelight",
                        offset = { x = 0, y = 0, z = 1 },
                        rotation = { x = 0, y = 0, z = 0 },
                    },

                    -- This is actually 2 lights, spaced 20 feet apart.
                    --{
                    --    name="Blinking Red Light",
                    --    model="hei_prop_carrier_docklight_01",
                    --}
                },
            },
            {
                name = "Police",
                is_folder = true,
                items = {
                    {
                        name = "Riot Shield",
                        model = "prop_riot_shield",
                        rotation = { x = 180, y = 180, z = 0 },
                    },
                    {
                        name = "Ballistic Shield",
                        model = "prop_ballistic_shield",
                        rotation = { x = 180, y = 180, z = 0 },
                    },
                    {
                        name = "Minigun",
                        model = "prop_minigun_01",
                        rotation = { x = 0, y = 0, z = 90 },
                    },
                    {
                        name = "Monitor Screen",
                        model = "hei_prop_hei_monitor_police_01",
                    },
                    {
                        name = "Bomb",
                        model = "prop_ld_bomb_anim",
                    },
                    {
                        name = "Bomb (open)",
                        model = "prop_ld_bomb_01_open",
                    },
                },
            },
            {
                name = "Vehicle Objects",
                is_folder = true,
                items = {
                    {
                        name = "Aircraft Carrier",
                        model = "prop_temp_carrier"
                    },
                    {
                        name = "Commercial Jet",
                        model = "p_med_jet_01_s"
                    },
                    {
                        name = "Military Jet",
                        model = "hei_prop_carrier_jet"
                    },
                    {
                        name = "Tugboat",
                        model = "hei_prop_heist_tug"
                    },
                    {
                        name = "UFO",
                        model = "imp_prop_ship_01a"
                    },
                    {
                        name = "Yacht",
                        model = "apa_mp_apa_yacht"
                    },
                }
            },
            {
                name = "Animated Objects",
                is_folder = true,
                items = {
                    {
                        name = "Radar Dish",
                        model = "hei_prop_carrier_radar_1_l1"
                    },
                    {
                        name = "UFO",
                        model = "p_spinning_anus_s"
                    },
                    {
                        name = "Wacky Arm Waving Inflatable Tube Man",
                        model = "prop_airdancer_2_cloth"
                    },
                }
            },
            items = {
                name = "Fun",
                is_folder = true,
                items = {
                    {
                        name = "ATM",
                        model = "prop_atm_01"
                    },
                    {
                        name = "Bomb",
                        model = "imp_prop_bomb_ball"
                    },
                    {
                        name = "Car wheel",
                        model = "imp_prop_impexp_tyre_01c"
                    },
                    {
                        name = "Ferris wheel",
                        model = "p_ferris_wheel_amo_l"
                    },
                    {
                        name = "Guitar",
                        model = "prop_acc_guitar_01"
                    },
                    {
                        name = "Pile o' cash",
                        model = "bkr_prop_bkr_cashpile_01"
                    },
                    {
                        name = "Shipping container",
                        model = "port_xr_cont_01"
                    },
                    {
                        name = "Weed plant",
                        model = "bkr_prop_weed_lrg_01b"
                    },
                    {
                        name = "Wood crate",
                        model = "ng_proc_crate_04a"
                    },
                },
            },
        },
    },
    {
        name = "Vehicles",
        is_folder = true,
        items = {
            {
                name = "Police",
                is_folder = true,
                items = {
                    {
                        name = "Police Cruiser",
                        model = "police",
                        type = "VEHICLE",
                    },
                    {
                        name = "Police Buffalo",
                        model = "police2",
                        type = "VEHICLE",
                    },
                    {
                        name = "Police Sports",
                        model = "police3",
                        type = "VEHICLE",
                    },
                    {
                        name = "Police Van",
                        model = "policet",
                        type = "VEHICLE",
                    },
                    {
                        name = "Police Bike",
                        model = "policeb",
                        type = "VEHICLE",
                    },
                    {
                        name = "FIB Cruiser",
                        model = "fbi",
                        type = "VEHICLE",
                    },
                    {
                        name = "FIB SUV",
                        model = "fbi2",
                        type = "VEHICLE",
                    },
                    {
                        name = "Sheriff Cruiser",
                        model = "sheriff",
                        type = "VEHICLE",
                    },
                    {
                        name = "Sheriff SUV",
                        model = "sheriff2",
                        type = "VEHICLE",
                    },
                    {
                        name = "Unmarked Cruiser",
                        model = "police3",
                        type = "VEHICLE",
                    },
                    {
                        name = "Snowy Rancher",
                        model = "policeold1",
                        type = "VEHICLE",
                    },
                    {
                        name = "Snowy Cruiser",
                        model = "policeold2",
                        type = "VEHICLE",
                    },
                    {
                        name = "Park Ranger",
                        model = "pranger",
                        type = "VEHICLE",
                    },
                    {
                        name = "Riot Van",
                        model = "riot",
                        type = "VEHICLE",
                    },
                    {
                        name = "Riot Control Vehicle (RCV)",
                        model = "riot2",
                        type = "VEHICLE",
                    },
                },
            }
        },
    },
    {
        name = "Peds",
        is_folder = true,
        items = {
            {
                name="Ambient Females",
                is_folder = true,
                items = {
                    {
                        name="Beach Bikini",
                        model="a_f_m_beach_01",
                        type="PED",
                    },
                    --{
                    --    name="",
                    --    model="",
                    --    type="PED",
                    --},
                    --{
                    --    name="",
                    --    model="",
                    --    type="PED",
                    --},
                },
            },
        },
    },
}
