-- Constructor Lib
-- by Hexarobi
-- A Lua Script for the Stand mod menu for GTA5
-- Allows for constructing custom vehicles and maps
-- https://github.com/hexarobi/stand-lua-constructor

local LIB_VERSION = "3.3"

local constructor_lib = {
    LIB_VERSION = LIB_VERSION,
    debug = true
}

---
--- Utilities
---

util.require_natives(1660775568)

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
--- Specific Serializers
---

constructor_lib.serialize_vehicle_headlights = function(vehicle, serialized_vehicle)
    if serialized_vehicle.headlights == nil then serialized_vehicle.headlights = {} end
    serialized_vehicle.headlights.headlights_color = VEHICLE._GET_VEHICLE_XENON_LIGHTS_COLOR(vehicle.handle)
    serialized_vehicle.headlights.headlights_type = VEHICLE.IS_TOGGLE_MOD_ON(vehicle.handle, 22)
    return serialized_vehicle
end

constructor_lib.deserialize_vehicle_headlights = function(vehicle, serialized_vehicle)
    VEHICLE._SET_VEHICLE_XENON_LIGHTS_COLOR(vehicle.handle, serialized_vehicle.headlights.headlights_color)
    VEHICLE.TOGGLE_VEHICLE_MOD(vehicle.handle, 22, serialized_vehicle.headlights.headlights_type or false)
end

constructor_lib.serialize_vehicle_paint = function(vehicle, serialized_vehicle)
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

constructor_lib.deserialize_vehicle_paint = function(vehicle, serialized_vehicle)

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

constructor_lib.serialize_vehicle_neon = function(vehicle, serialized_vehicle)
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

constructor_lib.deserialize_vehicle_neon = function(vehicle, serialized_vehicle)
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
    local color = { r = memory.alloc(4), g = memory.alloc(4), b = memory.alloc(4) }
    VEHICLE.GET_VEHICLE_TYRE_SMOKE_COLOR(vehicle.handle, color.r, color.g, color.b)
    serialized_vehicle.wheels.tire_smoke_color = { r = memory.read_int(color.r), g = memory.read_int(color.g), b = memory.read_int(color.b) }
    memory.free(color.r) memory.free(color.g) memory.free(color.b)
end

constructor_lib.deserialize_vehicle_wheels = function(vehicle, serialized_vehicle)
    VEHICLE.SET_VEHICLE_TYRES_CAN_BURST(vehicle.handle, serialized_vehicle.bulletproof_tires or false)
    VEHICLE.SET_VEHICLE_WHEEL_TYPE(vehicle.handle, serialized_vehicle.wheel_type or -1)
    if serialized_vehicle.tire_smoke_color then
        VEHICLE.SET_VEHICLE_TYRE_SMOKE_COLOR(vehicle.handle, serialized_vehicle.tire_smoke_color.r or 255,
                serialized_vehicle.tire_smoke_color.g or 255, serialized_vehicle.tire_smoke_color.b or 255)
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

constructor_lib.set_attachment_internal_collisions = function(attachment, new_attachment)
    ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(attachment.handle, new_attachment.handle)
    for _, child_attachment in pairs(attachment.children) do
        constructor_lib.set_attachment_internal_collisions(child_attachment, new_attachment)
    end
end

constructor_lib.set_attachment_defaults = function(attachment)
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

constructor_lib.update_attachment = function(attachment)

    if constructor_lib.debug then util.log("Updating attachment "..attachment.name.." ["..attachment.handle.."]") end

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

constructor_lib.load_hash_for_attachment = function(attachment)
    if not STREAMING.IS_MODEL_VALID(attachment.hash) then
        if not STREAMING.IS_MODEL_A_VEHICLE(attachment.hash) then
            error("Error attaching: Invalid model: " .. attachment.model)
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

constructor_lib.remove_attachment_from_parent = function(attachment)
    table.array_remove(attachment.parent.children, function(t, i)
        local child_attachment = t[i]
        if child_attachment.handle == attachment.handle then
            constructor_lib.detach_attachment(attachment)
            return false
        end
        return true
    end)
end

constructor_lib.reattach_attachment_with_children = function(attachment)
    if attachment.root ~= attachment then
        constructor_lib.attach_attachment(attachment)
    end
    for _, child_attachment in pairs(attachment.children) do
        child_attachment.root = attachment.root
        child_attachment.parent = attachment
        constructor_lib.reattach_attachment_with_children(child_attachment)
    end
end

constructor_lib.attach_attachment_with_children = function(new_attachment)
    if constructor_lib.debug then util.log("Attaching attachment with children "..(new_attachment.name or new_attachment.model)) end
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
    attachment.root.menus.refresh()
    if attachment.root.menus.focus_menu then
        menu.focus(attachment.root.menus.focus_menu)
    end
end

constructor_lib.clone_attachment = function(attachment)
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

    VEHICLE.SET_VEHICLE_MOD_KIT(vehicle.handle, 0)

    constructor_lib.deserialize_vehicle_neon(vehicle, serialized_vehicle)
    constructor_lib.deserialize_vehicle_paint(vehicle, serialized_vehicle)
    constructor_lib.deserialize_vehicle_wheels(vehicle, serialized_vehicle)
    constructor_lib.deserialize_vehicle_headlights(vehicle, serialized_vehicle)
    constructor_lib.deserialize_vehicle_options(vehicle, serialized_vehicle)
    constructor_lib.deserialize_vehicle_mods(vehicle, serialized_vehicle)
    constructor_lib.deserialize_vehicle_extras(vehicle, serialized_vehicle)

    ENTITY.SET_ENTITY_AS_MISSION_ENTITY(vehicle.handle, true, true)

end

constructor_lib.copy_serializable = function(attachment)
    local serializeable_attachment = {
        children = {}
    }
    for k, v in pairs(attachment) do
        if not (k == "handle" or k == "root" or k == "parent" or k == "menus" or k == "children" or k == "base_name") then
            serializeable_attachment[k] = v
        end
    end
    return serializeable_attachment
end

constructor_lib.serialize_attachment = function(attachment)
    local serialized_attachment = constructor_lib.copy_serializable(attachment)
    serialized_attachment.vehicle_attributes = constructor_lib.serialize_vehicle_attributes(attachment)
    for _, child_attachment in pairs(attachment.children) do
        table.insert(serialized_attachment.children, constructor_lib.serialize_attachment(child_attachment))
    end
    --util.toast(inspect(serialized_attachment), TOAST_ALL)
    return serialized_attachment
end

return constructor_lib
