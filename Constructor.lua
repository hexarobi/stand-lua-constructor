-- Constructor
-- by Hexarobi
-- A Lua Script for the Stand mod menu for GTA5
-- Allows for constructing custom vehicles and maps
-- https://github.com/hexarobi/stand-lua-constructor

local SCRIPT_VERSION = "0.2"
local AUTO_UPDATE_BRANCHES = {
    { "main", {}, "More stable, but updated less often.", "main", },
    { "dev", {}, "Cutting edge updates, but less stable.", "dev", },
}
local SELECTED_BRANCH_INDEX = 1

---
--- Auto-Updater
---

local auto_update_source_url = "https://raw.githubusercontent.com/hexarobi/stand-lua-constructor/main/Constructor.lua"

-- Auto Updater from https://github.com/hexarobi/stand-lua-auto-updater
local status, lib = pcall(require, "auto-updater")
if not status then
    auto_update_complete = nil util.toast("Installing auto-updater...", TOAST_ALL)
    async_http.init("raw.githubusercontent.com", "/hexarobi/stand-lua-auto-updater/main/auto-updater.lua",
            function(result, headers, status_code)
                local function parse_auto_update_result(result, headers, status_code)
                    local error_prefix = "Error downloading auto-updater: "
                    if status_code ~= 200 then util.toast(error_prefix..status_code, TOAST_ALL) return false end
                    if not result or result == "" then util.toast(error_prefix.."Found empty file.", TOAST_ALL) return false end
                    local file = io.open(filesystem.scripts_dir() .. "lib\\auto-updater.lua", "wb")
                    if file == nil then util.toast(error_prefix.."Could not open file for writing.", TOAST_ALL) return false end
                    file:write(result) file:close() util.toast("Successfully installed auto-updater lib", TOAST_ALL) return true
                end
                auto_update_complete = parse_auto_update_result(result, headers, status_code)
            end, function() util.toast("Error downloading auto-updater lib. Update failed to download.", TOAST_ALL) end)
    async_http.dispatch() local i = 1 while (auto_update_complete == nil and i < 10) do util.yield(250) i = i + 1 end
    require("auto-updater")
end

local function auto_update_branch(selected_branch)
    local branch_source_url = auto_update_source_url:gsub("/main/", "/"..selected_branch.."/")
    run_auto_update({source_url=branch_source_url, script_relpath=SCRIPT_RELPATH, verify_file_begins_with="--"})
end
auto_update_branch(AUTO_UPDATE_BRANCHES[SELECTED_BRANCH_INDEX][1])

---
--- Data
---

local config = {
    source_code_branch = "main",
    edit_offset_step = 1,
    edit_rotation_step = 1,
    add_attachment_gun_active = false,
}

local CONSTRUCTS_DIR = filesystem.store_dir() .. 'Constructor\\constructs\\'

local function ensure_directory_exists(path)
    path = path:gsub("\\", "/")
    local dirpath = ""
    for dirname in path:gmatch("[^/]+") do
        dirpath = dirpath .. dirname .. "/"
        if not filesystem.exists(dirpath) then filesystem.mkdir(dirpath) end
    end
end
ensure_directory_exists(CONSTRUCTS_DIR)

local spawned_constructs = {}
local last_spawned_construct
local menus = {}

--local example_construct = {
--    name="Police",
--    model="police",
--    handle=1234,
--    options = {},
--    attachments = {},
--}
--
--local example_attachment = {
--    name="Child #1",            -- Name for this attachment
--    handle=5678,                -- Handle for this attachment
--    root=example_policified_vehicle,
--    parent=1234,                -- Parent Handle
--    bone_index = 0,             -- Which bone of the parent should this attach to
--    offset = { x=0, y=0, z=0 },  -- Offset coords from parent
--    rotation = { x=0, y=0, z=0 },-- Rotation from parent
--    children = {
--        -- Other attachments
--        reflection_axis = { x = true, y = false, z = false },   -- Which axis should be reflected about
--    },
--    is_visible = true,
--    has_collision = true,
--    has_gravity = true,
--    is_light_disabled = true,   -- If true this light will always be off, regardless of siren settings
--}

local construct_base = {
    target_version = SCRIPT_VERSION,
    children = {},
    options = {},
}

local ENTITY_TYPES = {"PED", "VEHICLE", "OBJECT"}

-- Good props for cop lights
-- prop_air_lights_02a blue
-- prop_air_lights_02b red
-- h4_prop_battle_lights_floorblue
-- h4_prop_battle_lights_floorred
-- prop_wall_light_10a
-- prop_wall_light_10b
-- prop_wall_light_10c
-- hei_prop_wall_light_10a_cr

local available_attachments = {
    {
        name = "Lights",
        objects = {
            {
                name = "Red Spinning Light",
                model = "hei_prop_wall_light_10a_cr",
                offset = { x = 0, y = 0, z = 1 },
                rotation = { x = 180, y = 0, z = 0 },
                is_light_disabled = true,
                children = {
                    {
                        model = "prop_wall_light_10a",
                        offset = { x = 0, y = 0.01, z = 0 },
                        is_light_disabled = false,
                        bone_index = 1,
                    },
                },
            },
            {
                name = "Blue Spinning Light",
                model = "hei_prop_wall_light_10a_cr",
                offset = { x = 0, y = 0, z = 1 },
                rotation = { x = 180, y = 0, z = 0 },
                is_light_disabled = true,
                children = {
                    {
                        model = "prop_wall_light_10b",
                        offset = { x = 0, y = 0.01, z = 0 },
                        is_light_disabled = false,
                        bone_index = 1,
                    },
                },
            },
            {
                name = "Yellow Spinning Light",
                model = "hei_prop_wall_light_10a_cr",
                offset = { x = 0, y = 0, z = 1 },
                rotation = { x = 180, y = 0, z = 0 },
                is_light_disabled = true,
                children = {
                    {
                        model = "prop_wall_light_10c",
                        offset = { x = 0, y = 0.01, z = 0 },
                        is_light_disabled = false,
                        bone_index = 1,
                    },
                },
            },

            {
                name = "Combo Red+Blue Spinning Light",
                model = "hei_prop_wall_light_10a_cr",
                offset = { x = 0, y = 0, z = 1 },
                rotation = { x = 180, y = 0, z = 0 },
                is_light_disabled = true,
                children = {
                    {
                        model = "prop_wall_light_10b",
                        offset = { x = 0, y = 0.01, z = 0 },
                        is_light_disabled = false,
                        bone_index = 1,
                    },
                    {
                        model = "prop_wall_light_10a",
                        offset = { x = 0, y = 0.01, z = 0 },
                        rotation = { x = 0, y = 0, z = 180 },
                        is_light_disabled = false,
                        bone_index = 1,
                    },
                },
                --reflection = {
                --    model = "hei_prop_wall_light_10a_cr",
                --    reflection_axis = { x = true, y = false, z = false },
                --    is_light_disabled = true,
                --    children = {
                --        {
                --            model = "prop_wall_light_10a",
                --            offset = { x = 0, y = 0.01, z = 0 },
                --            rotation = { x = 0, y = 0, z = 180 },
                --            is_light_disabled = false,
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
                is_light_disabled = true,
                children = {
                    {
                        model = "prop_wall_light_10b",
                        offset = { x = 0, y = 0.01, z = 0 },
                        is_light_disabled = false,
                        bone_index = 1,
                    },
                    {
                        model = "hei_prop_wall_light_10a_cr",
                        reflection_axis = { x = true, y = false, z = false },
                        is_light_disabled = true,
                        children = {
                            {
                                model = "prop_wall_light_10a",
                                offset = { x = 0, y = 0.01, z = 0 },
                                rotation = { x = 0, y = 0, z = 180 },
                                is_light_disabled = false,
                                bone_index = 1,
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
        name = "Props",
        objects = {
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
        name = "Vehicles",
        objects = {
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
                model = "rior",
                type = "VEHICLE",
            },
            {
                name = "Riot Control Vehicle (RCV)",
                model = "riot2",
                type = "VEHICLE",
            },
        },
    },
}

---
--- Utilities
---

util.require_natives(1660775568)
local json = require("json")
--local inspect = require("inspect")

function table.table_copy(obj)
    if type(obj) ~= 'table' then
        return obj
    end
    local res = setmetatable({}, getmetatable(obj))
    for k, v in pairs(obj) do
        res[table.table_copy(k)] = table.table_copy(v)
    end
    return res
end

function string.starts(String,Start)
    return string.sub(String,1,string.len(Start))==Start
end

-- From https://stackoverflow.com/questions/12394841/safely-remove-items-from-an-array-table-while-iterating
local function array_remove(t, fnKeep)
    local j, n = 1, #t;

    for i=1,n do
        if (fnKeep(t, i, j)) then
            -- Move i's kept value to j's position, if it's not already there.
            if (i ~= j) then
                t[j] = t[i];
                t[i] = nil;
            end
            j = j + 1; -- Increment position of where we'll place the next kept value.
        else
            t[i] = nil;
        end
    end

    return t;
end

local function load_hash(hash)
    STREAMING.REQUEST_MODEL(hash)
    while not STREAMING.HAS_MODEL_LOADED(hash) do
        util.yield()
    end
end

local function spawn_vehicle_for_player(pid, model_name)
    local model = util.joaat(model_name)
    if not STREAMING.IS_MODEL_VALID(model) or not STREAMING.IS_MODEL_A_VEHICLE(model) then
         util.toast("Error: Invalid vehicle name")
        return
    else
        load_hash(model)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(target_ped, 0.0, 4.0, 0.5)
        local heading = ENTITY.GET_ENTITY_HEADING(target_ped)
        local vehicle = entities.create_vehicle(model, pos, heading)
        STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(model)
        return vehicle
    end
end

---
--- Specific Serializers
---

local function serialize_vehicle_headlights(vehicle, serialized_vehicle)
    if serialized_vehicle.headlights == nil then serialized_vehicle.headlights = {} end
    serialized_vehicle.headlights.headlights_color = VEHICLE._GET_VEHICLE_XENON_LIGHTS_COLOR(vehicle.handle)
    serialized_vehicle.headlights.headlights_type = VEHICLE.IS_TOGGLE_MOD_ON(vehicle.handle, 22)
    return serialized_vehicle
end

local function deserialize_vehicle_headlights(vehicle, serialized_vehicle)
    VEHICLE._SET_VEHICLE_XENON_LIGHTS_COLOR(vehicle.handle, serialized_vehicle.headlights.headlights_color)
    VEHICLE.TOGGLE_VEHICLE_MOD(vehicle.handle, 22, serialized_vehicle.headlights.headlights_type or false)
end

local function serialize_vehicle_paint(vehicle, serialized_vehicle)
    if serialized_vehicle.paint == nil then
        serialized_vehicle.paint = {
            primary = {},
            secondary = {},
        }
    end

    -- Create pointers to hold color values
    local color = { r = memory.alloc(4), g = memory.alloc(4), b = memory.alloc(4) }

    VEHICLE.GET_VEHICLE_COLOR(vehicle, color.r, color.g, color.b)
    serialized_vehicle.paint.vehicle_custom_color = { r = memory.read_int(color.r), g = memory.read_int(color.g), b = memory.read_int(color.b) }
    VEHICLE.GET_VEHICLE_COLOURS(vehicle, color.r, color.g)
    serialized_vehicle.paint.primary.vehicle_standard_color = memory.read_int(color.r)
    serialized_vehicle.paint.secondary.vehicle_standard_color = memory.read_int(color.g)

    serialized_vehicle.paint.primary.is_custom = VEHICLE.GET_IS_VEHICLE_PRIMARY_COLOUR_CUSTOM(vehicle.handle)
    if serialized_vehicle.paint.primary.is_custom then
        VEHICLE.GET_VEHICLE_CUSTOM_PRIMARY_COLOUR(vehicle.handle, color.r, color.g, color.b)
        serialized_vehicle.paint.primary.custom_color = { r = memory.read_int(color.r), b = memory.read_int(color.g), g = memory.read_int(color.b) }
    else
        VEHICLE.GET_VEHICLE_MOD_COLOR_1(vehicle.handle, color.r, color.g, color.b)
        serialized_vehicle.paint.primary.paint_type = memory.read_int(color.r)
        serialized_vehicle.paint.primary.color = memory.read_int(color.g)
        serialized_vehicle.paint.primary.pearlescent_color = memory.read_int(color.b)
    end

    serialized_vehicle.paint.secondary.is_custom = VEHICLE.GET_IS_VEHICLE_SECONDARY_COLOUR_CUSTOM(vehicle.handle)
    if serialized_vehicle.paint.secondary.is_custom then
        VEHICLE.GET_VEHICLE_CUSTOM_SECONDARY_COLOUR(vehicle.handle, color.r, color.g, color.b)
        serialized_vehicle.paint.secondary.custom_color = { r = memory.read_int(color.r), b = memory.read_int(color.g), g = memory.read_int(color.b) }
    else
        VEHICLE.GET_VEHICLE_MOD_COLOR_2(vehicle.handle, color.r, color.g)
        serialized_vehicle.paint.secondary.paint_type = memory.read_int(color.r)
        serialized_vehicle.paint.secondary.color = memory.read_int(color.g)
    end

    VEHICLE.GET_VEHICLE_EXTRA_COLOURS(vehicle.handle, color.r, color.g)
    serialized_vehicle.paint.extra_colors = { pearlescent = memory.read_int(color.r), wheel = memory.read_int(color.g) }
    VEHICLE._GET_VEHICLE_DASHBOARD_COLOR(vehicle.handle, color.r)
    serialized_vehicle.paint.dashboard_color = memory.read_int(color.r)
    VEHICLE._GET_VEHICLE_INTERIOR_COLOR(vehicle.handle, color.r)
    serialized_vehicle.paint.interior_color = memory.read_int(color.r)
    serialized_vehicle.paint.fade = VEHICLE.GET_VEHICLE_ENVEFF_SCALE(vehicle.handle)
    serialized_vehicle.paint.dirt_level = VEHICLE.GET_VEHICLE_DIRT_LEVEL(vehicle.handle)
    serialized_vehicle.paint.color_combo = VEHICLE.GET_VEHICLE_COLOUR_COMBINATION(vehicle.handle)

    -- Livery is also part of mods, but capture it here as well for when just saving paint
    serialized_vehicle.paint.livery = VEHICLE.GET_VEHICLE_MOD(vehicle.handle, 48)

    memory.free(color.r) memory.free(color.g) memory.free(color.b)
end

local function deserialize_vehicle_paint(vehicle, serialized_vehicle)

    --VEHICLE.SET_VEHICLE_MOD_KIT(vehicle.handle, 0)

    VEHICLE.SET_VEHICLE_CUSTOM_PRIMARY_COLOUR(
            vehicle,
            serialized_vehicle.paint.vehicle_custom_color.r,
            serialized_vehicle.paint.vehicle_custom_color.g,
            serialized_vehicle.paint.vehicle_custom_color.b
    )
    VEHICLE.SET_VEHICLE_CUSTOM_SECONDARY_COLOUR(
            vehicle,
            serialized_vehicle.paint.vehicle_custom_color.r,
            serialized_vehicle.paint.vehicle_custom_color.g,
            serialized_vehicle.paint.vehicle_custom_color.b
    )
    VEHICLE.SET_VEHICLE_COLOURS(
            vehicle,
            serialized_vehicle.paint.primary.vehicle_standard_color or 0,
            serialized_vehicle.paint.secondary.vehicle_standard_color or 0
    )

    if serialized_vehicle.paint.extra_colors then
        VEHICLE.SET_VEHICLE_EXTRA_COLOURS(
                vehicle.handle,
                serialized_vehicle.paint.extra_colors.pearlescent,
                serialized_vehicle.paint.extra_colors.wheel
        )
    end

    if serialized_vehicle.paint.primary.is_custom then
        VEHICLE.SET_VEHICLE_CUSTOM_PRIMARY_COLOUR(
                vehicle.handle,
                serialized_vehicle.paint.primary.custom_color.r,
                serialized_vehicle.paint.primary.custom_color.g,
                serialized_vehicle.paint.primary.custom_color.b
        )
    else
        VEHICLE.SET_VEHICLE_MOD_COLOR_1(
                vehicle.handle,
                serialized_vehicle.paint.primary.paint_type,
                serialized_vehicle.paint.primary.color,
                serialized_vehicle.paint.primary.pearlescent_color
        )
    end

    if serialized_vehicle.paint.secondary.is_custom then
        VEHICLE.SET_VEHICLE_CUSTOM_SECONDARY_COLOUR(
                vehicle.handle,
                serialized_vehicle.paint.secondary.custom_color.r,
                serialized_vehicle.paint.secondary.custom_color.g,
                serialized_vehicle.paint.secondary.custom_color.b
        )
    else
        VEHICLE.SET_VEHICLE_MOD_COLOR_2(
                vehicle.handle,
                serialized_vehicle.paint.secondary.paint_type,
                serialized_vehicle.paint.secondary.color
        )
    end

    VEHICLE._SET_VEHICLE_XENON_LIGHTS_COLOR(vehicle.handle, serialized_vehicle.headlights_color)
    VEHICLE._SET_VEHICLE_DASHBOARD_COLOR(vehicle.handle, serialized_vehicle.paint.dashboard_color or -1)
    VEHICLE._SET_VEHICLE_INTERIOR_COLOR(vehicle.handle, serialized_vehicle.paint.interior_color or -1)

    VEHICLE.SET_VEHICLE_ENVEFF_SCALE(vehicle.handle, serialized_vehicle.paint.fade or 0)
    VEHICLE.SET_VEHICLE_DIRT_LEVEL(vehicle.handle, serialized_vehicle.paint.dirt_level or 0.0)
    VEHICLE.SET_VEHICLE_COLOUR_COMBINATION(vehicle.handle, serialized_vehicle.paint.color_combo or -1)
    VEHICLE.SET_VEHICLE_MOD(vehicle.handle, 48, serialized_vehicle.paint.livery or -1)
end

local function serialize_vehicle_neon(vehicle, serialized_vehicle)
    if serialized_vehicle.neon == nil then serialized_vehicle.neon = {} end
    serialized_vehicle.neon.lights = {
        left = VEHICLE._IS_VEHICLE_NEON_LIGHT_ENABLED(vehicle.handle, 0),
        right = VEHICLE._IS_VEHICLE_NEON_LIGHT_ENABLED(vehicle.handle, 1),
        front = VEHICLE._IS_VEHICLE_NEON_LIGHT_ENABLED(vehicle.handle, 2),
        back = VEHICLE._IS_VEHICLE_NEON_LIGHT_ENABLED(vehicle.handle, 3),
    }
    local color = { r = memory.alloc(4), g = memory.alloc(4), b = memory.alloc(4) }
    if (serialized_vehicle.neon.lights.left or serialized_vehicle.neon.lights.right
            or serialized_vehicle.neon.lights.front or serialized_vehicle.neon.lights.back) then
        VEHICLE._GET_VEHICLE_NEON_LIGHTS_COLOUR(vehicle.handle, color.r, color.g, color.b)
        serialized_vehicle.neon.color = { r = memory.read_int(color.r), g = memory.read_int(color.g), b = memory.read_int(color.b) }
    end
    memory.free(color.r) memory.free(color.g) memory.free(color.b)
end

local function deserialize_vehicle_neon(vehicle, serialized_vehicle)
    VEHICLE._SET_VEHICLE_NEON_LIGHT_ENABLED(vehicle.handle, 0, serialized_vehicle.neon.lights.left or false)
    VEHICLE._SET_VEHICLE_NEON_LIGHT_ENABLED(vehicle.handle, 1, serialized_vehicle.neon.lights.right or false)
    VEHICLE._SET_VEHICLE_NEON_LIGHT_ENABLED(vehicle.handle, 2, serialized_vehicle.neon.lights.front or false)
    VEHICLE._SET_VEHICLE_NEON_LIGHT_ENABLED(vehicle.handle, 3, serialized_vehicle.neon.lights.back or false)
    if serialized_vehicle.neon.color then
        VEHICLE._SET_VEHICLE_NEON_LIGHTS_COLOUR(
                vehicle.handle,
                serialized_vehicle.neon.color.r,
                serialized_vehicle.neon.color.g,
                serialized_vehicle.neon.color.b
        )
    end
end

local function serialize_vehicle_wheels(vehicle, serialized_vehicle)
    if serialized_vehicle.wheels == nil then serialized_vehicle.wheels = {} end
    serialized_vehicle.wheels.type = VEHICLE.GET_VEHICLE_WHEEL_TYPE(vehicle.handle)
    local color = { r = memory.alloc(4), g = memory.alloc(4), b = memory.alloc(4) }
    VEHICLE.GET_VEHICLE_TYRE_SMOKE_COLOR(vehicle.handle, color.r, color.g, color.b)
    serialized_vehicle.wheels.tire_smoke_color = { r = memory.read_int(color.r), g = memory.read_int(color.g), b = memory.read_int(color.b) }
    memory.free(color.r) memory.free(color.g) memory.free(color.b)
end

local function deserialize_vehicle_wheels(vehicle, serialized_vehicle)
    VEHICLE.SET_VEHICLE_TYRES_CAN_BURST(vehicle.handle, serialized_vehicle.bulletproof_tires or false)
    VEHICLE.SET_VEHICLE_WHEEL_TYPE(vehicle.handle, serialized_vehicle.wheel_type or -1)
    if serialized_vehicle.tire_smoke_color then
        VEHICLE.SET_VEHICLE_TYRE_SMOKE_COLOR(vehicle.handle, serialized_vehicle.tire_smoke_color.r or 255,
                serialized_vehicle.tire_smoke_color.g or 255, serialized_vehicle.tire_smoke_color.b or 255)
    end
end

local function serialize_vehicle_mods(vehicle, serialized_vehicle)
    if serialized_vehicle.mods == nil then serialized_vehicle.mods = {} end
    for mod_index = 0, 49 do
        local mod_value
        if mod_index >= 17 and mod_index <= 22 then
            mod_value = VEHICLE.IS_TOGGLE_MOD_ON(vehicle.handle, mod_index)
        else
            mod_value = VEHICLE.GET_VEHICLE_MOD(vehicle.handle, mod_index)
        end
        serialized_vehicle.mods["_"..mod_index] = mod_value
    end
end

local function deserialize_vehicle_mods(vehicle, serialized_vehicle)
    for mod_index = 0, 49 do
        if mod_index >= 17 and mod_index <= 22 then
            VEHICLE.TOGGLE_VEHICLE_MOD(vehicle.handle, mod_index, serialized_vehicle.mods["_"..mod_index])
        else
            VEHICLE.SET_VEHICLE_MOD(vehicle.handle, mod_index, serialized_vehicle.mods["_"..mod_index] or -1)
        end
    end
end

local function serialize_vehicle_extras(vehicle, serialized_vehicle)
    if serialized_vehicle.extras == nil then serialized_vehicle.extras = {} end
    for extra_index = 0, 14 do
        if VEHICLE.DOES_EXTRA_EXIST(vehicle.handle, extra_index) then
            serialized_vehicle.extras["_"..extra_index] = VEHICLE.IS_VEHICLE_EXTRA_TURNED_ON(vehicle.handle, extra_index)
        end
    end
end

local function deserialize_vehicle_extras(vehicle, serialized_vehicle)
    for extra_index = 0, 14 do
        local state = true
        if serialized_vehicle.extras["_"..extra_index] ~= nil then
            state = serialized_vehicle.extras["_"..extra_index]
        end
        VEHICLE.SET_VEHICLE_EXTRA(vehicle.handle, extra_index, not state)
    end
end

local function serialize_vehicle_options(vehicle, serialized_vehicle)
    if serialized_vehicle.options == nil then serialized_vehicle.options = {} end
    serialized_vehicle.options.headlights_color = VEHICLE._GET_VEHICLE_XENON_LIGHTS_COLOR(vehicle.handle)
    serialized_vehicle.options.bulletproof_tires = VEHICLE.GET_VEHICLE_TYRES_CAN_BURST(vehicle.handle)
    serialized_vehicle.options.window_tint = VEHICLE.GET_VEHICLE_WINDOW_TINT(vehicle.handle)
    serialized_vehicle.options.radio_loud = AUDIO.CAN_VEHICLE_RECEIVE_CB_RADIO(vehicle.handle)
    serialized_vehicle.options.engine_running = VEHICLE.GET_IS_VEHICLE_ENGINE_RUNNING(vehicle.handle)
    serialized_vehicle.options.siren = VEHICLE.IS_VEHICLE_SIREN_AUDIO_ON(vehicle.handle)
    serialized_vehicle.options.emergency_lights = VEHICLE.IS_VEHICLE_SIREN_ON(vehicle.handle)
    serialized_vehicle.options.search_light = VEHICLE.IS_VEHICLE_SEARCHLIGHT_ON(vehicle.handle)
    serialized_vehicle.options.license_plate_text = VEHICLE.GET_VEHICLE_NUMBER_PLATE_TEXT(vehicle.handle)
    serialized_vehicle.options.license_plate_type = VEHICLE.GET_VEHICLE_NUMBER_PLATE_TEXT_INDEX(vehicle.handle)
end

local function deserialize_vehicle_options(vehicle, serialized_vehicle)
    if serialized_vehicle.options.siren then
        AUDIO.SET_SIREN_WITH_NO_DRIVER(vehicle.handle, true)
        VEHICLE.SET_VEHICLE_HAS_MUTED_SIRENS(vehicle.handle, false)
        AUDIO._SET_SIREN_KEEP_ON(vehicle.handle, true)
        AUDIO._TRIGGER_SIREN(vehicle.handle, true)
    end
    VEHICLE.SET_VEHICLE_SIREN(vehicle.handle, serialized_vehicle.options.emergency_lights or false)
    VEHICLE.SET_VEHICLE_SEARCHLIGHT(vehicle.handle, serialized_vehicle.options.search_light or false, true)
    AUDIO.SET_VEHICLE_RADIO_LOUD(vehicle.handle, serialized_vehicle.options.radio_loud or false)
    VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT(vehicle.handle, serialized_vehicle.options.license_plate_text or "UNKNOWN")
    VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT_INDEX(vehicle.handle, serialized_vehicle.options.license_plate_type or -1)

    if serialized_vehicle.options.engine_running then
        VEHICLE.SET_VEHICLE_ENGINE_ON(vehicle.handle, true, true, false)
    end
end

---
--- Attachment Construction
---

local function set_attachment_internal_collisions(attachment, new_attachment)
    ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(attachment.handle, new_attachment.handle)
    for _, child_attachment in pairs(attachment.children) do
        set_attachment_internal_collisions(child_attachment, new_attachment)
    end
end

local function set_attachment_defaults(attachment)
    if attachment.offset == nil then
        attachment.offset = { x = 0, y = 0, z = 0 }
    end
    if attachment.rotation == nil then
        attachment.rotation = { x = 0, y = 0, z = 0 }
    end
    if attachment.is_visible == nil then
        attachment.is_visible = true
    end
    if attachment.has_gravity == nil then
        attachment.has_gravity = false
    end
    if attachment.has_collision == nil then
        attachment.has_collision = false
    end
    if attachment.hash == nil and attachment.model == nil then
        error("Cannot create attachment: Requires either a hash or a model")
    end
    if attachment.hash == nil then
        attachment.hash = util.joaat(attachment.model)
    else
        if attachment.model == nil then
            attachment.model = util.reverse_joaat(attachment.hash)
        end
    end
    if attachment.name == nil then
        attachment.name = attachment.model
    end
    if attachment.children == nil then
        attachment.children = {}
    end
    if attachment.options == nil then
        attachment.options = {}
    end
end

local function update_attachment(attachment)

    ENTITY.SET_ENTITY_VISIBLE(attachment.handle, attachment.is_visible, 0)
    ENTITY.SET_ENTITY_HAS_GRAVITY(attachment.handle, attachment.has_gravity)

    if attachment.parent.handle == attachment.handle then
        ENTITY.SET_ENTITY_ROTATION(attachment.handle, attachment.rotation.x or 0, attachment.rotation.y or 0, attachment.rotation.z or 0)
    else
        ENTITY.ATTACH_ENTITY_TO_ENTITY(
                attachment.handle, attachment.parent.handle, attachment.bone_index or 0,
                attachment.offset.x or 0, attachment.offset.y or 0, attachment.offset.z or 0,
                attachment.rotation.x or 0, attachment.rotation.y or 0, attachment.rotation.z or 0,
                false, true, attachment.has_collision, false, 2, true
        )
    end
end

local function load_hash_for_attachment(attachment)
    if not STREAMING.IS_MODEL_VALID(attachment.hash) then
        if not STREAMING.IS_MODEL_A_VEHICLE(attachment.hash) then
            error("Error attaching: Invalid model: " .. attachment.model)
        end
        attachment.type = "VEHICLE"
    end
    load_hash(attachment.hash)
end

local function build_parent_child_relationship(parent_attachment, child_attachment)
    child_attachment.parent = parent_attachment
    child_attachment.root = parent_attachment.root
end

local function attach_attachment(attachment)
    set_attachment_defaults(attachment)
    load_hash_for_attachment(attachment)

    if attachment.root == nil then
        error("Attachment missing root")
    end

    if attachment.type == "VEHICLE" then
        local heading = ENTITY.GET_ENTITY_HEADING(attachment.root.handle)
        attachment.handle = entities.create_vehicle(attachment.hash, attachment.offset, heading)
    elseif attachment.type == "PED" then
        local pos = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(attachment.parent.handle, attachment.offset.x, attachment.offset.y, attachment.offset.z)
        attachment.handle = entities.create_ped(1, attachment.hash, pos, 0.0)
        if attachment.parent.type == "VEHICLE" then
            PED.SET_PED_INTO_VEHICLE(attachment.handle, attachment.parent.handle, -1)
        end
    else
        local pos = ENTITY.GET_ENTITY_COORDS(attachment.root.handle)
        attachment.handle = OBJECT.CREATE_OBJECT_NO_OFFSET(attachment.hash, pos.x, pos.y, pos.z, true, true, false)
        --args.handle = entities.create_object(hash, ENTITY.GET_ENTITY_COORDS(args.root.handle))
    end

    if not attachment.handle then
        error("Error attaching attachment. Could not create handle.")
    end

    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(attachment.hash)

    if attachment.flash_start_on ~= nil then
        ENTITY.SET_ENTITY_VISIBLE(attachment.handle, attachment.flash_start_on, 0)
    end

    ENTITY.SET_ENTITY_INVINCIBLE(attachment.handle, false)

    update_attachment(attachment)
    set_attachment_internal_collisions(attachment.root, attachment)

    return attachment
end

local function update_reflection_offsets(reflection)
    --- This function isn't quite right, it breaks with certain root rotations, but close enough for now
    reflection.offset = { x = 0, y = 0, z = 0 }
    reflection.rotation = { x = 0, y = 0, z = 0 }
    if reflection.reflection_axis.x then
        reflection.offset.x = reflection.parent.offset.x * -2
    end
    if reflection.reflection_axis.y then
        reflection.offset.y = reflection.parent.offset.y * -2
    end
    if reflection.reflection_axis.z then
        reflection.offset.z = reflection.parent.offset.z * -2
    end
end

local function move_attachment(attachment)
    if attachment.reflection then
        update_reflection_offsets(attachment.reflection)
        update_attachment(attachment.reflection)
    end
    update_attachment(attachment)
end

local function detach_attachment(attachment)
    array_remove(attachment.children, function(t, i, j)
        local child_attachment = t[i]
        detach_attachment(child_attachment)
        return false
    end)
    if attachment ~= attachment.root then
        entities.delete_by_handle(attachment.handle)
    end
    if attachment.menus then
        for _, attachment_menu in pairs(attachment.menus) do
            -- Sometimes these menu handles are invalid but I don't know why,
            -- so wrap them in pcall to avoid errors if delete fails
            pcall(function() menu.delete(attachment_menu) end)
        end
    end
end

local function remove_attachment_from_parent(attachment)
    array_remove(attachment.parent.children, function(t, i, j)
        local child_attachment = t[i]
        if child_attachment.handle == attachment.handle then
            detach_attachment(attachment)
            return false
        end
        return true
    end)
end

local function reattach_attachment_with_children(attachment)
    if attachment.root ~= attachment then
        attach_attachment(attachment)
    end
    for _, child_attachment in pairs(attachment.children) do
        child_attachment.root = attachment.root
        child_attachment.parent = attachment
        reattach_attachment_with_children(child_attachment)
    end
end

local function attach_attachment_with_children(new_attachment)
    local attachment = attach_attachment(new_attachment)
    if attachment.children then
        for _, child_attachment in pairs(attachment.children) do
            build_parent_child_relationship(attachment, child_attachment)
            if child_attachment.flash_model then
                child_attachment.flash_start_on = (not child_attachment.parent.flash_start_on)
            end
            if child_attachment.reflection_axis then
                update_reflection_offsets(child_attachment)
            end
            attach_attachment_with_children(child_attachment)
        end
    end
    return attachment
end

local function add_attachment_to_construct(attachment)
    attach_attachment_with_children(attachment)
    table.insert(attachment.parent.children, attachment)
    attachment.root.menus.refresh()
    if attachment.root.menus.focus_menu then
        menu.focus(attachment.root.menus.focus_menu)
    end
end

local function clone_attachment(attachment)
    return {
        root = attachment.root,
        parent = attachment.parent,
        name = attachment.name,
        model = attachment.model,
        type = attachment.type,
        offset = table.table_copy(attachment.offset),
        rotation = table.table_copy(attachment.rotation),
    }
end

local function create_construct_from_vehicle(vehicle_handle)
    for _, construct in pairs(spawned_constructs) do
        if construct.handle == vehicle_handle then
            util.toast("Vehicle is already a construct")
            menu.focus(construct.menus.focus_menu)
            return
        end
    end
    local construct = table.table_copy(construct_base)
    construct.type = "VEHICLE"
    construct.handle = vehicle_handle
    construct.root = construct
    construct.hash = ENTITY.GET_ENTITY_MODEL(vehicle_handle)
    construct.model = VEHICLE.GET_DISPLAY_NAME_FROM_VEHICLE_MODEL(construct.hash)
    construct.name = construct.model
    table.insert(spawned_constructs, construct)
    last_spawned_construct = construct
    return construct
end

---
--- Serializers
---

local function serialize_vehicle_attributes(vehicle)
    if vehicle.type ~= "VEHICLE" then return end
    local serialized_vehicle = {}

    serialize_vehicle_paint(vehicle, serialized_vehicle)
    serialize_vehicle_neon(vehicle, serialized_vehicle)
    serialize_vehicle_wheels(vehicle, serialized_vehicle)
    serialize_vehicle_headlights(vehicle, serialized_vehicle)
    serialize_vehicle_options(vehicle, serialized_vehicle)
    serialize_vehicle_mods(vehicle, serialized_vehicle)
    serialize_vehicle_extras(vehicle, serialized_vehicle)

    return serialized_vehicle
end

local function deserialize_vehicle_attributes(vehicle)
    if vehicle.vehicle_attributes == nil then return end
    local serialized_vehicle = vehicle.vehicle_attributes

    VEHICLE.SET_VEHICLE_MOD_KIT(vehicle.handle, 0)

    deserialize_vehicle_neon(vehicle, serialized_vehicle)
    deserialize_vehicle_paint(vehicle, serialized_vehicle)
    deserialize_vehicle_wheels(vehicle, serialized_vehicle)
    deserialize_vehicle_headlights(vehicle, serialized_vehicle)
    deserialize_vehicle_options(vehicle, serialized_vehicle)
    deserialize_vehicle_mods(vehicle, serialized_vehicle)
    deserialize_vehicle_extras(vehicle, serialized_vehicle)

    ENTITY.SET_ENTITY_AS_MISSION_ENTITY(vehicle.handle, true, true)

end

local function serialize_attachment(attachment)
    local serialized_attachment = {
        children = {}
    }
    for k, v in pairs(attachment) do
        if not (k == "handle" or k == "root" or k == "parent" or k == "menus" or k == "children"
                or k == "base_name" or k == "rebuild_edit_attachments_menu_function") then
            serialized_attachment[k] = v
        end
    end
    serialized_attachment.vehicle_attributes = serialize_vehicle_attributes(attachment)
    for _, child_attachment in pairs(attachment.children) do
        table.insert(serialized_attachment.children, serialize_attachment(child_attachment))
    end
    --util.toast(inspect(serialized_attachment), TOAST_ALL)
    return serialized_attachment
end

local rebuild_saved_constructs_menu_function

local function save_vehicle(construct)
    local filepath = CONSTRUCTS_DIR .. construct.name .. ".construct.json"
    local file = io.open(filepath, "wb")
    if not file then error("Cannot write to file '" .. filepath .. "'", TOAST_ALL) end
    local content = json.encode(serialize_attachment(construct))
    if content == "" or (not string.starts(content, "{")) then
        util.toast("Cannot save vehicle: Error serializing.", TOAST_ALL)
        return
    end
    --util.toast(content, TOAST_ALL)
    file:write(content)
    file:close()
    util.toast("Saved ".. construct.name)
    rebuild_saved_constructs_menu_function()
end

local function spawn_loaded_construct(loaded_vehicle)
    -- TODO: Handle constructs other than vehicles
    loaded_vehicle.handle = spawn_vehicle_for_player(players.user(), loaded_vehicle.model)
    deserialize_vehicle_attributes(loaded_vehicle)
    loaded_vehicle.root = loaded_vehicle
    loaded_vehicle.parent = loaded_vehicle
    reattach_attachment_with_children(loaded_vehicle)
    table.insert(spawned_constructs, loaded_vehicle)
    last_spawned_construct = loaded_vehicle
    menus.refresh_loaded_constructs()
end

---
--- Dynamic Menus
---

local function rebuild_add_attachments_menu(attachment)
    if attachment.menus.add_attachment_categories ~= nil then
        return
    end
    attachment.menus.add_attachment_categories = {}

    for _, category in pairs(available_attachments) do
        local category_menu = menu.list(attachment.menus.add_attachment, category.name)
        for _, available_attachment in pairs(category.objects) do
            menu.action(category_menu, available_attachment.name, {}, "", function()
                local child_attachment = table.table_copy(available_attachment)
                child_attachment.root = attachment.root
                child_attachment.parent = attachment
                add_attachment_to_construct(child_attachment)
            end)
        end
        table.insert(attachment.menus.add_attachment_categories, category_menu)
    end

    menu.text_input(attachment.menus.add_attachment, "Object by Name", {"constructorattachobject"},
            "Add an in-game object by exact name. To search for objects try https://gta-objects.xyz/", function (value)
                add_attachment_to_construct({
                    root = attachment.root,
                    parent = attachment,
                    name = value,
                    model = value,
                })
            end)

    menu.text_input(attachment.menus.add_attachment, "Vehicle by Name", {"constructorattachvehicle"},
            "Add a vehicle by exact name.", function (value)
                add_attachment_to_construct({
                    root = attachment.root,
                    parent = attachment,
                    name = value,
                    model = value,
                    type = "VEHICLE",
                })
            end)

    menu.toggle(attachment.menus.add_attachment, "Add Attachment Gun", {}, "Anything you shoot with this enabled will be added to the current construct", function(on)
        config.add_attachment_gun_active = on
    end, config.add_attachment_gun_active)

end

local function rebuild_edit_attachments_menu(parent_attachment)
    parent_attachment.menus.focus_menu = nil
    for _, attachment in pairs(parent_attachment.children) do
        if not (attachment.menus and attachment.menus.main) then
            attachment.menus = {}
            attachment.menus.main = menu.list(attachment.parent.menus.edit_attachments, attachment.name or "unknown")

            menu.divider(attachment.menus.main, "Info")
            menu.readonly(attachment.menus.main, "Handle", attachment.handle)
            attachment.menus.name = menu.text_input(attachment.menus.main, "Name", { "constructorsetattachmentname"..attachment.handle}, "Set name of the attachment", function(value)
                attachment.name = value
                attachment.menus.refresh()
            end, attachment.name)

            menu.divider(attachment.menus.main, "Position")
            local focus_menu = menu.slider_float(attachment.menus.main, "X: Left / Right", { "constructorposition"..attachment.handle.."x"}, "", -500000, 500000, math.floor(attachment.offset.x * 100), config.edit_offset_step, function(value)
                attachment.offset.x = value / 100
                move_attachment(attachment)
            end)
            menu.slider_float(attachment.menus.main, "Y: Forward / Back", {"constructorposition"..attachment.handle.."y"}, "", -500000, 500000, math.floor(attachment.offset.y * -100), config.edit_offset_step, function(value)
                attachment.offset.y = value / -100
                move_attachment(attachment)
            end)
            menu.slider_float(attachment.menus.main, "Z: Up / Down", {"constructorposition"..attachment.handle.."z"}, "", -500000, 500000, math.floor(attachment.offset.z * -100), config.edit_offset_step, function(value)
                attachment.offset.z = value / -100
                move_attachment(attachment)
            end)

            menu.divider(attachment.menus.main, "Rotation")
            menu.slider(attachment.menus.main, "X: Pitch", {"constructorrotate"..attachment.handle.."x"}, "", -179, 180, attachment.rotation.x, config.edit_rotation_step, function(value)
                attachment.rotation.x = value
                move_attachment(attachment)
            end)
            menu.slider(attachment.menus.main, "Y: Roll", {"constructorrotate"..attachment.handle.."y"}, "", -179, 180, attachment.rotation.y, config.edit_rotation_step, function(value)
                attachment.rotation.y = value
                move_attachment(attachment)
            end)
            menu.slider(attachment.menus.main, "Z: Yaw", {"constructorrotate"..attachment.handle.."z"}, "", -179, 180, attachment.rotation.z, config.edit_rotation_step, function(value)
                attachment.rotation.z = value
                move_attachment(attachment)
            end)

            menu.divider(attachment.menus.main, "Toggles")
            --local light_color = {r=0}
            --menu.slider(attachment.menu, "Color: Red", {}, "", 0, 255, light_color.r, 1, function(value)
            --    -- Only seems to work locally :(
            --    OBJECT._SET_OBJECT_LIGHT_COLOR(attachment.handle, 1, light_color.r, 0, 128)
            --end)
            menu.toggle(attachment.menus.main, "Is Visible", {}, "Will the attachment be visible, or invisible", function(on)
                attachment.is_visible = on
                update_attachment(attachment)
            end, attachment.is_visible)
            menu.toggle(attachment.menus.main, "Has Collision", {}, "Will the attachment collide with things, or pass through them", function(on)
                attachment.has_collision = on
                update_attachment(attachment)
            end, attachment.has_collision)
            menu.toggle(attachment.menus.main, "Has Gravity", {}, "Will the attachment be effected by gravity, or be weightless", function(on)
                attachment.has_gravity = on
                update_attachment(attachment)
            end, attachment.has_gravity)
            menu.toggle(attachment.menus.main, "Is Light Disabled", {}, "If attachment is a light, it will be ALWAYS off, regardless of siren settings.", function(on)
                attachment.is_light_disabled = on
                update_attachment(attachment)
            end, attachment.is_light_disabled)

            menu.divider(attachment.menus.main, "Attachments")
            attachment.menus.add_attachment = menu.list(attachment.menus.main, "Add Attachment", {}, "", function()
                rebuild_add_attachments_menu(attachment)
            end)
            attachment.menus.edit_attachments = menu.list(attachment.menus.main, "Edit Attachments ("..#attachment.children..")", {}, "", function()
                rebuild_edit_attachments_menu(attachment)
            end)
            attachment.rebuild_edit_attachments_menu_function = rebuild_edit_attachments_menu

            local clone_menu = menu.list(attachment.menus.main, "Clone")
            menu.action(clone_menu, "Clone (In Place)", {}, "", function()
                local new_attachment = clone_attachment(attachment)
                new_attachment.name = attachment.name .. " (Clone)"
                attach_attachment_with_children(new_attachment)
                attachment.rebuild_edit_attachments_menu_function(attachment.root)
                if attachment.root.menus.focus_menu then
                    menu.focus(attachment.root.menus.focus_menu)
                end
            end)

            menu.action(clone_menu, "Clone Reflection: Left/Right", {}, "", function()
                local new_attachment = clone_attachment(attachment)
                new_attachment.name = attachment.name .. " (Clone)"
                new_attachment.offset = {x=-attachment.offset.x, y=attachment.offset.y, z=attachment.offset.z}
                attach_attachment_with_children(new_attachment)
                attachment.rebuild_edit_attachments_menu_function(attachment.root)
                if attachment.root.menus.focus_menu then
                    menu.focus(attachment.root.menus.focus_menu)
                end
            end)

            menu.divider(attachment.menus.main, "Actions")
            if attachment.type == "VEHICLE" then
                menu.action(attachment.menus.main, "Enter Drivers Seat", {}, "", function()
                    PED.SET_PED_INTO_VEHICLE(PLAYER.PLAYER_PED_ID(), attachment.handle, -1)
                end)
            end
            menu.action(attachment.menus.main, "Delete", {}, "", function()
                menu.show_warning(attachment.menus.main, CLICK_COMMAND, "Are you sure you want to delete this attachment? All children will also be deleted.", function()
                    remove_attachment_from_parent(attachment)
                    menu.focus(attachment.parent.menus.edit_attachments)
                end)
            end)

            attachment.menus.refresh = function()
                menu.set_menu_name(attachment.menus.main, attachment.name)
                menu.set_menu_name(attachment.menus.edit_attachments, "Edit Attachments ("..#attachment.children..")")
            end

            if parent_attachment.menus.focus_menu == nil then
                parent_attachment.menus.focus_menu = focus_menu
            end
        end
        rebuild_edit_attachments_menu(attachment)
        if parent_attachment.menus.focus_menu == nil and attachment.menus.focus_menu ~= nil then
            util.toast("setting focus menu from child")
            parent_attachment.menus.focus_menu = attachment.menus.focus_menu
        end
    end
end

local function rebuild_spawned_constructs_menu(construct)
    if construct.menus == nil then
        construct.menus = {}
        construct.menus.main = menu.list(menus.loaded_constructs, construct.name)

        menu.divider(construct.menus.main, "Construct")
        construct.menus.name = menu.text_input(construct.menus.main, "Name", { "constructsetname"}, "Set name of the construct", function(value)
            construct.name = value
            construct.menus.refresh()
        end, construct.name)

        --menu.toggle_loop(options_menu, "Engine Always On", {}, "If enabled, vehicle engine will stay on even when unoccupied", function()
        --    VEHICLE.SET_VEHICLE_ENGINE_ON(construct.handle, true, true, true)
        --end)

        menu.divider(construct.menus.main, "Attachments")
        construct.menus.add_attachment = menu.list(construct.menus.main, "Add Attachment", {}, "", function()
            rebuild_add_attachments_menu(construct)
        end)
        construct.menus.edit_attachments = menu.list(construct.menus.main, "Edit Attachments ("..#construct.children..")", {}, "", function()
            rebuild_edit_attachments_menu(construct)
        end)
        construct.rebuild_edit_attachments_menu_function = rebuild_edit_attachments_menu
        rebuild_add_attachments_menu(construct)

        menu.divider(construct.menus.main, "Actions")
        menu.action(construct.menus.main, "Enter Drivers Seat", {}, "", function()
            PED.SET_PED_INTO_VEHICLE(PLAYER.PLAYER_PED_ID(), construct.handle, -1)
        end)
        menu.action(construct.menus.main, "Save Construct", {}, "Save this construct so it can be retrieved in the future", function()
            save_vehicle(construct)
        end)

        construct.menus.delete_vehicle = menu.action(construct.menus.main, "Delete", {}, "Delete construct and all attachments", function()
            menu.show_warning(construct.menus.delete_vehicle, CLICK_COMMAND, "Are you sure you want to delete this construct? All attachments will also be deleted.", function()
                detach_attachment(construct)
                entities.delete_by_handle(construct.handle)
                menu.trigger_commands("luaconstructor")
            end)
        end)

        construct.menus.refresh = function()
            menu.set_menu_name(construct.menus.main, construct.name)
            menu.set_menu_name(construct.menus.edit_attachments, "Edit Attachments ("..#construct.children..")")
            rebuild_edit_attachments_menu(construct)
        end
        construct.menus.spawn_focus = construct.menus.name
    end
end

---
--- Static Menus
---

menus.create_new_construct = menu.list(menu.my_root(), "Create New Construct")

menu.action(menus.create_new_construct, "Create from current vehicle", { "constructfromvehicle" }, "Create a new construct based on current (or last in) vehicle", function()
    local vehicle = entities.get_user_vehicle_as_handle()
    if vehicle == 0 then
        util.toast("Error: You must be (or recently been) in a vehicle to create a construct from it")
        return
    end
    local construct = create_construct_from_vehicle(vehicle)
    if construct then
        rebuild_spawned_constructs_menu(construct)
        rebuild_edit_attachments_menu(construct)
        menu.focus(construct.menus.spawn_focus)
    end
end)

menu.text_input(menus.create_new_construct, "Create from vehicle name", { "constructfromvehiclename"}, "Create a new construct from a vehicle name", function(value)
    local vehicle_handle = spawn_vehicle_for_player(players.user(), value)
    if vehicle_handle == 0 then
        util.toast("Error: You must be (or recently been) in a vehicle to create a construct from it")
        return
    end
    local construct = create_construct_from_vehicle(vehicle_handle)
    if construct then
        rebuild_spawned_constructs_menu(construct)
        rebuild_edit_attachments_menu(construct)
        menu.focus(construct.menus.spawn_focus)
    end
end)

---
--- Saved Constructs Menu
---

menus.load_construct = menu.list(menu.my_root(), "Load Construct")

menu.hyperlink(menus.load_construct, "Open Constructs Folder", "file:///"..CONSTRUCTS_DIR, "Open constructs folder. Share your creations or add new creations here.")

local function load_construct_from_file(filepath)
    local file = io.open(filepath, "r")
    if file then
        local status, data = pcall(function() return json.decode(file:read("*a")) end)
        if not status then
            util.toast("Invalid construct file format. "..filepath, TOAST_ALL)
            return
        end
        if not data.target_version then
            util.toast("Invalid construct file format. Missing target_version. "..filepath, TOAST_ALL)
            return
        end
        file:close()
        return data
    else
        error("Could not read file '" .. filepath .. "'", TOAST_ALL)
    end
end

local function load_constructs_from_dir(directory)
    local loaded_constructs = {}
    for _, filepath in ipairs(filesystem.list_files(directory)) do
        local _, filename, ext = string.match(filepath, "(.-)([^\\/]-%.?([^%.\\/]*))$")
        if not filesystem.is_dir(filepath) and ext == "json" then
            local loaded_construct = load_construct_from_file(filepath)
            if loaded_construct then
                table.insert(loaded_constructs, loaded_construct)
            end
        end
    end
    return loaded_constructs
end

menus.loaded_constructs_items = {}
rebuild_saved_constructs_menu_function = function()
    for _, loaded_construct_menu in pairs(menus.loaded_constructs_items) do
        menu.delete(loaded_construct_menu)
    end
    menus.loaded_constructs_items = {}
    for _, loaded_construct in pairs(load_constructs_from_dir(CONSTRUCTS_DIR)) do
        local loaded_construct_menu = menu.action(menus.load_construct, loaded_construct.name, {}, "", function()
            local spawn_construct = table.table_copy(loaded_construct)
            spawn_loaded_construct(spawn_construct)
            rebuild_spawned_constructs_menu(spawn_construct)
            rebuild_edit_attachments_menu(spawn_construct)
            menu.focus(spawn_construct.menus.spawn_focus)
        end)
        table.insert(menus.loaded_constructs_items, loaded_construct_menu)
    end
end

rebuild_saved_constructs_menu_function()

menus.loaded_constructs = menu.list(menu.my_root(), "Loaded Constructs ("..#spawned_constructs..")")

menus.refresh_loaded_constructs = function()
    menu.set_menu_name(menus.loaded_constructs, "Loaded Constructs ("..#spawned_constructs..")")
end

local options_menu = menu.list(menu.my_root(), "Options")

menu.divider(options_menu, "Global Configs")

menu.slider(options_menu, "Edit Offset Step", {}, "The amount of change each time you edit an attachment offset", 1, 20, config.edit_offset_step, 1, function(value)
    config.edit_offset_step = value
end)
menu.slider(options_menu, "Edit Rotation Step", {}, "The amount of change each time you edit an attachment rotation", 1, 15, config.edit_rotation_step, 1, function(value)
    config.edit_rotation_step = value
end)

local script_meta_menu = menu.list(menu.my_root(), "Script Meta")

menu.divider(script_meta_menu, "Constructor")
menu.readonly(script_meta_menu, "Version", SCRIPT_VERSION)
menu.list_select(script_meta_menu, "Release Branch", {}, "Switch from main to dev to get cutting edge updates, but also potentially more bugs.", AUTO_UPDATE_BRANCHES, SELECTED_BRANCH_INDEX, function(index, menu_name, previous_option, click_type)
    if click_type ~= 0 then return end
    auto_update_branch(AUTO_UPDATE_BRANCHES[index][1])
end)
menu.hyperlink(script_meta_menu, "Github Source", "https://github.com/hexarobi/stand-lua-constructor", "View source files on Github")
menu.hyperlink(script_meta_menu, "Discord", "https://discord.gg/RF4N7cKz", "Open Discord Server")
menu.divider(script_meta_menu, "Credits")
menu.readonly(script_meta_menu, "Jackz for writing Vehicle Builder", "Much of Constructor is based on code from Jackz Vehicle Builder and wouldn't have been possible without this foundation")

local function get_aim_info()
    local outptr = memory.alloc(4)
    local success = PLAYER.GET_ENTITY_PLAYER_IS_FREE_AIMING_AT(players.user(), outptr)
    local aim_info = {handle=0}
    if success then
        local handle = memory.read_int(outptr)
        if ENTITY.DOES_ENTITY_EXIST(handle) then
            aim_info.handle = handle
        end
        if ENTITY.GET_ENTITY_TYPE(handle) == 1 then
            local vehicle = PED.GET_VEHICLE_PED_IS_IN(handle, false)
            if vehicle ~= 0 then
                if VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1) then
                    handle = vehicle
                    aim_info.handle = handle
                end
            end
        end
        aim_info.hash = ENTITY.GET_ENTITY_MODEL(handle)
        aim_info.model = util.reverse_joaat(aim_info.hash)
        aim_info.health = ENTITY.GET_ENTITY_HEALTH(handle)
        aim_info.type = ENTITY_TYPES[ENTITY.GET_ENTITY_TYPE(handle)]
    end
    memory.free(outptr)
    return aim_info
end

local function constructor_tick()
    if config.add_attachment_gun_active then
        local info = get_aim_info()
        if info.handle ~= 0 then
            local text = "Shoot to add " .. info.type .. " `" .. info.model .. "` to construct " .. last_spawned_construct.name
            directx.draw_text(0.5, 0.3, text, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
            if PED.IS_PED_SHOOTING(players.user_ped()) then
                util.toast("Attaching "..info.model)
                add_attachment_to_construct({
                    parent=last_spawned_construct,
                    root=last_spawned_construct,
                    hash=info.hash,
                    model=info.model,
                })
            end
        end
    end
end

util.create_tick_handler(function()
    constructor_tick()
    return true
end)
