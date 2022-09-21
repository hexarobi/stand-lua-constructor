-- Constructor Lib
-- by Hexarobi
-- A Lua Script for the Stand mod menu for GTA5
-- Allows for constructing custom vehicles and maps
-- https://github.com/hexarobi/stand-lua-constructor

--local status, inspect = pcall(require, "inspect")
--if not status then error("Could not load inspect lib. This is probably an accidental bug.") end

local LIB_VERSION = "3.9"

local constructor_lib = {
    LIB_VERSION = LIB_VERSION,
    debug = true
}

---
--- Data
---

local ENTITY_TYPES = {"PED", "VEHICLE", "OBJECT"}

local construct_base = {
    target_version = constructor_lib.LIB_VERSION,
    children = {},
    options = {},
    heading = 0,
}

---
--- Utilities
---

util.require_natives(1660775568)

local slaxdom = require("lib/slaxdom")

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
    ENTITY.GET_ENTITY_MATRIX(entity, rightVector_pointer, forwardVector_pointer, upVector_pointer, position_pointer);
    local forward_vector = v3.new(forwardVector_pointer)
    local forward_vector = v3.new(forwardVector_pointer)
    local right_vector = v3.new(rightVector_pointer)
    local up_vector = v3.new(upVector_pointer)

    MISC.GET_MODEL_DIMENSIONS(ENTITY.GET_ENTITY_MODEL(entity), minimum, maximum)
    local minimum_vec = v3.new(minimum)
    local maximum_vec = v3.new(maximum)
    local dimensions = {x = maximum_vec.y - minimum_vec.y, y = maximum_vec.x - minimum_vec.x, z = maximum_vec.z - minimum_vec.z}

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
    serialized_vehicle.headlights.headlights_color = VEHICLE._GET_VEHICLE_XENON_LIGHTS_COLOR(vehicle.handle)
    serialized_vehicle.headlights.headlights_type = VEHICLE.IS_TOGGLE_MOD_ON(vehicle.handle, 22)
    return serialized_vehicle
end

constructor_lib.deserialize_vehicle_headlights = function(vehicle, serialized_vehicle)
    if serialized_vehicle.headlights == nil then return end
    VEHICLE._SET_VEHICLE_XENON_LIGHTS_COLOR(vehicle.handle, serialized_vehicle.headlights.headlights_color)
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
    VEHICLE._GET_VEHICLE_DASHBOARD_COLOR(vehicle.handle, color.r)
    serialized_vehicle.paint.dashboard_color = memory.read_int(color.r)
    VEHICLE._GET_VEHICLE_INTERIOR_COLOR(vehicle.handle, color.r)
    serialized_vehicle.paint.interior_color = memory.read_int(color.r)
    serialized_vehicle.paint.fade = VEHICLE.GET_VEHICLE_ENVEFF_SCALE(vehicle.handle)
    serialized_vehicle.paint.dirt_level = VEHICLE.GET_VEHICLE_DIRT_LEVEL(vehicle.handle)
    serialized_vehicle.paint.color_combo = VEHICLE.GET_VEHICLE_COLOUR_COMBINATION(vehicle.handle)

    -- Livery is also part of mods, but capture it here as well for when just saving paint
    serialized_vehicle.paint.livery = VEHICLE.GET_VEHICLE_MOD(vehicle.handle, 48)

    --memory.free(color.r) memory.free(color.g) memory.free(color.b)
end

constructor_lib.deserialize_vehicle_paint = function(vehicle, serialized_vehicle)
    if serialized_vehicle.paint == nil then return end

    --VEHICLE.SET_VEHICLE_MOD_KIT(vehicle.handle, 0)
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
    VEHICLE.SET_VEHICLE_COLOURS(
            vehicle.handle,
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
    VEHICLE.SET_VEHICLE_MOD(vehicle.handle, 48, serialized_vehicle.paint.livery or -1)
end

constructor_lib.serialize_vehicle_neon = function(vehicle, serialized_vehicle)
    if serialized_vehicle.neon == nil then serialized_vehicle.neon = {} end
    serialized_vehicle.neon.lights = {
        left = VEHICLE._IS_VEHICLE_NEON_LIGHT_ENABLED(vehicle.handle, 0),
        right = VEHICLE._IS_VEHICLE_NEON_LIGHT_ENABLED(vehicle.handle, 1),
        front = VEHICLE._IS_VEHICLE_NEON_LIGHT_ENABLED(vehicle.handle, 2),
        back = VEHICLE._IS_VEHICLE_NEON_LIGHT_ENABLED(vehicle.handle, 3),
    }
    local color = { r = memory.alloc(8), g = memory.alloc(8), b = memory.alloc(8) }
    if (serialized_vehicle.neon.lights.left or serialized_vehicle.neon.lights.right
            or serialized_vehicle.neon.lights.front or serialized_vehicle.neon.lights.back) then
        VEHICLE._GET_VEHICLE_NEON_LIGHTS_COLOUR(vehicle.handle, color.r, color.g, color.b)
        serialized_vehicle.neon.color = { r = memory.read_int(color.r), g = memory.read_int(color.g), b = memory.read_int(color.b) }
    end
    --memory.free(color.r) memory.free(color.g) memory.free(color.b)
end

constructor_lib.deserialize_vehicle_neon = function(vehicle, serialized_vehicle)
    if serialized_vehicle.neon == nil then return end
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

constructor_lib.serialize_vehicle_wheels = function(vehicle, serialized_vehicle)
    if serialized_vehicle.wheels == nil then serialized_vehicle.wheels = {} end
    serialized_vehicle.wheels.type = VEHICLE.GET_VEHICLE_WHEEL_TYPE(vehicle.handle)
    local color = { r = memory.alloc(8), g = memory.alloc(8), b = memory.alloc(8) }
    VEHICLE.GET_VEHICLE_TYRE_SMOKE_COLOR(vehicle.handle, color.r, color.g, color.b)
    serialized_vehicle.wheels.tire_smoke_color = { r = memory.read_int(color.r), g = memory.read_int(color.g), b = memory.read_int(color.b) }
    --memory.free(color.r) memory.free(color.g) memory.free(color.b)
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

constructor_lib.deserialize_vehicle_options = function(vehicle, serialized_vehicle)
    if serialized_vehicle.options == nil then return end
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

    VEHICLE.SET_VEHICLE_DOORS_LOCKED(vehicle.handle, serialized_vehicle.options.doors_locked or false)
    if serialized_vehicle.options.engine_health ~= nil then
        VEHICLE.SET_VEHICLE_ENGINE_HEALTH(vehicle, serialized_vehicle.options.engine_health)
    end
end

---
--- Attachment Construction
---

constructor_lib.set_attachment_internal_collisions = function(attachment, new_attachment)
    ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(attachment.handle, new_attachment.handle)
    if attachment.children ~= nil then
        for _, child_attachment in pairs(attachment.children) do
            constructor_lib.set_attachment_internal_collisions(child_attachment, new_attachment)
        end
    end
end

constructor_lib.set_attachment_defaults = function(attachment)
    if attachment.children == nil then attachment.children = {} end
    if attachment.options == nil then attachment.options = {} end
    if attachment.offset == nil then attachment.offset = { x = 0, y = 0, z = 0 } end
    if attachment.rotation == nil then attachment.rotation = { x = 0, y = 0, z = 0 } end
    if attachment.heading == nil then
        attachment.heading = (attachment.root and attachment.root.heading or 0)
    end
    if attachment.is_visible == nil then attachment.is_visible = true end
    if attachment.has_gravity == nil then attachment.has_gravity = false end
    if attachment.has_collision == nil then attachment.has_collision = false end
    if attachment.is_preview == nil then attachment.is_preview = false end
    if attachment.is_networked == nil then attachment.is_networked = not attachment.is_preview end
    if attachment.is_invincible == nil then attachment.is_invincible = true end
    if attachment.use_soft_pinning == nil then attachment.use_soft_pinning = true end
    if attachment.bone_index == nil then attachment.bone_index = 0 end
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
    if attachment.name == nil then attachment.name = attachment.model end
end

constructor_lib.update_attachment = function(attachment)

    if constructor_lib.debug then util.log("Updating attachment "..attachment.name.." ["..attachment.handle.."]") end

    ENTITY.SET_ENTITY_VISIBLE(attachment.handle, attachment.is_visible, 0)
    ENTITY.SET_ENTITY_HAS_GRAVITY(attachment.handle, attachment.has_gravity)

    if attachment == attachment.parent then
        ENTITY.SET_ENTITY_ROTATION(attachment.handle, attachment.rotation.x or 0, attachment.rotation.y or 0, attachment.rotation.z or 0)
        if attachment.position ~= nil then
            if attachment.is_preview then
                ENTITY.SET_ENTITY_COORDS_NO_OFFSET(
                        attachment.handle,
                        attachment.position.x,
                        attachment.position.y,
                        attachment.position.z,
                        true, false, false
                )
            else
                ENTITY.SET_ENTITY_COORDS(
                    attachment.handle,
                    attachment.position.x + attachment.offset.x,
                    attachment.position.y + attachment.offset.y,
                    attachment.position.z + attachment.offset.z,
                    true, false, false
                )
            end
        end
    else
        ENTITY.ATTACH_ENTITY_TO_ENTITY(
            attachment.handle, attachment.parent.handle, attachment.bone_index,
            attachment.offset.x or 0, attachment.offset.y or 0, attachment.offset.z or 0,
            attachment.rotation.x or 0, attachment.rotation.y or 0, attachment.rotation.z or 0,
            false, attachment.use_soft_pinning, attachment.has_collision, false, 2, true
        )
    end

end

constructor_lib.load_hash_for_attachment = function(attachment)
    if not STREAMING.IS_MODEL_VALID(attachment.hash) then
        if not STREAMING.IS_MODEL_A_VEHICLE(attachment.hash) then
            util.toast("Error attaching: Invalid model: " .. attachment.model, TOAST_ALL)
        end
        attachment.type = "VEHICLE"
    end
    constructor_lib.load_hash(attachment.hash)
end

constructor_lib.build_parent_child_relationship = function(parent_attachment, child_attachment)
    child_attachment.parent = parent_attachment
    child_attachment.root = parent_attachment.root
end

constructor_lib.attach_attachment = function(attachment)
    constructor_lib.set_attachment_defaults(attachment)
    if constructor_lib.debug then util.log("Attaching attachment "..attachment.name.." [parent="..attachment.parent.name..",root="..attachment.root.name.."]") end
    constructor_lib.load_hash_for_attachment(attachment)

    if attachment.root == nil then
        error("Attachment missing root")
    end

    if attachment.type == "VEHICLE" then
        attachment.handle = entities.create_vehicle(attachment.hash, attachment.offset, attachment.heading)
        constructor_lib.deserialize_vehicle_attributes(attachment)
    elseif attachment.type == "PED" then
        local pos = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(attachment.parent.handle, attachment.offset.x, attachment.offset.y, attachment.offset.z)
        attachment.handle = entities.create_ped(1, attachment.hash, pos, 0.0)
        if attachment.parent.type == "VEHICLE" then
            PED.SET_PED_INTO_VEHICLE(attachment.handle, attachment.parent.handle, -1)
        end
    else
        local pos
        if attachment.position ~= nil then
            pos = attachment.position
        else
            pos = ENTITY.GET_ENTITY_COORDS(attachment.root.handle)
        end
        -- TODO: CFX for networking maps?
        attachment.handle = OBJECT.CREATE_OBJECT_NO_OFFSET(attachment.hash, pos.x, pos.y, pos.z, attachment.is_networked, true, false)
        --args.handle = entities.create_object(hash, ENTITY.GET_ENTITY_COORDS(args.root.handle))
    end

    if not attachment.handle then
        error("Error attaching attachment. Could not create handle.")
    end

    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(attachment.hash)

    if attachment.num_bones == nil then attachment.num_bones = ENTITY._GET_ENTITY_BONE_COUNT(attachment.handle) end
    if attachment.type == nil then attachment.type = ENTITY_TYPES[ENTITY.GET_ENTITY_TYPE(attachment.handle)] end
    if attachment.flash_start_on ~= nil then ENTITY.SET_ENTITY_VISIBLE(attachment.handle, attachment.flash_start_on, 0) end
    if attachment.is_invincible ~= nil then ENTITY.SET_ENTITY_INVINCIBLE(attachment.handle, attachment.is_invincible) end
    if attachment.alpha ~= nil then ENTITY.SET_ENTITY_ALPHA(attachment.handle, attachment.alpha) end
    if attachment.root.is_preview == true then
        ENTITY.SET_ENTITY_ALPHA(attachment.handle, 206)
        ENTITY.SET_ENTITY_COMPLETELY_DISABLE_COLLISION(attachment.handle, false, false)
    end

    constructor_lib.update_attachment(attachment)
    constructor_lib.set_attachment_internal_collisions(attachment.root, attachment)

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
end

constructor_lib.detach_attachment = function(attachment)
    table.array_remove(attachment.children, function(t, i)
        local child_attachment = t[i]
        constructor_lib.detach_attachment(child_attachment)
        return false
    end)
    --if attachment ~= attachment.root then
        entities.delete_by_handle(attachment.handle)
    --end
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
        constructor_lib.detach_attachment(attachment)
    else
        table.array_remove(attachment.parent.children, function(t, i)
            local child_attachment = t[i]
            if child_attachment.handle == attachment.handle then
                constructor_lib.detach_attachment(attachment)
                return false
            end
            return true
        end)
        attachment.parent.menus.refresh()
        attachment.parent.menus.focus()
    end
end

constructor_lib.reattach_attachment_with_children = function(attachment)
    --if attachment.root ~= attachment then
        constructor_lib.attach_attachment(attachment)
    --end
    for _, child_attachment in pairs(attachment.children) do
        child_attachment.root = attachment.root
        child_attachment.parent = attachment
        constructor_lib.reattach_attachment_with_children(child_attachment)
    end
end

constructor_lib.attach_attachment_with_children = function(new_attachment)
    if constructor_lib.debug then util.log("Attaching attachment with children "..(new_attachment.name or new_attachment.model or new_attachment.hash)) end
    local attachment = constructor_lib.attach_attachment(new_attachment)
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
    constructor_lib.deserialize_vehicle_headlights(vehicle, serialized_vehicle)
    constructor_lib.deserialize_vehicle_options(vehicle, serialized_vehicle)
    constructor_lib.deserialize_vehicle_mods(vehicle, serialized_vehicle)
    constructor_lib.deserialize_vehicle_extras(vehicle, serialized_vehicle)

    --ENTITY.SET_ENTITY_AS_MISSION_ENTITY(vehicle.handle, true, true)

end

constructor_lib.copy_serializable = function(attachment)
    local serializeable_attachment = {
        children = {}
    }
    for k, v in pairs(attachment) do
        if not (k == "handle" or k == "root" or k == "parent" or k == "menus" or k == "children") then
            serializeable_attachment[k] = v
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
            table.insert(serialized_attachment.children, constructor_lib.serialize_attachment(child_attachment))
        end
    end
    --util.toast(inspect(serialized_attachment), TOAST_ALL)
    return serialized_attachment
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

local function elementText(el)
    local pieces = {}
    for _,n in ipairs(el.kids) do
        if n.type=='element' then pieces[#pieces+1] = elementText(n)
        elseif n.type=='text' then pieces[#pieces+1] = n.value
        end
    end
    return table.concat(pieces)
end

local function toboolean(value)
    return (value == true or value == "true")
end

local xml_field_to_construct_plan_map = {
    {
        xml_path=".ModelHash",
        construct_plan_path="hash",
        formatter=tonumber,
    },
    {
        xml_path=".InitialHandle",
        construct_plan_path="initial_handle",
        formatter=tonumber,
    },
    {
        xml_path=".Type",
        construct_plan_path="type",
        formatter=function(value) return ENTITY_TYPES[value] end
    },
    {
        xml_path=".IsVisible",
        construct_plan_path="is_visible",
        formatter=toboolean,
    },
    {
        xml_path=".OpacityLevel",
        construct_plan_path="alpha",
        formatter=tonumber,
    },
    {
        xml_path=".HasGravity",
        construct_plan_path="has_gravity",
        formatter=toboolean,
    },
    {
        xml_path=".IsInvincible",
        construct_plan_path="is_invincible",
        formatter=toboolean,
    },
    {
        xml_path=".FrozenPos",
        construct_plan_path="is_frozen",
        formatter=toboolean,
    },
    {
        xml_path=".IsCollisionProof",
        construct_plan_path="has_collision",
        formatter=function(value) return not toboolean(value) end,
    },
    {
        xml_path=".Attachment.AttachedTo",
        construct_plan_path="parents_initial_handle",
        formatter=tonumber,
    },
    {
        xml_path=".Attachment.X",
        construct_plan_path="offset.x",
        formatter=tonumber,
    },
    {
        xml_path=".Attachment.Y",
        construct_plan_path="offset.y",
        formatter=tonumber,
    },
    {
        xml_path=".Attachment.Z",
        construct_plan_path="offset.z",
        formatter=tonumber,
    },
    {
        xml_path=".Attachment.Pitch",
        construct_plan_path="rotation.x",
        formatter=tonumber,
    },
    {
        xml_path=".Attachment.Roll",
        construct_plan_path="rotation.y",
        formatter=tonumber,
    },
    {
        xml_path=".Attachment.Yaw",
        construct_plan_path="rotation.z",
        formatter=tonumber,
    },
    {
        xml_path=".Attachment.BoneIndex",
        construct_plan_path="bone_index",
        formatter=tonumber,
    },
    {
        xml_path=".PositionRotation.X",
        construct_plan_path="position.x",
        formatter=tonumber,
    },
    {
        xml_path=".PositionRotation.Y",
        construct_plan_path="position.y",
        formatter=tonumber,
    },
    {
        xml_path=".PositionRotation.Z",
        construct_plan_path="position.z",
        formatter=tonumber,
    },
    -- No concept of offset rotation yet
    --{
    --    xml_path=".PositionRotation.Pitch",
    --    construct_plan_path="rotation.x",
    --    formatter=tonumber,
    --},
    --{
    --    xml_path=".PositionRotation.Roll",
    --    construct_plan_path="rotation.y",
    --    formatter=tonumber,
    --},
    --{
    --    xml_path=".PositionRotation.Yaw",
    --    construct_plan_path="rotation.z",
    --    formatter=tonumber,
    --},
    {
        xml_path=".VehicleProperties.Livery",
        construct_plan_path="vehicle_attributes.paint.livery",
        formatter=tonumber,
    },
    {
        xml_path=".VehicleProperties.NumberPlateIndex",
        construct_plan_path="vehicle_attributes.options.license_plate_type",
        formatter=tonumber,
    },
    {
        xml_path=".VehicleProperties.NumberPlateText",
        construct_plan_path="vehicle_attributes.options.license_plate_text",
    },
    {
        xml_path=".VehicleProperties.WheelType",
        construct_plan_path="vehicle_attributes.wheels.wheel_type",
        formatter=tonumber,
    },
    {
        xml_path=".VehicleProperties.DirtLevel",
        construct_plan_path="vehicle_attributes.paint.dirt_level",
        formatter=tonumber,
    },
    {
        xml_path=".VehicleProperties.PaintFade",
        construct_plan_path="vehicle_attributes.paint.fade",
        formatter=tonumber,
    },
    {
        xml_path=".VehicleProperties.BulletProofTyres",
        construct_plan_path="vehicle_attributes.wheels.bulletproof_tires",
        formatter=toboolean,
    },
    {
        xml_path=".VehicleProperties.SirenActive",
        construct_plan_path="vehicle_attributes.options.siren",
    },
    {
        xml_path=".VehicleProperties.HeadlightIntensity",
        construct_plan_path="vehicle_attributes.headlights.multiplier",
        formatter=tonumber,
    },
    {
        xml_path=".VehicleProperties.WindowTint",
        construct_plan_path="vehicle_attributes.options.window_tint",
        formatter=tonumber,
    },
    {
        xml_path=".VehicleProperties.EngineOn",
        construct_plan_path="vehicle_attributes.options.engine_running",
    },
    {
        xml_path=".VehicleProperties.IsRadioLoud",
        construct_plan_path="vehicle_attributes.options.radio_loud",
    },
    {
        xml_path=".VehicleProperties.Colours.Primary",
        construct_plan_path="vehicle_attributes.paint.primary.vehicle_standard_color",
        formatter=tonumber,
    },
    {
        xml_path=".VehicleProperties.Colours.IsPrimaryColourCustom",
        construct_plan_path="vehicle_attributes.paint.primary.is_custom",
        formatter=toboolean,
    },
    {
        xml_path=".VehicleProperties.Colours.Cust1_R",
        construct_plan_path="vehicle_attributes.paint.primary.custom_color.r",
        formatter=tonumber,
    },
    {
        xml_path=".VehicleProperties.Colours.Cust1_G",
        construct_plan_path="vehicle_attributes.paint.primary.custom_color.g",
        formatter=tonumber,
    },
    {
        xml_path=".VehicleProperties.Colours.Cust1_B",
        construct_plan_path="vehicle_attributes.paint.primary.custom_color.b",
        formatter=tonumber,
    },
    {
        xml_path=".VehicleProperties.Colours.Secondary",
        construct_plan_path="vehicle_attributes.paint.secondary.vehicle_standard_color",
        formatter=tonumber,
    },
    {
        xml_path=".VehicleProperties.Colours.IsSecondaryColourCustom",
        construct_plan_path="vehicle_attributes.paint.secondary.is_custom",
        formatter=toboolean,
    },
    {
        xml_path=".VehicleProperties.Colours.Cust2_R",
        construct_plan_path="vehicle_attributes.paint.secondary.custom_color.r",
        formatter=tonumber,
    },
    {
        xml_path=".VehicleProperties.Colours.Cust2_G",
        construct_plan_path="vehicle_attributes.paint.secondary.custom_color.g",
        formatter=tonumber,
    },
    {
        xml_path=".VehicleProperties.Colours.Cust2_B",
        construct_plan_path="vehicle_attributes.paint.secondary.custom_color.b",
        formatter=tonumber,
    },
    {
        xml_path=".VehicleProperties.Colours.Pearl",
        construct_plan_path="vehicle_attributes.paint.extra_colors.pearlescent",
        formatter=tonumber,
    },
    {
        xml_path=".VehicleProperties.Colours.Rim",
        construct_plan_path="vehicle_attributes.paint.extra_colors.wheel",
        formatter=tonumber,
    },
    {
        xml_path=".VehicleProperties.Colours.LrXenonHeadlights",
        construct_plan_path="vehicle_attributes.headlights.headlights_color",
        formatter=tonumber,
    },
    {
        xml_path=".VehicleProperties.Colours.LrInterior",
        construct_plan_path="vehicle_attributes.paint.interior_color",
        formatter=tonumber,
    },
    {
        xml_path=".VehicleProperties.Colours.LrDashboard",
        construct_plan_path="vehicle_attributes.paint.dashboard_color",
        formatter=tonumber,
    },
    {
        xml_path=".VehicleProperties.Colours.tyreSmoke_R",
        construct_plan_path="vehicle_attributes.wheels.tire_smoke_color.r",
        formatter=tonumber,
    },
    {
        xml_path=".VehicleProperties.Colours.tyreSmoke_G",
        construct_plan_path="vehicle_attributes.wheels.tire_smoke_color.g",
        formatter=tonumber,
    },
    {
        xml_path=".VehicleProperties.Colours.tyreSmoke_B",
        construct_plan_path="vehicle_attributes.wheels.tire_smoke_color.b",
        formatter=tonumber,
    },
    {
        xml_path=".VehicleProperties.Neons.Left",
        construct_plan_path="vehicle_attributes.neon.lights.left",
        formatter=toboolean,
    },
    {
        xml_path=".VehicleProperties.Neons.Right",
        construct_plan_path="vehicle_attributes.neon.lights.right",
        formatter=toboolean,
    },
    {
        xml_path=".VehicleProperties.Neons.Front",
        construct_plan_path="vehicle_attributes.neon.lights.front",
        formatter=toboolean,
    },
    {
        xml_path=".VehicleProperties.Neons.Back",
        construct_plan_path="vehicle_attributes.neon.lights.back",
        formatter=toboolean,
    },
    {
        xml_path=".VehicleProperties.Neons.R",
        construct_plan_path="vehicle_attributes.neon.color.r",
        formatter=tonumber,
    },
    {
        xml_path=".VehicleProperties.Neons.G",
        construct_plan_path="vehicle_attributes.neon.color.g",
        formatter=tonumber,
    },
    {
        xml_path=".VehicleProperties.Neons.B",
        construct_plan_path="vehicle_attributes.neon.color.b",
        formatter=tonumber,
    },
    --[""] = "",
}
for mod_index = 0, 49 do
    local formatter = function(value)
        if type(value) == "table" then
            return value[1]
        end
        if type(value) == "string" then
            local split = strsplit(value, ",")
            return split[1]
        end
    end
    if mod_index >= 17 and mod_index <= 22 then formatter = toboolean end
    table.insert(xml_field_to_construct_plan_map, {
        xml_path=".VehicleProperties.Mods._"..(mod_index-1),
        construct_plan_path="vehicle_attributes.mods._"..mod_index,
        formatter=formatter
    })
end
for extra_index = 0, 14 do
    table.insert(xml_field_to_construct_plan_map, {
        xml_path=".VehicleProperties.ModExtras._"..(extra_index-1),
        construct_plan_path="vehicle_attributes.extras._"..extra_index,
        formatter=toboolean
    })
end

local function set_with_dot_path(root, dot_path, value)
    -- Convert a dot notation path into array selector path. Why is this so hard?
    local path_parts = strsplit(dot_path, ".")
    local save_path = root
    while #path_parts > 1 do
        local path_step = path_parts[1]
        if #path_parts > 1 and save_path[path_step] == nil then
            save_path[path_step] = {}
        end
        save_path = save_path[path_step]
        table.remove(path_parts, 1)
    end
    save_path[path_parts[1]] = value
end

local function find_element(el, query, path)
    if path == nil then path = "" end
    path = path.."."..el.name
    --util.log("Checking "..query.."=="..path.." value="..elementText(el))
    if query == path then
        --util.log("Found!")
        if el.kids == nil or (#el.kids == 1 and el.kids[1].type == "text") then
            return elementText(el)
        else
            return el
        end
    end
    for _,field in ipairs(el.kids) do
        if field.type == "element" then
            local value = find_element(field, query, path)
            if value ~= nil then
                return value
            end
        end
    end
end

local function process_vehicle_element(el, construct_plan, prefix)
    for _, mapped_field in pairs(xml_field_to_construct_plan_map) do
        local query = prefix..mapped_field.xml_path
        --util.log("Searching "..query)
        local value = find_element(el, query, "")
        if value ~= nil then
            --util.log("Found "..query.." value="..tostring(value))
            if mapped_field.formatter then
                value = mapped_field.formatter(value)
            end
            set_with_dot_path(construct_plan, mapped_field.construct_plan_path, value)
        end
    end
end

constructor_lib.convert_xml_to_construct_plan = function(xmldata)
    local dom = slaxdom:dom(xmldata, {stripWhitespace=true})

    local construct_plan = table.table_copy(construct_base)

    if dom.root.name == "Vehicle" then
        construct_plan.type = "VEHICLE"
    elseif dom.root.name == "SpoonerPlacements" then
        construct_plan.type = "OBJECT"
    end

    process_vehicle_element(dom.root, construct_plan, ".Vehicle")
    constructor_lib.set_attachment_defaults(construct_plan)

    local spooner_attachments_el = find_element(dom.root, ".Vehicle.SpoonerAttachments")
    --util.log("Spooner attachments el "..tostring(spooner_attachments_el))
    if spooner_attachments_el then
        for _, child_attachment in pairs(spooner_attachments_el.kids) do
            if child_attachment.type == "element" then
                local attachment = {}
                process_vehicle_element(child_attachment, attachment, ".Attachment")
                constructor_lib.set_attachment_defaults(attachment)
                table.insert(construct_plan.children, attachment)
            end
        end
    end

    --util.log("Loaded XML construct plan "..inspect(construct_plan))

    --if construct_plan.model == nil then
    --    construct_plan.model = util.reverse_joaat(construct_plan.hash)
    --end
    --if construct_plan.name == nil then
    --    construct_plan.name = construct_plan.model
    --end

    return construct_plan
end

---
--- Return
---

return constructor_lib
