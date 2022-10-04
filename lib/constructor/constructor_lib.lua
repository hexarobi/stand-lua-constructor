-- Constructor Lib
-- by Hexarobi
-- A Lua Script for the Stand mod menu for GTA5
-- Allows for constructing custom vehicles and maps
-- https://github.com/hexarobi/stand-lua-constructor

local LIB_VERSION = "3.21.2"

local constructor_lib = {
    LIB_VERSION = LIB_VERSION,
    debug = false
}

---
--- Dependencies
---

local status_inspect, inspect = pcall(require, "inspect")
if not status_inspect then error("Could not load inspect lib. This should have been auto-installed.") end

local status_xml2lua, xml2lua = pcall(require, "constructor/xml2lua")
if not status_xml2lua then error("Could not load xml2lua lib. This should have been auto-installed.") end

---
--- Data
---

local ENTITY_TYPES = {"PED", "VEHICLE", "OBJECT"}

constructor_lib.construct_base = {
    target_version = LIB_VERSION,
    children = {},
    options = {},
    position = {x=0,y=0,z=0},
    offset = {x=0,y=0,z=0},
    rotation = {x=0,y=0,z=0},
    world_rotation = {x=0,y=0,z=0},
    num_bones = 100,
    heading = 0,
}

---
--- Utilities
---

local function debug_log(message, additional_details)
    if constructor_lib.debug then
        if constructor_lib.debug == 2 and additional_details ~= nil then
            message = message .. "\n" .. inspect(additional_details)
        end
        util.log(message)
    end
end

util.require_natives(1663599433)

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
function table.array_remove(t, fnKeep)
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

local function toboolean(value)
    return (value == true or value == "true")
end

constructor_lib.load_hash = function(hash)
    STREAMING.REQUEST_MODEL(hash)
    while not STREAMING.HAS_MODEL_LOADED(hash) do
        util.yield()
    end
end

constructor_lib.spawn_vehicle_for_player = function(pid, model_name)
    local model = util.joaat(model_name)
    if not STREAMING.IS_MODEL_VALID(model) or not STREAMING.IS_MODEL_A_VEHICLE(model) then
        util.toast("Error: Invalid vehicle name")
        return
    else
        constructor_lib.load_hash(model)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(target_ped, 0.0, 4.0, 0.5)
        local heading = ENTITY.GET_ENTITY_HEADING(target_ped)
        local vehicle = entities.create_vehicle(model, pos, heading)
        STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(model)
        return vehicle
    end
end


---
--- Draw Utils
---


local minimum = memory.alloc()
local maximum = memory.alloc()
local upVector_pointer = memory.alloc()
local rightVector_pointer = memory.alloc()
local forwardVector_pointer = memory.alloc()
local position_pointer = memory.alloc()

-- From GridSpawn
constructor_lib.draw_bounding_box = function(entity, colour)
    if colour == nil then
        colour = {r=255,g=0,b=0,a=255}
    end

    MISC.GET_MODEL_DIMENSIONS(ENTITY.GET_ENTITY_MODEL(entity), minimum, maximum)
    local minimum_vec = v3.new(minimum)
    local maximum_vec = v3.new(maximum)
    constructor_lib.draw_bounding_box_with_dimensions(entity, colour, minimum_vec, maximum_vec)
end

constructor_lib.draw_bounding_box_with_dimensions = function(entity, colour, minimum_vec, maximum_vec)

    local dimensions = {x = maximum_vec.y - minimum_vec.y, y = maximum_vec.x - minimum_vec.x, z = maximum_vec.z - minimum_vec.z}

    ENTITY.GET_ENTITY_MATRIX(entity, rightVector_pointer, forwardVector_pointer, upVector_pointer, position_pointer);
    local forward_vector = v3.new(forwardVector_pointer)
    local right_vector = v3.new(rightVector_pointer)
    local up_vector = v3.new(upVector_pointer)

    local top_right =           ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(entity,       maximum_vec.x, maximum_vec.y, maximum_vec.z)
    local top_right_back =      {x = forward_vector.x * -dimensions.y + top_right.x,        y = forward_vector.y * -dimensions.y + top_right.y,         z = forward_vector.z * -dimensions.y + top_right.z}
    local bottom_right_back =   {x = up_vector.x * -dimensions.z + top_right_back.x,        y = up_vector.y * -dimensions.z + top_right_back.y,         z = up_vector.z * -dimensions.z + top_right_back.z}
    local bottom_left_back =    {x = -right_vector.x * dimensions.x + bottom_right_back.x,  y = -right_vector.y * dimensions.x + bottom_right_back.y,   z = -right_vector.z * dimensions.x + bottom_right_back.z}
    local top_left =            {x = -right_vector.x * dimensions.x + top_right.x,          y = -right_vector.y * dimensions.x + top_right.y,           z = -right_vector.z * dimensions.x + top_right.z}
    local bottom_right =        {x = -up_vector.x * dimensions.z + top_right.x,             y = -up_vector.y * dimensions.z + top_right.y,              z = -up_vector.z * dimensions.z + top_right.z}
    local bottom_left =         {x = forward_vector.x * dimensions.y + bottom_left_back.x,  y = forward_vector.y * dimensions.y + bottom_left_back.y,   z = forward_vector.z * dimensions.y + bottom_left_back.z}
    local top_left_back =       {x = up_vector.x * dimensions.z + bottom_left_back.x,       y = up_vector.y * dimensions.z + bottom_left_back.y,        z = up_vector.z * dimensions.z + bottom_left_back.z}

    GRAPHICS.DRAW_LINE(
            top_right.x, top_right.y, top_right.z,
            top_right_back.x, top_right_back.y, top_right_back.z,
            colour.r, colour.g, colour.b, colour.a
    )
    GRAPHICS.DRAW_LINE(
            top_right.x, top_right.y, top_right.z,
            top_left.x, top_left.y, top_left.z,
            colour.r, colour.g, colour.b, colour.a
    )
    GRAPHICS.DRAW_LINE(
            top_right.x, top_right.y, top_right.z,
            bottom_right.x, bottom_right.y, bottom_right.z,
            colour.r, colour.g, colour.b, colour.a
    )
    GRAPHICS.DRAW_LINE(
            bottom_left_back.x, bottom_left_back.y, bottom_left_back.z,
            bottom_right_back.x, bottom_right_back.y, bottom_right_back.z,
            colour.r, colour.g, colour.b, colour.a
    )
    GRAPHICS.DRAW_LINE(
            bottom_left_back.x, bottom_left_back.y, bottom_left_back.z,
            bottom_left.x, bottom_left.y, bottom_left.z,
            colour.r, colour.g, colour.b, colour.a
    )
    GRAPHICS.DRAW_LINE(
            bottom_left_back.x, bottom_left_back.y, bottom_left_back.z,
            top_left_back.x, top_left_back.y, top_left_back.z,
            colour.r, colour.g, colour.b, colour.a
    )
    GRAPHICS.DRAW_LINE(
            top_left_back.x, top_left_back.y, top_left_back.z,
            top_right_back.x, top_right_back.y, top_right_back.z,
            colour.r, colour.g, colour.b, colour.a
    )
    GRAPHICS.DRAW_LINE(
            top_left_back.x, top_left_back.y, top_left_back.z,
            top_left.x, top_left.y, top_left.z,
            colour.r, colour.g, colour.b, colour.a
    )
    GRAPHICS.DRAW_LINE(
            bottom_right_back.x, bottom_right_back.y, bottom_right_back.z,
            top_right_back.x, top_right_back.y, top_right_back.z,
            colour.r, colour.g, colour.b, colour.a
    )
    GRAPHICS.DRAW_LINE(
            bottom_left.x, bottom_left.y, bottom_left.z,
            top_left.x, top_left.y, top_left.z,
            colour.r, colour.g, colour.b, colour.a
    )
    GRAPHICS.DRAW_LINE(
            bottom_left.x, bottom_left.y, bottom_left.z,
            bottom_right.x, bottom_right.y, bottom_right.z,
            colour.r, colour.g, colour.b, colour.a
    )
    GRAPHICS.DRAW_LINE(
            bottom_right_back.x, bottom_right_back.y, bottom_right_back.z,
            bottom_right.x, bottom_right.y, bottom_right.z,
            colour.r, colour.g, colour.b, colour.a
    )
end


---
--- Specific Serializers
---

constructor_lib.serialize_vehicle_headlights = function(vehicle, serialized_vehicle)
    if serialized_vehicle.headlights == nil then serialized_vehicle.headlights = {} end
    serialized_vehicle.headlights.headlights_color = VEHICLE.GET_VEHICLE_XENON_LIGHT_COLOR_INDEX(vehicle.handle)
    serialized_vehicle.headlights.headlights_type = VEHICLE.IS_TOGGLE_MOD_ON(vehicle.handle, 22)
    return serialized_vehicle
end

constructor_lib.deserialize_vehicle_headlights = function(vehicle, serialized_vehicle)
    if serialized_vehicle.headlights == nil then return end
    VEHICLE.SET_VEHICLE_XENON_LIGHT_COLOR_INDEX(vehicle.handle, serialized_vehicle.headlights.headlights_color)
    VEHICLE.TOGGLE_VEHICLE_MOD(vehicle.handle, 22, serialized_vehicle.headlights.headlights_type or false)
    VEHICLE.SET_VEHICLE_LIGHT_MULTIPLIER(vehicle.handle, serialized_vehicle.headlights.multiplier or 1)
end

constructor_lib.serialize_vehicle_paint = function(vehicle, serialized_vehicle)
    if serialized_vehicle.paint == nil then
        serialized_vehicle.paint = {
            primary = {},
            secondary = {},
        }
    end

    -- Create pointers to hold color values
    local color = { r = memory.alloc(8), g = memory.alloc(8), b = memory.alloc(8) }

    VEHICLE.GET_VEHICLE_COLOR(vehicle.handle, color.r, color.g, color.b)
    serialized_vehicle.paint.vehicle_custom_color = { r = memory.read_int(color.r), g = memory.read_int(color.g), b = memory.read_int(color.b) }
    VEHICLE.GET_VEHICLE_COLOURS(vehicle.handle, color.r, color.g)
    serialized_vehicle.paint.primary.vehicle_standard_color = memory.read_int(color.r)
    serialized_vehicle.paint.secondary.vehicle_standard_color = memory.read_int(color.g)

    serialized_vehicle.paint.primary.is_custom = VEHICLE.GET_IS_VEHICLE_PRIMARY_COLOUR_CUSTOM(vehicle.handle)
    if serialized_vehicle.paint.primary.is_custom then
        VEHICLE.GET_VEHICLE_CUSTOM_PRIMARY_COLOUR(vehicle.handle, color.r, color.g, color.b)
        serialized_vehicle.paint.primary.custom_color = { r = memory.read_int(color.r), g = memory.read_int(color.g), b = memory.read_int(color.b) }
    else
        VEHICLE.GET_VEHICLE_MOD_COLOR_1(vehicle.handle, color.r, color.g, color.b)
        serialized_vehicle.paint.primary.paint_type = memory.read_int(color.r)
        serialized_vehicle.paint.primary.color = memory.read_int(color.g)
        serialized_vehicle.paint.primary.pearlescent_color = memory.read_int(color.b)
    end

    serialized_vehicle.paint.secondary.is_custom = VEHICLE.GET_IS_VEHICLE_SECONDARY_COLOUR_CUSTOM(vehicle.handle)
    if serialized_vehicle.paint.secondary.is_custom then
        VEHICLE.GET_VEHICLE_CUSTOM_SECONDARY_COLOUR(vehicle.handle, color.r, color.g, color.b)
        serialized_vehicle.paint.secondary.custom_color = { r = memory.read_int(color.r), g = memory.read_int(color.g), b = memory.read_int(color.b) }
    else
        VEHICLE.GET_VEHICLE_MOD_COLOR_2(vehicle.handle, color.r, color.g)
        serialized_vehicle.paint.secondary.paint_type = memory.read_int(color.r)
        serialized_vehicle.paint.secondary.color = memory.read_int(color.g)
    end

    VEHICLE.GET_VEHICLE_EXTRA_COLOURS(vehicle.handle, color.r, color.g)
    serialized_vehicle.paint.extra_colors = { pearlescent = memory.read_int(color.r), wheel = memory.read_int(color.g) }
    VEHICLE.GET_VEHICLE_EXTRA_COLOUR_6(vehicle.handle, color.r)
    serialized_vehicle.paint.dashboard_color = memory.read_int(color.r)
    VEHICLE.SET_VEHICLE_EXTRA_COLOUR_5(vehicle.handle, color.r)
    serialized_vehicle.paint.interior_color = memory.read_int(color.r)
    serialized_vehicle.paint.fade = VEHICLE.GET_VEHICLE_ENVEFF_SCALE(vehicle.handle)
    serialized_vehicle.paint.dirt_level = VEHICLE.GET_VEHICLE_DIRT_LEVEL(vehicle.handle)
    serialized_vehicle.paint.color_combo = VEHICLE.GET_VEHICLE_COLOUR_COMBINATION(vehicle.handle)

    -- Livery is also part of mods, but capture it here as well for when just saving paint
    serialized_vehicle.paint.livery = VEHICLE.GET_VEHICLE_MOD(vehicle.handle, 48)
    serialized_vehicle.paint.livery_legacy = VEHICLE.GET_VEHICLE_LIVERY(vehicle.handle)
    serialized_vehicle.paint.livery2_legacy = VEHICLE.GET_VEHICLE_LIVERY2(vehicle.handle)

    memory.free(color.r) memory.free(color.g) memory.free(color.b)
end

constructor_lib.deserialize_vehicle_paint = function(vehicle, serialized_vehicle)
    if serialized_vehicle.paint == nil then return end

    VEHICLE.SET_VEHICLE_MOD_KIT(vehicle.handle, 0)
    VEHICLE.SET_VEHICLE_COLOUR_COMBINATION(vehicle.handle, serialized_vehicle.paint.color_combo or -1)

    if serialized_vehicle.paint.vehicle_custom_color then
        VEHICLE.SET_VEHICLE_CUSTOM_PRIMARY_COLOUR(
                vehicle.handle,
                serialized_vehicle.paint.vehicle_custom_color.r,
                serialized_vehicle.paint.vehicle_custom_color.g,
                serialized_vehicle.paint.vehicle_custom_color.b
        )
        VEHICLE.SET_VEHICLE_CUSTOM_SECONDARY_COLOUR(
                vehicle.handle,
                serialized_vehicle.paint.vehicle_custom_color.r,
                serialized_vehicle.paint.vehicle_custom_color.g,
                serialized_vehicle.paint.vehicle_custom_color.b
        )
    end

    if serialized_vehicle.paint.primary.vehicle_standard_color ~= nil or serialized_vehicle.paint.secondary.vehicle_standard_color ~= nil then
        VEHICLE.SET_VEHICLE_COLOURS(
            vehicle.handle,
            serialized_vehicle.paint.primary.vehicle_standard_color,
            serialized_vehicle.paint.secondary.vehicle_standard_color
        )
    end

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
    end

    if serialized_vehicle.paint.primary.paint_type then
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
    end
    if serialized_vehicle.paint.secondary.paint_type then
        VEHICLE.SET_VEHICLE_MOD_COLOR_2(
                vehicle.handle,
                serialized_vehicle.paint.secondary.paint_type,
                serialized_vehicle.paint.secondary.color
        )
    end

    VEHICLE.SET_VEHICLE_XENON_LIGHT_COLOR_INDEX(vehicle.handle, serialized_vehicle.headlights_color)
    VEHICLE.SET_VEHICLE_EXTRA_COLOUR_6(vehicle.handle, serialized_vehicle.paint.dashboard_color or -1)
    VEHICLE.SET_VEHICLE_EXTRA_COLOUR_5(vehicle.handle, serialized_vehicle.paint.interior_color or -1)

    VEHICLE.SET_VEHICLE_ENVEFF_SCALE(vehicle.handle, serialized_vehicle.paint.fade or 0)
    VEHICLE.SET_VEHICLE_DIRT_LEVEL(vehicle.handle, serialized_vehicle.paint.dirt_level or 0.0)
    VEHICLE.SET_VEHICLE_MOD(vehicle.handle, 48, serialized_vehicle.paint.livery or -1)

    VEHICLE.SET_VEHICLE_MOD(vehicle.handle, serialized_vehicle.paint.livery or -1)
    VEHICLE.SET_VEHICLE_LIVERY(vehicle.handle, serialized_vehicle.paint.livery_legacy or -1)
    VEHICLE.SET_VEHICLE_LIVERY2(vehicle.handle, serialized_vehicle.paint.livery2_legacy or -1)
end

constructor_lib.serialize_vehicle_neon = function(vehicle, serialized_vehicle)
    if serialized_vehicle.neon == nil then serialized_vehicle.neon = {} end
    serialized_vehicle.neon.lights = {
        left = VEHICLE.GET_VEHICLE_NEON_ENABLED(vehicle.handle, 0),
        right = VEHICLE.GET_VEHICLE_NEON_ENABLED(vehicle.handle, 1),
        front = VEHICLE.GET_VEHICLE_NEON_ENABLED(vehicle.handle, 2),
        back = VEHICLE.GET_VEHICLE_NEON_ENABLED(vehicle.handle, 3),
    }
    local color = { r = memory.alloc(8), g = memory.alloc(8), b = memory.alloc(8) }
    if (serialized_vehicle.neon.lights.left or serialized_vehicle.neon.lights.right
            or serialized_vehicle.neon.lights.front or serialized_vehicle.neon.lights.back) then
        VEHICLE.GET_VEHICLE_NEON_COLOUR(vehicle.handle, color.r, color.g, color.b)
        serialized_vehicle.neon.color = { r = memory.read_int(color.r), g = memory.read_int(color.g), b = memory.read_int(color.b) }
    end
    memory.free(color.r) memory.free(color.g) memory.free(color.b)
end

constructor_lib.deserialize_vehicle_neon = function(vehicle, serialized_vehicle)
    if serialized_vehicle.neon == nil then return end
    VEHICLE.SET_VEHICLE_NEON_ENABLED(vehicle.handle, 0, serialized_vehicle.neon.lights.left or false)
    VEHICLE.SET_VEHICLE_NEON_ENABLED(vehicle.handle, 1, serialized_vehicle.neon.lights.right or false)
    VEHICLE.SET_VEHICLE_NEON_ENABLED(vehicle.handle, 2, serialized_vehicle.neon.lights.front or false)
    VEHICLE.SET_VEHICLE_NEON_ENABLED(vehicle.handle, 3, serialized_vehicle.neon.lights.back or false)
    if serialized_vehicle.neon.color then
        VEHICLE.SET_VEHICLE_NEON_COLOUR(
                vehicle.handle,
                serialized_vehicle.neon.color.r,
                serialized_vehicle.neon.color.g,
                serialized_vehicle.neon.color.b
        )
    end
end

constructor_lib.serialize_vehicle_wheels = function(vehicle, serialized_vehicle)
    if serialized_vehicle.wheels == nil then serialized_vehicle.wheels = {} end
    serialized_vehicle.wheels.wheel_type = VEHICLE.GET_VEHICLE_WHEEL_TYPE(vehicle.handle)
    local color = { r = memory.alloc(8), g = memory.alloc(8), b = memory.alloc(8) }
    VEHICLE.GET_VEHICLE_TYRE_SMOKE_COLOR(vehicle.handle, color.r, color.g, color.b)
    serialized_vehicle.wheels.tire_smoke_color = { r = memory.read_int(color.r), g = memory.read_int(color.g), b = memory.read_int(color.b) }
    memory.free(color.r) memory.free(color.g) memory.free(color.b)
end

constructor_lib.deserialize_vehicle_wheels = function(vehicle, serialized_vehicle)
    if serialized_vehicle.wheels == nil then return end
    VEHICLE.SET_VEHICLE_TYRES_CAN_BURST(vehicle.handle, serialized_vehicle.wheels.bulletproof_tires or false)
    VEHICLE.SET_VEHICLE_WHEEL_TYPE(vehicle.handle, serialized_vehicle.wheels.wheel_type or -1)
    if serialized_vehicle.wheels.tire_smoke_color then
        VEHICLE.SET_VEHICLE_TYRE_SMOKE_COLOR(vehicle.handle, serialized_vehicle.wheels.tire_smoke_color.r or 255,
                serialized_vehicle.wheels.tire_smoke_color.g or 255, serialized_vehicle.wheels.tire_smoke_color.b or 255)
    end
end

constructor_lib.serialize_vehicle_doors = function(vehicle, serialized_vehicle)
    if serialized_vehicle.doors == nil then
        serialized_vehicle.doors = { broken = {}, open = {}, }
    end
    serialized_vehicle.doors.open.frontleft = VEHICLE.IS_VEHICLE_DOOR_FULLY_OPEN(vehicle.handle, 0)
    serialized_vehicle.doors.open.frontright = VEHICLE.IS_VEHICLE_DOOR_FULLY_OPEN(vehicle.handle, 1)
    serialized_vehicle.doors.open.backleft = VEHICLE.IS_VEHICLE_DOOR_FULLY_OPEN(vehicle.handle, 2)
    serialized_vehicle.doors.open.backright = VEHICLE.IS_VEHICLE_DOOR_FULLY_OPEN(vehicle.handle, 3)
    serialized_vehicle.doors.open.hood = VEHICLE.IS_VEHICLE_DOOR_FULLY_OPEN(vehicle.handle, 4)
    serialized_vehicle.doors.open.trunk = VEHICLE.IS_VEHICLE_DOOR_FULLY_OPEN(vehicle.handle, 5)
    serialized_vehicle.doors.open.trunk2 = VEHICLE.IS_VEHICLE_DOOR_FULLY_OPEN(vehicle.handle, 6)
end

constructor_lib.deserialize_vehicle_doors = function(vehicle, serialized_vehicle)
    if serialized_vehicle.doors == nil then return end
    if serialized_vehicle.doors.broken.frontleft then VEHICLE.SET_VEHICLE_DOOR_BROKEN(vehicle.handle, 0, true) end
    if serialized_vehicle.doors.broken.frontright then VEHICLE.SET_VEHICLE_DOOR_BROKEN(vehicle.handle, 1, true) end
    if serialized_vehicle.doors.broken.backleft then VEHICLE.SET_VEHICLE_DOOR_BROKEN(vehicle.handle, 2, true) end
    if serialized_vehicle.doors.broken.backright then VEHICLE.SET_VEHICLE_DOOR_BROKEN(vehicle.handle, 3, true) end
    if serialized_vehicle.doors.broken.hood then VEHICLE.SET_VEHICLE_DOOR_BROKEN(vehicle.handle, 4, true) end
    if serialized_vehicle.doors.broken.trunk then VEHICLE.SET_VEHICLE_DOOR_BROKEN(vehicle.handle, 5, true) end
    if serialized_vehicle.doors.broken.trunk2 then VEHICLE.SET_VEHICLE_DOOR_BROKEN(vehicle.handle, 6, true) end

    if serialized_vehicle.doors.open.frontleft then VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle.handle, 0, true, true) end
    if serialized_vehicle.doors.open.frontright then VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle.handle, 1, true, true) end
    if serialized_vehicle.doors.open.backleft then VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle.handle, 2, true, true) end
    if serialized_vehicle.doors.open.backright then VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle.handle, 3, true, true) end
    if serialized_vehicle.doors.open.hood then VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle.handle, 4, true, true) end
    if serialized_vehicle.doors.open.trunk then VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle.handle, 5, true, true) end
    if serialized_vehicle.doors.open.trunk2 then VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle.handle, 6, true, true) end
end

constructor_lib.serialize_vehicle_mods = function(vehicle, serialized_vehicle)
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

constructor_lib.deserialize_vehicle_mods = function(vehicle, serialized_vehicle)
    if serialized_vehicle.mods == nil then return end
    for mod_index = 0, 49 do
        if mod_index >= 17 and mod_index <= 22 then
            VEHICLE.TOGGLE_VEHICLE_MOD(vehicle.handle, mod_index, serialized_vehicle.mods["_"..mod_index])
        else
            VEHICLE.SET_VEHICLE_MOD(vehicle.handle, mod_index, serialized_vehicle.mods["_"..mod_index] or -1)
        end
    end
end

constructor_lib.serialize_vehicle_extras = function(vehicle, serialized_vehicle)
    if serialized_vehicle.extras == nil then serialized_vehicle.extras = {} end
    for extra_index = 0, 14 do
        if VEHICLE.DOES_EXTRA_EXIST(vehicle.handle, extra_index) then
            serialized_vehicle.extras["_"..extra_index] = VEHICLE.IS_VEHICLE_EXTRA_TURNED_ON(vehicle.handle, extra_index)
        end
    end
end

constructor_lib.deserialize_vehicle_extras = function(vehicle, serialized_vehicle)
    if serialized_vehicle.extras == nil then return end
    for extra_index = 0, 14 do
        local state = true
        if serialized_vehicle.extras["_"..extra_index] ~= nil then
            state = serialized_vehicle.extras["_"..extra_index]
        end
        VEHICLE.SET_VEHICLE_EXTRA(vehicle.handle, extra_index, not state)
    end
end

constructor_lib.serialize_vehicle_options = function(vehicle, serialized_vehicle)
    if serialized_vehicle.options == nil then serialized_vehicle.options = {} end
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

constructor_lib.deserialize_vehicle_options = function(vehicle, serialized_vehicle)
    if serialized_vehicle.options == nil then return end
    if serialized_vehicle.options.siren then
        AUDIO.SET_SIREN_WITH_NO_DRIVER(vehicle.handle, true)
        VEHICLE.SET_VEHICLE_HAS_MUTED_SIRENS(vehicle.handle, false)
        AUDIO.SET_SIREN_BYPASS_MP_DRIVER_CHECK(vehicle.handle, true)
        AUDIO.TRIGGER_SIREN_AUDIO(vehicle.handle, true)
    end
    VEHICLE.SET_VEHICLE_SIREN(vehicle.handle, serialized_vehicle.options.emergency_lights or false)
    VEHICLE.SET_VEHICLE_SEARCHLIGHT(vehicle.handle, serialized_vehicle.options.search_light or false, true)
    AUDIO.SET_VEHICLE_RADIO_LOUD(vehicle.handle, serialized_vehicle.options.radio_loud or false)
    VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT(vehicle.handle, serialized_vehicle.options.license_plate_text or "UNKNOWN")
    VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT_INDEX(vehicle.handle, serialized_vehicle.options.license_plate_type or -1)

    if serialized_vehicle.options.engine_running == true then
        VEHICLE.SET_VEHICLE_ENGINE_ON(vehicle.handle, true, true, false)
        VEHICLE.SET_VEHICLE_KEEP_ENGINE_ON_WHEN_ABANDONED(vehicle.handle, true)
    end
    if serialized_vehicle.options.doors_locked ~= nil then
        VEHICLE.SET_VEHICLE_DOORS_LOCKED(vehicle.handle, serialized_vehicle.options.doors_locked or false)
    end
    if serialized_vehicle.options.engine_health ~= nil then
        VEHICLE.SET_VEHICLE_ENGINE_HEALTH(vehicle.handle, serialized_vehicle.options.engine_health)
    end
end

---
--- Attachment Construction
---

constructor_lib.animate_peds = function(attachment)
    if attachment.ped_attributes and attachment.ped_attributes.animation_dict then
        STREAMING.REQUEST_ANIM_DICT(attachment.ped_attributes.animation_dict)
        while not STREAMING.HAS_ANIM_DICT_LOADED(attachment.ped_attributes.animation_dict) do
            util.yield()
        end
        TASK.TASK_PLAY_ANIM(attachment.handle, attachment.ped_attributes.animation_dict, attachment.ped_attributes.animation_name, 8.0, 8.0, -1, 1, 1.0, false, false, false)
    end
end

constructor_lib.set_attachment_internal_collisions = function(attachment, new_attachment)
    ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(attachment.handle, new_attachment.handle)
    if attachment.children ~= nil then
        for _, child_attachment in pairs(attachment.children) do
            constructor_lib.set_attachment_internal_collisions(child_attachment, new_attachment)
        end
    end
end

constructor_lib.completely_disable_attachment_collision = function(attachment)
    ENTITY.SET_ENTITY_COMPLETELY_DISABLE_COLLISION(attachment.handle, false, true)
    for _, child_attachment in pairs(attachment.children) do
        constructor_lib.completely_disable_attachment_collision(child_attachment)
    end
end

constructor_lib.set_attachment_defaults = function(attachment)
    if attachment.children == nil then attachment.children = {} end
    if attachment.options == nil then attachment.options = {} end
    if attachment.offset == nil then attachment.offset = { x = 0, y = 0, z = 0 } end
    if attachment.rotation == nil then attachment.rotation = { x = 0, y = 0, z = 0 } end
    if attachment.position == nil then attachment.position = { x = 0, y = 0, z = 0 } end
    if attachment.world_rotation == nil then attachment.world_rotation = { x = 0, y = 0, z = 0 } end
    if attachment.heading == nil then
        attachment.heading = (attachment.root and attachment.root.heading or 0)
    end
    if attachment.options.is_visible == nil then attachment.options.is_visible = true end
    if attachment.options.has_gravity == nil then attachment.options.has_gravity = true end
    if attachment.options.has_collision == nil then attachment.options.has_collision = true end
    if attachment.root ~= nil and attachment.root.is_preview then attachment.is_preview = true end
    if attachment.options.is_networked == nil and (attachment.root ~= nil and not attachment.root.is_preview) then
        attachment.options.is_networked = true
    end
    if attachment.options.is_mission_entity == nil then attachment.options.is_mission_entity = false end
    if attachment.options.is_invincible == nil then attachment.options.is_invincible = true end
    if attachment.options.is_bullet_proof == nil then attachment.options.is_bullet_proof = true end
    if attachment.options.is_fire_proof == nil then attachment.options.is_fire_proof = true end
    if attachment.options.is_explosion_proof == nil then attachment.options.is_explosion_proof = true end
    if attachment.options.is_melee_proof == nil then attachment.options.is_melee_proof = true end
    if attachment.options.is_light_on == nil then attachment.options.is_light_on = true end
    if attachment.options.use_soft_pinning == nil then attachment.options.use_soft_pinning = true end
    if attachment.options.bone_index == nil then attachment.options.bone_index = 0 end
    if attachment.options.lod_distance == nil then attachment.options.lod_distance = 16960 end
    if attachment.options.is_attached == nil then attachment.options.is_attached = (attachment ~= attachment.parent) end
    if attachment.hash == nil and attachment.model ~= nil then
        attachment.hash = util.joaat(attachment.model)
    elseif attachment.model == nil and attachment.hash ~= nil then
        attachment.model = util.reverse_joaat(attachment.hash)
    end
    if attachment.name == nil then attachment.name = attachment.model end
end

constructor_lib.set_preview_visibility = function(attachment)
    local preview_alpha = attachment.alpha or 206
    if attachment.options.is_visible == false then preview_alpha = 0 end
    ENTITY.SET_ENTITY_ALPHA(attachment.handle, preview_alpha, false)
    ENTITY.SET_ENTITY_COMPLETELY_DISABLE_COLLISION(attachment.handle, false, true)
    ENTITY.FREEZE_ENTITY_POSITION(attachment.handle, true)
end

constructor_lib.update_attachment = function(attachment)

    --if constructor_lib.debug then util.log("Updating attachment "..attachment.name.." ["..attachment.handle.."]") end

    if attachment.is_preview then
        constructor_lib.set_preview_visibility(attachment)
    else
        if attachment.options.alpha ~= nil and attachment.options.alpha < 255 then
            ENTITY.SET_ENTITY_ALPHA(attachment.handle, attachment.options.alpha, false)
            --if attachment.options.alpha == 0 and attachment.options.is_visible == true then
            --    attachment.options.is_visible = false
            --end
        end
        ENTITY.SET_ENTITY_VISIBLE(attachment.handle, attachment.options.is_visible, 0)
    end

    ENTITY.SET_ENTITY_HAS_GRAVITY(attachment.handle, attachment.options.has_gravity)
    if attachment.options.is_light_on == true then
        VEHICLE.SET_VEHICLE_SIREN(attachment.handle, true)
        VEHICLE.SET_VEHICLE_HAS_MUTED_SIRENS(attachment.handle, true)
        ENTITY.SET_ENTITY_LIGHTS(attachment.handle, false)
        AUDIO.TRIGGER_SIREN_AUDIO(attachment.handle, true)
        AUDIO.SET_SIREN_BYPASS_MP_DRIVER_CHECK(attachment.handle, true)
    end
    ENTITY.SET_ENTITY_PROOFS(
            attachment.handle,
            attachment.options.is_bullet_proof,
            attachment.options.is_fire_proof,
            attachment.options.is_explosion_proof,
            attachment.options.is_melee_proof,
            false, true, false
    )
    ENTITY.SET_ENTITY_COMPLETELY_DISABLE_COLLISION(attachment.handle, attachment.options.has_collision, true)
    AUDIO.SET_VEHICLE_RADIO_LOUD(attachment.handle, attachment.options.radio_loud or false)
    if attachment.options.lod_distance ~= nil then ENTITY.SET_ENTITY_LOD_DIST(attachment.handle, attachment.options.lod_distance) end

    ENTITY.SET_ENTITY_ROTATION(attachment.handle, attachment.world_rotation.x, attachment.world_rotation.y, attachment.world_rotation.z, 2, true)

    if attachment.options.is_attached then
        if attachment.type == "PED" and attachment.parent.is_player then
            error("Cannot attach ped to player")
        end
        ENTITY.ATTACH_ENTITY_TO_ENTITY(
            attachment.handle, attachment.parent.handle, attachment.options.bone_index,
            attachment.offset.x or 0, attachment.offset.y or 0, attachment.offset.z or 0,
            attachment.rotation.x or 0, attachment.rotation.y or 0, attachment.rotation.z or 0,
            false, attachment.options.use_soft_pinning, attachment.options.has_collision, false, 2, true
        )
    else
        constructor_lib.update_attachment_position(attachment)
    end

end

constructor_lib.update_attachment_position = function(attachment)
    if attachment == attachment.parent or not attachment.options.is_attached then
        ENTITY.SET_ENTITY_ROTATION(
                attachment.handle,
                attachment.world_rotation.x,
                attachment.world_rotation.y,
                attachment.world_rotation.z,
                2, true
        )
        if attachment.position ~= nil then
            if attachment.is_preview then
                ENTITY.SET_ENTITY_COORDS_NO_OFFSET(
                        attachment.handle,
                        attachment.position.x,
                        attachment.position.y,
                        attachment.position.z,
                        true, false, false
                )
                ENTITY.SET_ENTITY_ROTATION(
                        attachment.handle,
                        attachment.rotation.x,
                        attachment.rotation.y,
                        attachment.rotation.z,
                        2, true
                )
            else
                ENTITY.SET_ENTITY_COORDS(
                        attachment.handle,
                        attachment.position.x,
                        attachment.position.y,
                        attachment.position.z,
                        true, false, false
                )
            end
        end
    end
end

constructor_lib.load_hash_for_attachment = function(attachment)
    if not STREAMING.IS_MODEL_VALID(attachment.hash) then
        if not STREAMING.IS_MODEL_A_VEHICLE(attachment.hash) then
            error("Error attaching: Invalid model: " .. attachment.model)
            return false
        end
        attachment.type = "VEHICLE"
    end
    constructor_lib.load_hash(attachment.hash)
    return true
end

constructor_lib.build_parent_child_relationship = function(parent_attachment, child_attachment)
    child_attachment.parent = parent_attachment
    child_attachment.root = parent_attachment.root
end

constructor_lib.attach_attachment = function(attachment)
    constructor_lib.set_attachment_defaults(attachment)
    if attachment.is_player and not attachment.is_preview then
        debug_log("Setting player model to "..tostring(attachment.model).." hash="..tostring(attachment.hash))
        constructor_lib.load_hash(attachment.hash)
        PLAYER.SET_PLAYER_MODEL(players.user(), attachment.hash)
        util.yield(100)
        attachment.handle = players.user_ped()
        constructor_lib.deserialize_ped_attributes(attachment)
        return
    else
        debug_log("Attaching "..attachment.name.." to "..attachment.parent.name)
    end
    if attachment.hash == nil and attachment.model == nil then
        error("Cannot create attachment "..tostring(attachment.name)..": Requires either a hash or a model")
    end
    --if constructor_lib.debug then util.log("Attaching attachment "..attachment.name.." [parent="..attachment.parent.name..",root="..attachment.root.name.."]") end
    if (not constructor_lib.load_hash_for_attachment(attachment)) then
        return
    end

    if attachment.root == nil then
        error("Attachment missing root")
    end

    local is_networked = attachment.options.is_networked and not attachment.is_preview
    if attachment.type == "VEHICLE" then
        if is_networked then
            attachment.handle = entities.create_vehicle(attachment.hash, attachment.offset, attachment.heading)
        else
            attachment.handle = VEHICLE.CREATE_VEHICLE(
                    attachment.hash,
                    attachment.offset.x, attachment.offset.y, attachment.offset.z,
                    attachment.heading,
                    is_networked,
                    attachment.options.is_mission_entity,
                    false
            )
        end
        constructor_lib.deserialize_vehicle_attributes(attachment)
    elseif attachment.type == "PED" then
        local pos = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(attachment.parent.handle, attachment.offset.x, attachment.offset.y, attachment.offset.z)
        if is_networked then
            attachment.handle = entities.create_ped(1, attachment.hash, pos, attachment.heading)
        else
            attachment.handle = PED.CREATE_PED(
                    1, attachment.hash,
                    pos.x, pos.y, pos.z,
                    attachment.heading,
                    is_networked,
                    attachment.options.is_mission_entity
            )
        end
        if attachment.parent.type == "VEHICLE" and attachment.ped_attributes and attachment.ped_attributes.is_seated then
            PED.SET_PED_INTO_VEHICLE(attachment.handle, attachment.parent.handle, -1)
        end
        constructor_lib.deserialize_ped_attributes(attachment)
    else
        local pos
        if attachment.position ~= nil then
            pos = attachment.position
        else
            pos = ENTITY.GET_ENTITY_COORDS(attachment.root.handle)
        end
        if is_networked then
            attachment.handle = entities.create_object(attachment.hash, pos)
        else
            attachment.handle = OBJECT.CREATE_OBJECT_NO_OFFSET(
                    attachment.hash,
                    pos.x, pos.y, pos.z,
                    is_networked,
                    attachment.options.is_mission_entity,
                    false
            )
        end
    end

    --util.log("Created attachment "..attachment.name.." "..attachment.handle)

    if not attachment.handle then
        error("Error attaching attachment. Could not create handle.")
    end

    if attachment.root.is_preview == true then constructor_lib.set_preview_visibility(attachment) end

    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(attachment.hash)

    if attachment.num_bones == nil then attachment.num_bones = ENTITY.GET_ENTITY_BONE_COUNT(attachment.handle) end
    if attachment.type == nil then attachment.type = ENTITY_TYPES[ENTITY.GET_ENTITY_TYPE(attachment.handle)] end
    if attachment.flash_start_on ~= nil then ENTITY.SET_ENTITY_VISIBLE(attachment.handle, attachment.flash_start_on, 0) end
    if attachment.options.is_invincible ~= nil then ENTITY.SET_ENTITY_INVINCIBLE(attachment.handle, attachment.options.is_invincible) end

    constructor_lib.update_attachment(attachment)
    constructor_lib.update_attachment_position(attachment)
    constructor_lib.set_attachment_internal_collisions(attachment.root, attachment)

    if not attachment.is_preview then
        -- Pause for a tick between each model load to avoid loading too many at once
        util.yield(5)
    end

    return attachment
end

constructor_lib.update_reflection_offsets = function(reflection)
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

constructor_lib.move_attachment = function(attachment)
    if attachment.reflection then
        constructor_lib.update_reflection_offsets(attachment.reflection)
        constructor_lib.update_attachment(attachment.reflection)
    end
    constructor_lib.update_attachment(attachment)
    constructor_lib.update_attachment_position(attachment)
end

constructor_lib.detach_attachment = function(attachment)
    ENTITY.DETACH_ENTITY(attachment.handle, true, true)
    table.array_remove(attachment.parent.children, function(t, i)
        local child_attachment = t[i]
        return child_attachment ~= attachment
    end)
    attachment.root = attachment
    attachment.parent = attachment
end

constructor_lib.remove_attachment = function(attachment)
    if not attachment then return end
    if attachment.children then
        table.array_remove(attachment.children, function(t, i)
            local child_attachment = t[i]
            constructor_lib.remove_attachment(child_attachment)
            return false
        end)
    end
    if not attachment.is_player or attachment.is_preview then
        if not attachment.handle then
            util.log("Cannot remove attachment. No valid handle found. "..tostring(attachment.name))
            return
        end
        entities.delete_by_handle(attachment.handle)
        debug_log("Removed attachment. "..tostring(attachment.name))
    end
    if attachment.menus then
        for _, attachment_menu in pairs(attachment.menus) do
            -- Sometimes these menu handles are invalid but I don't know why,
            -- so wrap them in pcall to avoid errors if delete fails
            pcall(function() menu.delete(attachment_menu) end)
        end
    end
end

constructor_lib.remove_attachment_from_parent = function(attachment)
    if attachment == attachment.parent then
        constructor_lib.remove_attachment(attachment)
    else
        table.array_remove(attachment.parent.children, function(t, i)
            local child_attachment = t[i]
            if child_attachment.handle == attachment.handle then
                constructor_lib.remove_attachment(attachment)
                return false
            end
            return true
        end)
        attachment.parent.menus.refresh()
        attachment.parent.menus.focus()
    end
end

constructor_lib.reattach_attachment_with_children = function(attachment)
    constructor_lib.attach_attachment(attachment)
    for _, child_attachment in pairs(attachment.children) do
        child_attachment.root = attachment.root
        child_attachment.parent = attachment
        constructor_lib.reattach_attachment_with_children(child_attachment)
    end
end

constructor_lib.attach_attachment_with_children = function(new_attachment)
    --if constructor_lib.debug then util.log("Attaching attachment with children "..(new_attachment.name or new_attachment.model or new_attachment.hash)) end
    for key, value in pairs(constructor_lib.construct_base) do
        if new_attachment[key] == nil then
            new_attachment[key] = table.table_copy(value)
        end
    end
    local attachment = constructor_lib.attach_attachment(new_attachment)
    if not attachment then return end
    if attachment.children then
        for _, child_attachment in pairs(attachment.children) do
            constructor_lib.build_parent_child_relationship(attachment, child_attachment)
            if child_attachment.flash_model then
                child_attachment.flash_start_on = (not child_attachment.parent.flash_start_on)
            end
            if child_attachment.reflection_axis then
                constructor_lib.update_reflection_offsets(child_attachment)
            end
            constructor_lib.attach_attachment_with_children(child_attachment)
        end
    end
    return attachment
end

constructor_lib.add_attachment_to_construct = function(attachment)
    constructor_lib.attach_attachment_with_children(attachment)
    table.insert(attachment.parent.children, attachment)
    attachment.root.menus.refresh(attachment)
    --attachment.root.menus.focus_on_new()
    --if attachment.root.menus.focus_menu then
    --    menu.focus(attachment.root.menus.focus_menu)
    --end
end

constructor_lib.copy_construct_plan = function(construct_plan)
    local is_root = construct_plan == construct_plan.parent
    construct_plan.root = nil
    construct_plan.parent = nil
    local construct = table.table_copy(construct_plan)
    if is_root then
        construct.root = construct
        construct.parent = construct
    end
    return construct
end

constructor_lib.clone_attachment = function(attachment)
    if attachment.type == "VEHICLE" then
        attachment.heading = ENTITY.GET_ENTITY_HEADING(attachment.handle) or 0
    end
    local clone = constructor_lib.serialize_attachment(attachment)
    if attachment == attachment.parent then
        clone.root = clone
        clone.parent = clone
    else
        clone.root = attachment.root
        clone.parent = attachment.parent
    end
    return clone
end

---
--- Serializers
---

constructor_lib.serialize_vehicle_attributes = function(vehicle)
    if vehicle.type ~= "VEHICLE" then return end
    local serialized_vehicle = {}

    constructor_lib.serialize_vehicle_paint(vehicle, serialized_vehicle)
    constructor_lib.serialize_vehicle_neon(vehicle, serialized_vehicle)
    constructor_lib.serialize_vehicle_wheels(vehicle, serialized_vehicle)
    constructor_lib.serialize_vehicle_headlights(vehicle, serialized_vehicle)
    constructor_lib.serialize_vehicle_options(vehicle, serialized_vehicle)
    constructor_lib.serialize_vehicle_mods(vehicle, serialized_vehicle)
    constructor_lib.serialize_vehicle_extras(vehicle, serialized_vehicle)

    return serialized_vehicle
end

constructor_lib.deserialize_vehicle_attributes = function(vehicle)
    if vehicle.vehicle_attributes == nil then return end
    local serialized_vehicle = vehicle.vehicle_attributes
    --if constructor_lib.debug then util.log("Deserializing vehicle attributes "..vehicle.name.." "..inspect(serialized_vehicle)) end

    VEHICLE.SET_VEHICLE_MOD_KIT(vehicle.handle, 0)
    ENTITY.SET_ENTITY_AS_MISSION_ENTITY(vehicle.handle, true, true)    -- Needed for plate text

    constructor_lib.deserialize_vehicle_neon(vehicle, serialized_vehicle)
    constructor_lib.deserialize_vehicle_paint(vehicle, serialized_vehicle)
    constructor_lib.deserialize_vehicle_wheels(vehicle, serialized_vehicle)
    constructor_lib.deserialize_vehicle_doors(vehicle, serialized_vehicle)
    constructor_lib.deserialize_vehicle_headlights(vehicle, serialized_vehicle)
    constructor_lib.deserialize_vehicle_options(vehicle, serialized_vehicle)
    constructor_lib.deserialize_vehicle_mods(vehicle, serialized_vehicle)
    constructor_lib.deserialize_vehicle_extras(vehicle, serialized_vehicle)

    --ENTITY.SET_ENTITY_AS_MISSION_ENTITY(vehicle.handle, true, true)
end

constructor_lib.deserialize_ped_attributes = function(attachment)
    if attachment.ped_attributes == nil then return end
    PED.SET_PED_CAN_RAGDOLL(attachment.handle, attachment.ped_attributes.can_rag_doll)
    if attachment.ped_attributes.armour then
        PED.SET_PED_ARMOUR(attachment.handle, attachment.ped_attributes.armour)
    end
    if attachment.ped_attributes.weapon then
        WEAPON.GIVE_WEAPON_TO_PED(attachment.handle, attachment.ped_attributes.weapon, 999, false, true)
    end
    if attachment.ped_attributes.props then
        for prop_index = 0, 9 do
            PED.SET_PED_PROP_INDEX(
                    attachment.handle,
                    prop_index,
                    tonumber(attachment.ped_attributes.props["_"..prop_index][1]),
                    tonumber(attachment.ped_attributes.props["_"..prop_index][2]),
                    true
            )
        end
    end
    if attachment.ped_attributes.components then
        for component_index = 0, 11 do
            PED.SET_PED_COMPONENT_VARIATION(
                    attachment.handle,
                    component_index,
                    tonumber(attachment.ped_attributes.components["_"..component_index][1]),
                    tonumber(attachment.ped_attributes.components["_"..component_index][2]),
                    tonumber(attachment.ped_attributes.components["_"..component_index][2])
            )
        end
    end
    constructor_lib.animate_peds(attachment)
end

constructor_lib.copy_serializable = function(attachment)
    local serializeable_attachment = {
        children = {}
    }
    for k, v in pairs(attachment) do
        if not (
            k == "handle" or k == "root" or k == "parent" or k == "menus" or k == "children"
            or k == "is_preview" or k == "is_editing" or k == "dimensions" or k == "camera_distance" or k == "heading"
        ) then
            serializeable_attachment[k] = table.table_copy(v)
        end
    end
    return serializeable_attachment
end

constructor_lib.serialize_attachment = function(attachment)
    if attachment.target_version == nil then attachment.target_version = LIB_VERSION end
    local serialized_attachment = constructor_lib.copy_serializable(attachment)
    serialized_attachment.vehicle_attributes = constructor_lib.serialize_vehicle_attributes(attachment)
    if attachment.children then
        for _, child_attachment in pairs(attachment.children) do
            if not child_attachment.options.is_temporary then
                table.insert(serialized_attachment.children, constructor_lib.serialize_attachment(child_attachment))
            end
        end
    end
    --util.toast(inspect(serialized_attachment), TOAST_ALL)
    return serialized_attachment
end

---
--- Jackz Vehicle Builder to Construct Plan Convertor
---

local function convert_jackz_savedata_build_vehicle_attribute_mods(jackz_save_data)
    local MOD_NAMES = table.freeze({
        [1] = "Spoilers",
        [2] = "Front Bumper",
        [3] = "Rear Bumper",
        [4] = "Side Skirt",
        [5] = "Exhaust",
        [6] = "Frame",
        [7] = "Grille",
        [8] = "Hood",
        [9] = "Fender",
        [10] = "Right Fender",
        [11] = "Roof",
        [12] = "Engine",
        [13] = "Brakes",
        [14] = "Transmission",
        [15] = "Horns",
        [16] = "Suspension",
        [17] = "Armor",
        [24] = "Wheels Design",
        [25] = "Motorcycle Back Wheel Design",
        [26] = "Plate Holders",
        [28] = "Trim Design",
        [29] = "Ornaments",
        [31] = "Dial Design",
        [34] = "Steering Wheel",
        [35] = "Shifter Leavers",
        [36] = "Plaques",
        [39] = "Hydraulics",
        [49] = "Livery"
    })
    -- Subtract index by 1 to get modType (ty lua)
    local TOGGLEABLE_MOD_NAMES = table.freeze({
        [18] = "UNK17",
        [19] = "Turbo Turning",
        [20] = "UNK19",
        [21] = "Tire Smoke",
        [22] = "UNK21",
        [23] = "Xenon Headlights"
    })
    local mods = {}
    for mod_index = 0, 49 do
        local jackz_key
        if mod_index >= 17 and mod_index <= 22 then
            jackz_key = TOGGLEABLE_MOD_NAMES[mod_index+1]
        else
            jackz_key = MOD_NAMES[mod_index+1]
        end
        mods["_"..mod_index] = jackz_save_data.Mods[jackz_key] or -1
    end
    return mods
end

local function convert_jackz_savedata_build_vehicle_attribute_extras(jackz_save_data)
    local extras = {}
    for key, value in pairs(jackz_save_data.Extras) do
        extras["_"..key] = value
    end
    return extras
end

local function convert_jackz_savedata_to_vehicle_attributes(jackz_save_data, attachment)
    if jackz_save_data == nil then return end
    attachment.vehicle_attributes = {
        paint = {
            dirt_level = jackz_save_data["Dirt Level"],
            interior_color = jackz_save_data["Interior Color"],
            dashboard_color = jackz_save_data["Dashboard Color"],
            fade = jackz_save_data.Colors["Paint Fade"],
            color_combo = jackz_save_data.Colors["Color Combo"],
            primary = {
                is_custom = jackz_save_data.Colors.Primary.Custom,
                vehicle_standard_color = jackz_save_data.Colors.Vehicle.Primary,
                vehicle_custom_color = {
                    r= jackz_save_data.Colors.Vehicle.r,
                    g= jackz_save_data.Colors.Vehicle.g,
                    b= jackz_save_data.Colors.Vehicle.b
                }
            },
            secondary = {
                is_custom = jackz_save_data.Colors.Secondary.Custom,
                vehicle_standard_color = jackz_save_data.Colors.Vehicle.Secondary,
                vehicle_custom_color = {
                    r= jackz_save_data.Colors.Vehicle.r,
                    g= jackz_save_data.Colors.Vehicle.g,
                    b= jackz_save_data.Colors.Vehicle.b
                }
            },
            extra_colors = {
                pearlescent_color = jackz_save_data.Colors.Extras.Pearlescent,
                wheel = jackz_save_data.Colors.Extras.Wheel,
            },
            livery = jackz_save_data.Livery.Style,
        },
        options = {
            engine_running = jackz_save_data["Engine Running"],
            radio_loud = jackz_save_data["RadioLoud"],
            search_light = jackz_save_data.Lights.SearchLightActive,
            siren = jackz_save_data.Lights["SirenActive"],
            license_plate_text = jackz_save_data["License Plate"].Text,
            license_plate_type = jackz_save_data["License Plate"].Type,
            window_tint = jackz_save_data["Window Tint"],
        },
        wheels = {
            tire_smoke_color = {
                r= jackz_save_data["Tire Smoke"].r,
                g= jackz_save_data["Tire Smoke"].g,
                b= jackz_save_data["Tire Smoke"].b
            },
            bulletproof_tires = jackz_save_data["Bulletproof Tires"],
            wheel_type = jackz_save_data["Wheel Type"],
        },
        headlights = {
            headlights_color = jackz_save_data.Lights["Xenon Color"],
        },
        neon = {
            lights = {
                left = jackz_save_data.Lights.Neon.Left,
                right = jackz_save_data.Lights.Neon.Right,
                back = jackz_save_data.Lights.Neon.Back,
                front = jackz_save_data.Lights.Neon.Front,
            },
            color = {
                r= jackz_save_data.Lights.Neon.Color.r,
                g= jackz_save_data.Lights.Neon.Color.g,
                b= jackz_save_data.Lights.Neon.Color.b
            }
        },
        mods = convert_jackz_savedata_build_vehicle_attribute_mods(jackz_save_data),
        extras = convert_jackz_savedata_build_vehicle_attribute_extras(jackz_save_data),
    }

    if jackz_save_data.Colors.Primary["Custom Color"] then
        attachment.vehicle_attributes.paint.primary.custom_color = {
            r=jackz_save_data.Colors.Primary["Custom Color"].r,
            g=jackz_save_data.Colors.Primary["Custom Color"].g,
            b=jackz_save_data.Colors.Primary["Custom Color"].b
        }
    end
    if jackz_save_data.Colors.Secondary["Custom Color"] then
        attachment.vehicle_attributes.paint.secondary.custom_color = {
            r=jackz_save_data.Colors.Secondary["Custom Color"].r,
            g=jackz_save_data.Colors.Secondary["Custom Color"].g,
            b=jackz_save_data.Colors.Secondary["Custom Color"].b
        }
    end

end

local function convert_jackz_object_to_attachment(jackz_object, jackz_save_data, attachment, type)
    if attachment == nil then attachment = {} end
    if attachment.children == nil then attachment.children = {} end
    if attachment.options == nil then attachment.options = {} end
    attachment.hash = jackz_object.model
    attachment.name = jackz_object.name
    attachment.type = jackz_object.type or type
    attachment.options.has_collision = jackz_object.collision
    attachment.options.is_visible = jackz_object.visible
    attachment.options.bone_index = jackz_object.bone_index
    if jackz_object.offset then
        attachment.rotation = {
            x=jackz_object.rotation.x,
            y=jackz_object.rotation.y,
            z=jackz_object.rotation.z
        }
    end
    if jackz_object.offset then
        attachment.offset = {
            x=jackz_object.offset.x,
            y=jackz_object.offset.y,
            z=jackz_object.offset.z
        }
    end
    if jackz_object.animdata then
        attachment.ped_attributes = {
            animation_dict = jackz_object.animdata[1],
            animation_name = jackz_object.animdata[2]
        }
    end
    convert_jackz_savedata_to_vehicle_attributes(jackz_save_data, attachment)
end

constructor_lib.convert_jackz_to_construct_plan = function(jackz_build_data)

    local construct_plan = table.table_copy(constructor_lib.construct_base)
    construct_plan.name = jackz_build_data.name
    construct_plan.author = jackz_build_data.author

    convert_jackz_object_to_attachment(jackz_build_data.base.data, jackz_build_data.base.savedata, construct_plan)

    for _, child_object in pairs(jackz_build_data.objects) do
        local child_attachment = {type="OBJECT"}
        convert_jackz_object_to_attachment(child_object, nil, child_attachment, "OBJECT")
        table.insert(construct_plan.children, child_attachment)
    end
    for _, child_object in pairs(jackz_build_data.vehicles) do
        local child_attachment = {type="VEHICLE"}
        convert_jackz_object_to_attachment(child_object, child_object.savedata, child_attachment, "VEHICLE")
        table.insert(construct_plan.children, child_attachment)
    end
    for _, child_object in pairs(jackz_build_data.peds) do
        local child_attachment = {type="PED"}
        convert_jackz_object_to_attachment(child_object, nil, child_attachment, "PED")
        table.insert(construct_plan.children, child_attachment)
    end

    if construct_plan.hash == nil and construct_plan.model ~= nil then
        construct_plan.hash = util.joaat(construct_plan.model)
    elseif construct_plan.model == nil and construct_plan.hash ~= nil then
        construct_plan.model = util.reverse_joaat(construct_plan.hash)
    end

    if construct_plan.hash == nil and construct_plan.model == nil then
        util.toast("Failed to load Jackz construct. Missing hash or model.", TOAST_ALL)
        util.log("Attempted construct plan: "..inspect(construct_plan))
        return
    end

    --if constructor_lib.debug then util.log("Loaded Jackz construct plan: "..inspect(construct_plan)) end

    return construct_plan
end

---
--- XML to Construct Plan Convertor
---

local function strsplit(str, sep)
    sep = sep or "%s";
    local tbl = {};
    local i = 1;
    for str_part in string.gmatch(str, "([^"..sep.."]+)") do
        tbl[i] = str_part;
        i = i + 1;
    end
    return tbl;
end

local function find_attachment_by_initial_handle(attachment, initial_handle)
    if attachment.initial_handle == initial_handle then return attachment end
    for _, child_attachment in pairs(attachment.children) do
        local new_parent = find_attachment_by_initial_handle(child_attachment, initial_handle)
        if new_parent then return new_parent end
    end
end

local function rearrange_by_initial_attachment(attachment, parent_attachment, root_attachment)
    if parent_attachment == nil then root_attachment = attachment end
    if parent_attachment ~= nil and attachment.parents_initial_handle and (attachment.parents_initial_handle ~= parent_attachment.initial_handle) then
        local new_parent = find_attachment_by_initial_handle(root_attachment, attachment.parents_initial_handle)
        if new_parent then
            table.array_remove(parent_attachment.children, function(t, i)
                local child_attachment = t[i]
                return child_attachment ~= attachment
            end)
            table.insert(new_parent.children, attachment)
        else
            util.toast("Could not rearrange attachment "..attachment.name.." to "..attachment.parents_initial_handle, TOAST_ALL)
        end
    end
    for _, child_attachment in pairs(attachment.children) do
        rearrange_by_initial_attachment(child_attachment, attachment, root_attachment)
    end
end

local function value_splitter(value)
    local split_value = strsplit(value, ",")
    return {tonumber(split_value[1]), tonumber(split_value[2])}
end

local function map_vehicle_attributes(attachment, placement)
    if not placement.VehicleProperties then return end

    if attachment.vehicle_attributes == nil then attachment.vehicle_attributes = {} end

    if attachment.vehicle_attributes.headlights == nil then attachment.vehicle_attributes.headlights = {} end
    attachment.vehicle_attributes.headlights.multiplier = tonumber(placement.VehicleProperties.HeadlightIntensity)
    attachment.vehicle_attributes.headlights.headlights_color = tonumber(placement.VehicleProperties.Colours.LrXenonHeadlights)

    if attachment.vehicle_attributes.wheels == nil then attachment.vehicle_attributes.wheels = {} end
    attachment.vehicle_attributes.wheels.wheel_type = tonumber(placement.VehicleProperties.WheelType)
    attachment.vehicle_attributes.wheels.bulletproof_tires = toboolean(placement.VehicleProperties.BulletProofTyres)
    attachment.vehicle_attributes.wheels.invisible_wheels = toboolean(placement.VehicleProperties.WheelsInvisible)
    if attachment.vehicle_attributes.wheels.tire_smoke_color == nil then attachment.vehicle_attributes.wheels.tire_smoke_color = {} end
    attachment.vehicle_attributes.wheels.tire_smoke_color.r = tonumber(placement.VehicleProperties.Colours.tyreSmoke_R)
    attachment.vehicle_attributes.wheels.tire_smoke_color.g = tonumber(placement.VehicleProperties.Colours.tyreSmoke_G)
    attachment.vehicle_attributes.wheels.tire_smoke_color.b = tonumber(placement.VehicleProperties.Colours.tyreSmoke_B)

    if attachment.vehicle_attributes.paint == nil then attachment.vehicle_attributes.paint = {} end
    attachment.vehicle_attributes.paint.dirt_level = tonumber(placement.VehicleProperties.DirtLevel)
    attachment.vehicle_attributes.paint.fade = tonumber(placement.VehicleProperties.PaintFade)
    attachment.vehicle_attributes.paint.livery = tonumber(placement.VehicleProperties.Livery)
    if attachment.vehicle_attributes.paint.primary == nil then attachment.vehicle_attributes.paint.primary = {} end
    attachment.vehicle_attributes.paint.primary.vehicle_standard_color = tonumber(placement.VehicleProperties.Colours.Primary)
    attachment.vehicle_attributes.paint.primary.is_custom = toboolean(placement.VehicleProperties.Colours.IsPrimaryColourCustom)
    if attachment.vehicle_attributes.paint.primary.custom_color == nil then attachment.vehicle_attributes.paint.primary.custom_color = {} end
    attachment.vehicle_attributes.paint.primary.custom_color.r = tonumber(placement.VehicleProperties.Colours.Cust1_R)
    attachment.vehicle_attributes.paint.primary.custom_color.g = tonumber(placement.VehicleProperties.Colours.Cust1_G)
    attachment.vehicle_attributes.paint.primary.custom_color.b = tonumber(placement.VehicleProperties.Colours.Cust1_B)
    if attachment.vehicle_attributes.paint.secondary == nil then attachment.vehicle_attributes.paint.secondary = {} end
    attachment.vehicle_attributes.paint.secondary.vehicle_standard_color = tonumber(placement.VehicleProperties.Colours.Secondary)
    attachment.vehicle_attributes.paint.secondary.is_custom = toboolean(placement.VehicleProperties.Colours.IsSecondaryColourCustom)
    if attachment.vehicle_attributes.paint.secondary.custom_color == nil then attachment.vehicle_attributes.paint.secondary.custom_color = {} end
    attachment.vehicle_attributes.paint.secondary.custom_color.r = tonumber(placement.VehicleProperties.Colours.Cust2_R)
    attachment.vehicle_attributes.paint.secondary.custom_color.g = tonumber(placement.VehicleProperties.Colours.Cust2_G)
    attachment.vehicle_attributes.paint.secondary.custom_color.b = tonumber(placement.VehicleProperties.Colours.Cust2_B)
    if attachment.vehicle_attributes.paint.extra_colors == nil then attachment.vehicle_attributes.paint.extra_colors = {} end
    attachment.vehicle_attributes.paint.extra_colors.pearlescent = tonumber(placement.VehicleProperties.Colours.Pearl)
    attachment.vehicle_attributes.paint.extra_colors.wheel = tonumber(placement.VehicleProperties.Colours.Rim)
    attachment.vehicle_attributes.paint.interior_color = tonumber(placement.VehicleProperties.Colours.LrInterior)
    attachment.vehicle_attributes.paint.dashboard_color = tonumber(placement.VehicleProperties.Colours.LrDashboard)

    if attachment.vehicle_attributes.neon == nil then attachment.vehicle_attributes.neon = {} end
    if attachment.vehicle_attributes.neon.lights == nil then attachment.vehicle_attributes.neon.lights = {} end
    attachment.vehicle_attributes.neon.lights.left = toboolean(placement.VehicleProperties.Neons.Left)
    attachment.vehicle_attributes.neon.lights.right = toboolean(placement.VehicleProperties.Neons.Right)
    attachment.vehicle_attributes.neon.lights.front = toboolean(placement.VehicleProperties.Neons.Front)
    attachment.vehicle_attributes.neon.lights.back = toboolean(placement.VehicleProperties.Neons.Back)
    if attachment.vehicle_attributes.neon.color == nil then attachment.vehicle_attributes.neon.color = {} end
    attachment.vehicle_attributes.neon.color.r = tonumber(placement.VehicleProperties.Neons.R)
    attachment.vehicle_attributes.neon.color.g = tonumber(placement.VehicleProperties.Neons.G)
    attachment.vehicle_attributes.neon.color.b = tonumber(placement.VehicleProperties.Neons.B)

    if attachment.vehicle_attributes.doors == nil then attachment.vehicle_attributes.doors = {} end
    if attachment.vehicle_attributes.doors.open == nil then attachment.vehicle_attributes.doors.open = {} end
    attachment.vehicle_attributes.doors.open.backleft = toboolean(placement.VehicleProperties.DoorsOpen.BackLeftDoor)
    attachment.vehicle_attributes.doors.open.backright = toboolean(placement.VehicleProperties.DoorsOpen.BackRightDoor)
    attachment.vehicle_attributes.doors.open.frontleft = toboolean(placement.VehicleProperties.DoorsOpen.FrontLeftDoor)
    attachment.vehicle_attributes.doors.open.frontright = toboolean(placement.VehicleProperties.DoorsOpen.FrontRightDoor)
    attachment.vehicle_attributes.doors.open.hood = toboolean(placement.VehicleProperties.DoorsOpen.Hood)
    attachment.vehicle_attributes.doors.open.trunk = toboolean(placement.VehicleProperties.DoorsOpen.Trunk)
    attachment.vehicle_attributes.doors.open.trunk2 = toboolean(placement.VehicleProperties.DoorsOpen.Trunk2)
    if attachment.vehicle_attributes.doors.broken == nil then attachment.vehicle_attributes.doors.broken = {} end
    attachment.vehicle_attributes.doors.broken.backleft = toboolean(placement.VehicleProperties.DoorsBroken.BackLeftDoor)
    attachment.vehicle_attributes.doors.broken.backright = toboolean(placement.VehicleProperties.DoorsBroken.BackRightDoor)
    attachment.vehicle_attributes.doors.broken.frontleft = toboolean(placement.VehicleProperties.DoorsBroken.FrontLeftDoor)
    attachment.vehicle_attributes.doors.broken.frontright = toboolean(placement.VehicleProperties.DoorsBroken.FrontRightDoor)
    attachment.vehicle_attributes.doors.broken.hood = toboolean(placement.VehicleProperties.DoorsBroken.Hood)
    attachment.vehicle_attributes.doors.broken.trunk = toboolean(placement.VehicleProperties.DoorsBroken.Trunk)
    attachment.vehicle_attributes.doors.broken.trunk2 = toboolean(placement.VehicleProperties.DoorsBroken.Trunk2)

    if attachment.vehicle_attributes.options == nil then attachment.vehicle_attributes.options = {} end
    attachment.vehicle_attributes.options.siren = toboolean(placement.VehicleProperties.SirenActive)
    attachment.vehicle_attributes.options.window_tint = tonumber(placement.VehicleProperties.WindowTint)
    attachment.vehicle_attributes.options.engine_running = toboolean(placement.VehicleProperties.EngineOn)
    attachment.vehicle_attributes.options.radio_loud = toboolean(placement.VehicleProperties.IsRadioLoud)
    attachment.vehicle_attributes.options.license_plate_type = tonumber(placement.VehicleProperties.NumberPlateIndex)
    attachment.vehicle_attributes.options.license_plate_text = tostring(placement.VehicleProperties.NumberPlateText)

    if attachment.vehicle_attributes.mods == nil then attachment.vehicle_attributes.mods = {} end
    for index = 0, 49 do
        local formatter = function(value) if type(value) == "table" then return tonumber(value[1]) end end
        if index >= 17 and index <= 22 then formatter = toboolean end
        attachment.vehicle_attributes.mods["_"..index] = formatter(placement.VehicleProperties.Mods["_"..index])
    end

    if attachment.vehicle_attributes.extras == nil then attachment.vehicle_attributes.extras = {} end
    for index = 0, 14 do
        attachment.vehicle_attributes.extras["_"..index] = toboolean(placement.VehicleProperties.ModExtras["_"..index])
    end
end

local function map_ped_placement(attachment, placement)
    if not placement.PedProperties then return end

    if attachment.ped_attributes == nil then attachment.ped_attributes = {} end
    if placement.PedProperties.CanRagDoll ~= nil then attachment.ped_attributes.can_rag_doll = toboolean(placement.PedProperties.CanRagDoll) end
    if placement.PedProperties.Armour ~= nil then attachment.ped_attributes.armour = tonumber(placement.PedProperties.Armour) end
    if placement.PedProperties.CurrentWeapon ~= nil then attachment.ped_attributes.current_weapon = tonumber(placement.PedProperties.CurrentWeapon) end
    if placement.PedProperties.AnimDict ~= nil then attachment.ped_attributes.animation_dict = tostring(placement.PedProperties.AnimDict) end
    if placement.PedProperties.AnimName ~= nil then attachment.ped_attributes.animation_name = tostring(placement.PedProperties.AnimName) end

    if attachment.ped_attributes.props == nil then attachment.ped_attributes.props = {} end
    if placement.PedProperties.PedProps ~= nil then
        for index = 0, 9 do
            attachment.ped_attributes.props["_"..index] = value_splitter(placement.PedProperties.PedProps["_"..index])
        end
    end
    if attachment.ped_attributes.components == nil then attachment.ped_attributes.components = {} end
    if placement.PedProperties.PedComps ~= nil then
        for index = 0, 11 do
            attachment.ped_attributes.components["_"..index] = value_splitter(placement.PedProperties.PedComps["_"..index])
        end
    end

end

local function map_placement_options(attachment, placement)
    if attachment.options == nil then attachment.options = {} end
    if placement.FrozenPos ~= nil then attachment.options.is_frozen = toboolean(placement.FrozenPos) end
    if placement.OpacityLevel ~= nil then attachment.options.alpha = tonumber(placement.OpacityLevel) end
    if placement.LodDistance ~= nil then attachment.options.lod_distance = tonumber(placement.LodDistance) end
    if placement.IsVisible ~= nil then attachment.options.is_visible = toboolean(placement.IsVisible) end
    -- max health
    -- health
    if placement.HasGravity ~= nil then attachment.options.has_gravity = toboolean(placement.HasGravity) end
    -- on fire
    if placement.IsInvincible ~= nil then attachment.options.is_invincible = toboolean(placement.IsInvincible) end
    if placement.IsBulletProof ~= nil then attachment.options.is_bullet_proof = toboolean(placement.IsBulletProof) end
    if placement.IsFireProof ~= nil then attachment.options.is_fire_proof = toboolean(placement.IsFireProof) end
    if placement.IsExplosionProof ~= nil then attachment.options.is_explosion_proof = toboolean(placement.IsExplosionProof) end
    if placement.IsMeleeProof ~= nil then attachment.options.is_melee_proof = toboolean(placement.IsMeleeProof) end
    --IsOnlyDamagedByPlayer = placement.IsOnlyDamagedByPlayer
    if placement.IsCollisionProof ~= nil then attachment.options.has_collision = not toboolean(placement.IsCollisionProof) end
end

local function map_placement_position(attachment, placement)
    if attachment.position == nil then attachment.position = {x=0, y=0, z=0} end
    if attachment.world_rotation == nil then attachment.world_rotation = {x=0, y=0, z=0} end
    if attachment.offset == nil then attachment.offset = {x=0, y=0, z=0} end
    if attachment.rotation == nil then attachment.rotation = {x=0, y=0, z=0} end
    if placement.PositionRotation ~= nil then
        attachment.position = {
            x = tonumber(placement.PositionRotation.X),
            y = tonumber(placement.PositionRotation.Y),
            z = tonumber(placement.PositionRotation.Z)
        }
        attachment.world_rotation = {
            x = tonumber(placement.PositionRotation.Pitch),
            y = tonumber(placement.PositionRotation.Roll),
            z = tonumber(placement.PositionRotation.Yaw)
        }
    end
    if placement.Attachment ~= nil and placement.Attachment.X ~= nil then
        attachment.offset = {
            x = tonumber(placement.Attachment.X),
            y = tonumber(placement.Attachment.Y),
            z = tonumber(placement.Attachment.Z)
        }
        attachment.rotation = {
            x = tonumber(placement.Attachment.Pitch),
            y = tonumber(placement.Attachment.Roll),
            z = tonumber(placement.Attachment.Yaw)
        }
        if placement.Attachment.BoneIndex ~= nil then attachment.options.bone_index = tonumber(placement.Attachment.BoneIndex) end
        if placement.Attachment.AttachedTo ~= nil then attachment.parents_initial_handle = tonumber(placement.Attachment.AttachedTo) end
    end
    if placement.Attachment ~= nil and placement.Attachment._attr ~= nil then
        attachment.options.is_attached = toboolean(placement.Attachment._attr.isAttached)
    end
end

local function map_placement(attachment, placement)
    --util.log("Processing "..inspect(placement))
    if attachment == nil then attachment = {} end

    attachment.hash = tonumber(placement.ModelHash)
    attachment.name = placement.HashName
    if attachment.model == nil and attachment.hash ~= nil then
        attachment.model = util.reverse_joaat(attachment.hash)
    end
    if placement.Type then attachment.type = ENTITY_TYPES[tonumber(placement.Type)] end
    attachment.initial_handle = tonumber(placement.InitialHandle)
    -- dynamic?
    if attachment.children == nil then attachment.children = {} end

    map_placement_options(attachment, placement)
    map_placement_position(attachment, placement)
    map_vehicle_attributes(attachment, placement)
    map_ped_placement(attachment, placement)
end

constructor_lib.convert_xml_to_construct_plan = function(xmldata)
    local construct_plan = table.table_copy(constructor_lib.construct_base)

    local vehicle_handler = xml2lua.TreeHandler:new()
    local parser = xml2lua.parser(vehicle_handler)
    parser:parse(xmldata)

    --util.log("Parsed XML: "..inspect(vehicle_handler.root))

    if vehicle_handler.root.Vehicle ~= nil then
        construct_plan.type = "VEHICLE"
        local root = vehicle_handler.root.Vehicle
        if root[1] == nil then root = {root} end
        map_placement(construct_plan, root[1])
        local attachments = root[1].SpoonerAttachments.Attachment
        if attachments then
            if attachments[1] == nil then attachments = {attachments} end
            for _, placement in pairs(attachments) do
                local attachment = {}
                map_placement(attachment, placement)
                table.insert(construct_plan.children, attachment)
            end
        end
    elseif vehicle_handler.root.SpoonerPlacements ~= nil then
        for _, placement in pairs(vehicle_handler.root.SpoonerPlacements.Placement) do
            if construct_plan.model == nil then
                map_placement(construct_plan, placement)
                if construct_plan.type == "OBJECT" then construct_plan.always_spawn_at_position = true end
            else
                local attachment = {}
                map_placement(attachment, placement)
                if construct_plan.always_spawn_at_position == true then attachment.options.is_attached = false end
                table.insert(construct_plan.children, attachment)
            end
        end
    elseif vehicle_handler.root.OutfitPedData then
        construct_plan.type = "PED"
        construct_plan.is_player = true
        local root = vehicle_handler.root.OutfitPedData
        if root[1] == nil then root = {root} end
        map_placement(construct_plan, root[1])
        local attachments = root[1].SpoonerAttachments.Attachment
        if attachments then
            if attachments[1] == nil then attachments = {attachments} end
            for _, placement in pairs(attachments) do
                local attachment = {}
                map_placement(attachment, placement)
                table.insert(construct_plan.children, attachment)
            end
        end
    end

    rearrange_by_initial_attachment(construct_plan)

    debug_log("Loaded XML construct plan: "..inspect(construct_plan))

    if construct_plan.hash == nil and construct_plan.model == nil then
        util.toast("Failed to load XML construct. Missing hash or model.", TOAST_ALL)
        util.log("Attempted construct plan: "..inspect(construct_plan))
        return
    end

    return construct_plan
end

---
--- Return
---

return constructor_lib

