-- Constructor Lib
-- by Hexarobi
-- A Lua Script for the Stand mod menu for GTA5
-- Allows for constructing custom vehicles and maps
-- https://github.com/hexarobi/stand-lua-constructor

local SCRIPT_VERSION = "3.26b5"

local constructor_lib = {
    LIB_VERSION = SCRIPT_VERSION
}

---
--- Dependencies
---

util.ensure_package_is_installed('lua/natives-1663599433')
util.require_natives(1663599433)
local status_natives, natives = pcall(require, "natives-1663599433")
if not status_natives then error("Could not natives lib. Make sure it is selected under Stand > Lua Scripts > Repository > natives-1663599433") end

local status_inspect, inspect = pcall(require, "inspect")
if not status_inspect then error("Could not load inspect lib. This should have been auto-installed.") end

local status_constants, constants = pcall(require, "constructor/constants")
if not status_constants then error("Could not load constants lib. This should have been auto-installed.") end

---
--- Data
---

constructor_lib.ENTITY_TYPES = {"PED", "VEHICLE", "OBJECT"}

constructor_lib.construct_base = {
    target_version = constructor_lib.LIB_VERSION,
    children = {},
    options = {},
    temp = {},
    position = {x=0,y=0,z=0},
    offset = {x=0,y=0,z=0},
    rotation = {x=0,y=0,z=0},
    world_rotation = {x=0,y=0,z=0},
    num_bones = 200,
    heading = 0,
    blip_icon = 1,
    blip_color = 2,
}

---
--- Utilities
---

local function t(text)
    return CONSTRUCTOR_TRANSLATE_FUNCTION(text)
end

local function debug_log(message, additional_details)
    if CONSTRUCTOR_CONFIG.debug_mode then
        if CONSTRUCTOR_CONFIG.debug_mode == 2 and additional_details ~= nil then
            message = message .. "\n" .. inspect(additional_details)
        end
        util.log("[constructor_lib] "..message)
    end
end

constructor_lib.table_copy = function(obj)
    if type(obj) ~= 'table' then
        return obj
    end
    local res = setmetatable({}, getmetatable(obj))
    for k, v in pairs(obj) do
        res[constructor_lib.table_copy(k)] = constructor_lib.table_copy(v)
    end
    return res
end

constructor_lib.string_starts = function(String,Start)
    return string.sub(String,1,string.len(Start))==Start
end

-- From https://stackoverflow.com/questions/12394841/safely-remove-items-from-an-array-table-while-iterating
constructor_lib.array_remove = function(t, fnKeep)
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

---
--- Attachment Construction
---

local unique_id_counter = 0
local function get_unique_id()
    unique_id_counter = unique_id_counter + 1
    return unique_id_counter
end

constructor_lib.default_attachment_attributes = function(attachment)
    debug_log("Defaulting attachment attributes "..tostring(attachment.name))
    if attachment.id == nil then attachment.id = get_unique_id() end
    if attachment.children == nil then attachment.children = {} end
    if attachment.temp == nil then attachment.temp = {} end
    if attachment.type == "PARTICLE" then
        constructor_lib.default_particle_attributes(attachment)
    else
        constructor_lib.default_entity_attributes(attachment)
    end

end

constructor_lib.default_entity_attributes = function(attachment)
    debug_log("Defaulting entity attributes "..tostring(attachment.name))
    if attachment.offset == nil or attachment.offset == {} then attachment.offset = { x = 0, y = 0, z = 0 } end
    if attachment.rotation == nil or attachment.rotation == {} then attachment.rotation = { x = 0, y = 0, z = 0 } end
    if attachment.rotation_axis == nil then attachment.rotation_axis = 2 end
    if attachment.position == nil or attachment.position == {} then attachment.position = { x = 0, y = 0, z = 0 } end
    if attachment.world_rotation == nil or attachment.world_rotation == {} then attachment.world_rotation = { x = 0, y = 0, z = 0 } end
    if attachment.heading == nil then
        attachment.heading = (attachment.root and attachment.root.heading or 0)
    end
    if attachment.options == nil then attachment.options = {} end
    if attachment.options.is_visible == nil then attachment.options.is_visible = true end
    if attachment.options.alpha == nil then attachment.options.alpha = 255 end
    if attachment.options.has_gravity == nil then attachment.options.has_gravity = true end
    if attachment.options.has_collision == nil then
        attachment.options.has_collision = true
        if attachment.root ~= nil and attachment.root.type == "PED" then
            attachment.options.has_collision = false
        end
    end
    if attachment.root ~= nil and attachment.root.is_preview then attachment.is_preview = true end
    if attachment.options.is_networked == nil and (attachment.root ~= nil and not attachment.root.is_preview) then
        attachment.options.is_networked = true
    end
    if attachment.options.is_mission_entity == nil then attachment.options.is_mission_entity = true end
    if attachment.options.is_invincible == nil then attachment.options.is_invincible = false end
    if attachment.options.is_bullet_proof == nil then attachment.options.is_bullet_proof = false end
    if attachment.options.is_fire_proof == nil then attachment.options.is_fire_proof = false end
    if attachment.options.is_explosion_proof == nil then attachment.options.is_explosion_proof = false end
    if attachment.options.is_melee_proof == nil then attachment.options.is_melee_proof = false end
    if attachment.options.is_light_on == nil then attachment.options.is_light_on = true end
    if attachment.options.use_soft_pinning == nil then attachment.options.use_soft_pinning = true end
    if attachment.options.bone_index == nil then attachment.options.bone_index = 0 end
    if attachment.options.is_dynamic == nil then attachment.options.is_dynamic = true end
    if attachment.options.lod_distance == nil then attachment.options.lod_distance = 16960 end
    if attachment.options.is_attached == nil then attachment.options.is_attached = (attachment ~= attachment.parent) end
    if attachment.options.is_frozen == nil and attachment.options.is_attached ~= true and attachment.type == "OBJECT" then
        attachment.options.is_frozen = true
    end
    if attachment == attachment.parent then
        if attachment.blip_sprite == nil then attachment.blip_sprite = 1 end
        if attachment.blip_color == nil then attachment.blip_color = 2 end
    end
    constructor_lib.serialize_hash_and_model(attachment)
    if attachment.name == nil then attachment.name = attachment.model end
    constructor_lib.default_vehicle_attributes(attachment)
    constructor_lib.default_ped_attributes(attachment)
end

constructor_lib.deserialize_entity_attributes = function(attachment)

    if attachment.is_preview then
        constructor_lib.set_preview_visibility(attachment)
    else
        if attachment.options.alpha ~= nil then
            if attachment.options.alpha < 255 then
                ENTITY.SET_ENTITY_ALPHA(attachment.handle, attachment.options.alpha, false)
            else
                ENTITY.RESET_ENTITY_ALPHA(attachment.handle)
            end
        end
        if attachment.options.is_visible ~= nil then
            ENTITY.SET_ENTITY_VISIBLE(attachment.handle, attachment.options.is_visible, 0)
        end
    end

    if attachment.num_bones == nil or attachment.num_bones == 200 then attachment.num_bones = ENTITY.GET_ENTITY_BONE_COUNT(attachment.handle) end
    if attachment.type == nil then attachment.type = constructor_lib.ENTITY_TYPES[ENTITY.GET_ENTITY_TYPE(attachment.handle)] end
    if attachment.flash_start_on ~= nil then ENTITY.SET_ENTITY_VISIBLE(attachment.handle, attachment.flash_start_on, 0) end
    if attachment.options.is_invincible ~= nil then ENTITY.SET_ENTITY_INVINCIBLE(attachment.handle, attachment.options.is_invincible) end
    if attachment.options.is_scorched ~= nil then ENTITY.SET_ENTITY_RENDER_SCORCHED(attachment.handle, attachment.options.is_scorched) end
    if attachment.options.radio_loud ~= nil then AUDIO.SET_VEHICLE_RADIO_LOUD(attachment.handle, attachment.options.radio_loud) end
    if attachment.options.lod_distance ~= nil then ENTITY.SET_ENTITY_LOD_DIST(attachment.handle, attachment.options.lod_distance) end

    if attachment.options.is_dynamic ~= nil then ENTITY.SET_ENTITY_DYNAMIC(attachment.handle, attachment.options.is_dynamic) end
    if attachment.options.has_gravity ~= nil then ENTITY.SET_ENTITY_HAS_GRAVITY(attachment.handle, attachment.options.has_gravity) end
    if attachment.options.is_light_on == true then
        VEHICLE.SET_VEHICLE_SIREN(attachment.handle, true)
        VEHICLE.SET_VEHICLE_HAS_MUTED_SIRENS(attachment.handle, true)
        ENTITY.SET_ENTITY_LIGHTS(attachment.handle, false)
        AUDIO.TRIGGER_SIREN_AUDIO(attachment.handle, true)
        AUDIO.SET_SIREN_BYPASS_MP_DRIVER_CHECK(attachment.handle, true)
    end
    if (attachment.options.is_bullet_proof ~= nil or attachment.options.is_fire_proof ~= nil
        or attachment.options.is_explosion_proof ~= nil or attachment.options.is_melee_proof ~= nil)
        and attachment.options.is_on_fire == nil
    then
        ENTITY.SET_ENTITY_PROOFS(
                attachment.handle,
                attachment.options.is_bullet_proof, attachment.options.is_fire_proof,
                attachment.options.is_explosion_proof, attachment.options.is_melee_proof,
                false, 0, false
        )
    end

end

constructor_lib.attach_entity = function(attachment)
    --debug_log("Updating attachment "..tostring(attachment.name))
    constructor_lib.deserialize_entity_attributes(attachment)
    if attachment.options.is_attached then
        if attachment.type == "PED" and attachment.parent.is_player then
            util.toast("Cannot attach ped to player. Spawning new ped "..tostring(attachment.name), TOAST_ALL)
        else
            if attachment == attachment.parent then
                debug_log("Cannot attach attachment to itself "..tostring(attachment.name))
            else
                debug_log("Attaching entity to entity "..tostring(attachment.name))
                ENTITY.ATTACH_ENTITY_TO_ENTITY(
                        attachment.handle, attachment.parent.handle, attachment.options.bone_index,
                        attachment.offset.x or 0, attachment.offset.y or 0, attachment.offset.z or 0,
                        attachment.rotation.x or 0, attachment.rotation.y or 0, attachment.rotation.z or 0,
                        false, attachment.options.use_soft_pinning, attachment.options.has_collision, false, attachment.rotation_axis, true
                )
            end
        end
    else
        if attachment.options.is_frozen ~= nil then
            ENTITY.FREEZE_ENTITY_POSITION(attachment.handle, attachment.options.is_frozen)
        end
        if attachment.options.is_frozen and attachment.options.has_collision ~= nil then
            ENTITY.SET_ENTITY_COMPLETELY_DISABLE_COLLISION(attachment.handle, attachment.options.has_collision, true)
        end
    end
end

constructor_lib.attach_particle = function(attachment)
    if attachment.type ~= "PARTICLE" or attachment.particle_attributes == nil then return end
    constructor_lib.default_particle_attributes(attachment)
    constructor_lib.load_particle_fx_asset(attachment.particle_attributes.asset)
    GRAPHICS.USE_PARTICLE_FX_ASSET(attachment.particle_attributes.asset)
    GRAPHICS.START_PARTICLE_FX_NON_LOOPED_ON_ENTITY_BONE(
            attachment.particle_attributes.effect_name,
            attachment.parent.handle,
            0.0, 0.0, 0.0,
            0.0, 0.0, 0.0,
            attachment.particle_attributes.bone_index,
            attachment.particle_attributes.scale,
            false, false, false
    )

    --    if ENTITY.DOES_ENTITY_EXIST(vehicle) and not ENTITY.IS_ENTITY_DEAD(vehicle, false) and
    --            VEHICLE.IS_VEHICLE_DRIVEABLE(vehicle, false) and lastEffect.elapsed() > effect[4] then
    --        constructor_lib.load_particle_fx_asset(effect[1])
    --        for _, boneName in pairs({"wheel_lf", "wheel_lr", "wheel_rf", "wheel_rr"}) do
    --            local bone = ENTITY.GET_ENTITY_BONE_INDEX_BY_NAME(vehicle, boneName)
    --
    --            GRAPHICS.USE_PARTICLE_FX_ASSET(effect[1])
    --            GRAPHICS.START_PARTICLE_FX_NON_LOOPED_ON_ENTITY_BONE(
    --                    effect[2],
    --                    vehicle,
    --                    0.0, 0.0, 0.0,
    --                    0.0, 0.0, 0.0,
    --                    bone,
    --                    effect[3],
    --                    false, false, false
    --            )
    --        end
end

---
--- Position
---

constructor_lib.update_attachment_position = function(attachment)
    --debug_log("Updating attachment position "..tostring(attachment.name))
    if attachment == attachment.parent or attachment.options.is_attached == false then
        debug_log("Updating attachment world rotation "..tostring(attachment.name))
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

constructor_lib.update_reflection_offsets = function(reflection)
    debug_log("Updating reflection offsets "..tostring(reflection.name))
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
    debug_log("Moving attachment "..tostring(attachment.name))
    if attachment.reflection then
        constructor_lib.update_reflection_offsets(attachment.reflection)
        constructor_lib.attach_entity(attachment.reflection)
    end
    constructor_lib.attach_entity(attachment)
    constructor_lib.update_attachment_position(attachment)
end

---
--- Adding
---

constructor_lib.build_parent_child_relationship = function(parent_attachment, child_attachment)
    child_attachment.parent = parent_attachment
    child_attachment.root = parent_attachment.root
end

constructor_lib.create_entity = function(attachment)
    constructor_lib.default_entity_attributes(attachment)
    if attachment.type == "PARTICLE" then
        constructor_lib.attach_particle(attachment)
        return
    end
    if attachment.is_player and attachment.is_preview ~= true then
        if attachment.model == nil and attachment.hash == nil then
            attachment.hash = ENTITY.GET_ENTITY_MODEL(players.user_ped())
            attachment.model = util.reverse_joaat(attachment.hash)
        else
            debug_log("Setting player model to "..tostring(attachment.model).." hash="..tostring(attachment.hash))
            constructor_lib.load_hash(attachment.hash)
            PLAYER.SET_PLAYER_MODEL(players.user(), attachment.hash)
            util.yield(100)
            attachment.handle = players.user_ped()
        end
        constructor_lib.deserialize_ped_attributes(attachment)
        return
    else
        debug_log("Attaching "..tostring(attachment.name).." to "..tostring(attachment.parent.name))
    end
    if attachment.hash == nil and attachment.model == nil then
        error(t("Cannot create attachment").." "..tostring(attachment.name)..": "..t("Requires either a hash or a model"))
    end
    if (not constructor_lib.load_hash_for_attachment(attachment)) then
        debug_log("Failed to load hash for attachment "..tostring(attachment.name))
        return
    end

    if attachment.root == nil then
        error(t("Attachment missing root"))
    end

    local is_networked = attachment.options.is_networked and not attachment.is_preview
    if attachment.type == "VEHICLE" then
        debug_log("Creating vehicle "..tostring(attachment.name))
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
        debug_log("Creating object "..tostring(attachment.name))
        local pos
        if attachment.position ~= nil then
            pos = attachment.position
        else
            pos = ENTITY.GET_ENTITY_COORDS(attachment.root.handle)
        end
        attachment.handle = OBJECT.CREATE_OBJECT_NO_OFFSET(
                attachment.hash,
                pos.x, pos.y, pos.z,
                is_networked,
                attachment.options.is_mission_entity,
                false
        )
        if is_networked then constructor_lib.make_entity_networked(attachment) end
    end

    if not attachment.handle then
        error(t("Error attaching attachment. Could not create handle."))
    end

    if attachment.root.is_preview == true then constructor_lib.set_preview_visibility(attachment) end
    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(attachment.hash)
    constructor_lib.set_attachment_internal_collisions(attachment.root, attachment)
    constructor_lib.deserialize_entity_attributes(attachment)
    constructor_lib.attach_entity(attachment)
    constructor_lib.update_attachment_position(attachment)
    constructor_lib.refresh_blip(attachment)

    util.yield(CONSTRUCTOR_CONFIG.spawn_entity_delay)

    --debug_log("Done attaching "..tostring(attachment.name))
    return attachment
end

constructor_lib.reattach_attachment_with_children = function(attachment)
    debug_log("Reattaching attachment with children "..tostring(attachment.name))
    constructor_lib.create_entity(attachment)
    for _, child_attachment in pairs(attachment.children) do
        child_attachment.root = attachment.root
        child_attachment.parent = attachment
        constructor_lib.reattach_attachment_with_children(child_attachment)
    end
end

constructor_lib.create_entity_with_children = function(new_attachment)
    debug_log("Attaching attachment with children "..tostring(new_attachment.name))
    for key, value in pairs(constructor_lib.construct_base) do
        if new_attachment[key] == nil then
            new_attachment[key] = (value)
        end
    end
    local attachment = constructor_lib.create_entity(new_attachment)
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
            constructor_lib.create_entity_with_children(child_attachment)
        end
    end
    return attachment
end

constructor_lib.add_attachment_to_construct = function(attachment)
    debug_log("Adding attachment to construct "..tostring(attachment.name))
    constructor_lib.create_entity_with_children(attachment)
    table.insert(attachment.parent.children, attachment)
    attachment.root.menus.refresh(attachment)
end

---
--- Removing
---

constructor_lib.detach_attachment = function(attachment)
    debug_log("Detaching attachment "..tostring(attachment.name))
    ENTITY.DETACH_ENTITY(attachment.handle, true, true)
    constructor_lib.array_remove(attachment.parent.children, function(t, i)
        local child_attachment = t[i]
        return child_attachment ~= attachment
    end)
    attachment.root = attachment
    attachment.parent = attachment
end

constructor_lib.remove_attachment = function(attachment)
    debug_log("Reattaching attachment "..tostring(attachment.name))
    if not attachment then return end
    if attachment.children then
        constructor_lib.array_remove(attachment.children, function(t, i)
            local child_attachment = t[i]
            constructor_lib.remove_attachment(child_attachment)
            return false
        end)
    end
    if not attachment.is_player or attachment.is_preview then
        if attachment == attachment.parent and attachment.blip_handle then util.remove_blip(attachment.blip_handle) end
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
    debug_log("Removing attachment from parent "..tostring(attachment.name))
    if attachment == attachment.parent then
        constructor_lib.remove_attachment(attachment)
    elseif attachment.parent ~= nil then
        constructor_lib.array_remove(attachment.parent.children, function(t, i)
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

---
--- Copying
---

constructor_lib.copy_construct_plan = function(construct_plan)
    local is_root = construct_plan == construct_plan.parent
    construct_plan.root = nil
    construct_plan.parent = nil
    local construct = constructor_lib.table_copy(construct_plan)
    if is_root then
        construct.root = construct
        construct.parent = construct
    end
    return construct
end

constructor_lib.clone_attachment = function(attachment)
    debug_log("Cloning attachment "..tostring(attachment.name))
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
    debug_log("Cloned "..tostring(attachment.name), clone)
    return clone
end

---
--- Tick Loop
---

constructor_lib.update_attachment_tick = function(attachment)
    if attachment.options.is_frozen ~= nil then
        ENTITY.FREEZE_ENTITY_POSITION(attachment.handle, attachment.options.is_frozen)
    end
end

---
--- Loaders
---

constructor_lib.load_hash = function(hash, timeout)
    if timeout == nil then timeout = 3000 end
    STREAMING.REQUEST_MODEL(hash)
    local end_time = util.current_time_millis() + timeout
    repeat util.yield() until STREAMING.HAS_MODEL_LOADED(hash) or util.current_time_millis() >= end_time
    return STREAMING.HAS_MODEL_LOADED(hash)
end

constructor_lib.load_particle_fx_asset = function(asset, timeout)
    if timeout == nil then timeout = 3000 end
    STREAMING.REQUEST_NAMED_PTFX_ASSET(asset)
    local end_time = util.current_time_millis() + timeout
    repeat util.yield() until STREAMING.REQUEST_NAMED_PTFX_ASSET(asset) or util.current_time_millis() >= end_time
    return STREAMING.REQUEST_NAMED_PTFX_ASSET(asset)
end

constructor_lib.load_hash_for_attachment = function(attachment)
    if not STREAMING.IS_MODEL_VALID(attachment.hash) then
        error("Error attaching: Invalid model: " .. tostring(attachment.model) .. " ["..tostring(attachment.hash).."]")
        return false
    end
    if STREAMING.IS_MODEL_A_VEHICLE(attachment.hash) then
        attachment.type = "VEHICLE"
    elseif STREAMING.IS_MODEL_A_PED(attachment.hash) then
        attachment.type = "PED"
    else
        attachment.type = "OBJECT"
    end
    debug_log("Loading hash: " .. tostring(attachment.model) .. " ["..tostring(attachment.hash).."]")
    constructor_lib.load_hash(attachment.hash)
    return true
end

---
--- Request Control
---

constructor_lib.request_control_once = function(entity)
    if not NETWORK.NETWORK_IS_IN_SESSION() then
        return true
    end
    local netId = NETWORK.NETWORK_GET_NETWORK_ID_FROM_ENTITY(entity)
    NETWORK.SET_NETWORK_ID_CAN_MIGRATE(netId, true)
    return NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(entity)
end

constructor_lib.request_control = function(entity, timeout)
    if not ENTITY.DOES_ENTITY_EXIST(entity) then
        return false
    end
    local end_time = util.current_time_millis() + (timeout or 500)
    repeat util.yield_once() until constructor_lib.request_control_once(entity) or util.current_time_millis() >= end_time
    return constructor_lib.request_control_once(entity)
end

---
--- Networking
--- Ported from Kek's Menu. Thanks Kek!
---

constructor_lib.set_attachment_visibility = function(attachment)
    if attachment.options.is_visible ~= nil then
        ENTITY.SET_ENTITY_VISIBLE(attachment.handle, attachment.options.is_visible, 0)
    end
    for _, child_attachment in pairs(attachment.children) do
        constructor_lib.set_attachment_visibility(child_attachment)
    end
end

constructor_lib.set_entity_as_networked = function(attachment, timeout)
    local time <const> = util.current_time_millis() + (timeout or 1500)
    while time > util.current_time_millis() and not NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(attachment.handle) do
        NETWORK.NETWORK_REGISTER_ENTITY_AS_NETWORKED(attachment.handle)
        util.yield(0)
    end
    return NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(attachment.handle)
end

constructor_lib.constantize_network_id = function(attachment)
    constructor_lib.set_entity_as_networked(attachment, 25)
    local net_id <const> = NETWORK.NETWORK_GET_NETWORK_ID_FROM_ENTITY(attachment.handle)
    -- network.set_network_id_can_migrate(net_id, false) -- Caused players unable to drive vehicles
    NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(net_id, true)
    NETWORK.SET_NETWORK_ID_ALWAYS_EXISTS_FOR_PLAYER(net_id, players.user(), true)
    return net_id
end

constructor_lib.make_entity_networked = function(attachment)
    ENTITY.SET_ENTITY_AS_MISSION_ENTITY(attachment.handle, false, true)
    ENTITY.SET_ENTITY_SHOULD_FREEZE_WAITING_ON_COLLISION(attachment.handle, false)
    constructor_lib.constantize_network_id(attachment)
    NETWORK.SET_NETWORK_ID_CAN_MIGRATE(NETWORK.OBJ_TO_NET(attachment.handle), false)
end

---
--- Ped Animation
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

---
--- Collision
---

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

---
--- Preview
---

constructor_lib.set_preview_visibility = function(attachment)
    local preview_alpha = attachment.alpha
    if preview_alpha == nil then preview_alpha = 206 end
    if attachment.options.is_visible == false then preview_alpha = 0 end
    ENTITY.SET_ENTITY_ALPHA(attachment.handle, preview_alpha, false)
    ENTITY.SET_ENTITY_COMPLETELY_DISABLE_COLLISION(attachment.handle, false, true)
    ENTITY.FREEZE_ENTITY_POSITION(attachment.handle, true)
end

---
--- Blip
---

constructor_lib.refresh_blip = function(attachment)
    if attachment ~= attachment.parent or attachment.is_preview then return end
    if attachment.blip_handle then util.remove_blip(attachment.blip_handle) end
    attachment.blip_handle = HUD.ADD_BLIP_FOR_ENTITY(attachment.handle)
    HUD.SET_BLIP_SPRITE(attachment.blip_handle, attachment.blip_sprite)
    HUD.SET_BLIP_COLOUR(attachment.blip_handle, attachment.blip_color)
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
--- Serializers
---

constructor_lib.serialize_hash_and_model = function(attachment)
    if attachment.hash == nil and attachment.model ~= nil then
        attachment.hash = util.joaat(attachment.model)
    elseif attachment.model == nil and attachment.hash ~= nil then
        attachment.model = util.reverse_joaat(attachment.hash)
    elseif attachment.hash == nil and attachment.model == nil and attachment.handle ~= nil and attachment.handle > 0 then
        attachment.hash = ENTITY.GET_ENTITY_MODEL(attachment.handle)
        attachment.model = util.reverse_joaat(attachment.hash)
    end
end

---
--- Vehicle Serializers
---

constructor_lib.default_vehicle_attributes = function(vehicle)
    if vehicle.type ~= "VEHICLE" then return end
    debug_log("Defaulting vehicle attributes "..tostring(vehicle.name))
    if vehicle.vehicle_attributes == nil then vehicle.vehicle_attributes = {} end
    if vehicle.vehicle_attributes.paint == nil then vehicle.vehicle_attributes.paint = {} end
    if vehicle.vehicle_attributes.paint.primary == nil then vehicle.vehicle_attributes.paint.primary = {} end
    if vehicle.vehicle_attributes.paint.secondary == nil then vehicle.vehicle_attributes.paint.secondary = {} end
    if vehicle.vehicle_attributes.paint.primary.custom_color == nil then vehicle.vehicle_attributes.paint.primary.custom_color = {} end
    if vehicle.vehicle_attributes.paint.secondary.custom_color == nil then vehicle.vehicle_attributes.paint.secondary.custom_color = {} end
    if vehicle.vehicle_attributes.paint.dirt_level == nil then vehicle.vehicle_attributes.paint.dirt_level = 0 end
    if vehicle.vehicle_attributes.paint.extra_colors == nil then vehicle.vehicle_attributes.paint.extra_colors = {} end
    if vehicle.vehicle_attributes.neon == nil then vehicle.vehicle_attributes.neon = {} end
    if vehicle.vehicle_attributes.neon.lights == nil then vehicle.vehicle_attributes.neon.lights = {} end
    if vehicle.vehicle_attributes.neon.color == nil then vehicle.vehicle_attributes.neon.color = {} end
    if vehicle.vehicle_attributes.wheels == nil then vehicle.vehicle_attributes.wheels = {} end
    if vehicle.vehicle_attributes.wheels.tires_burst == nil then vehicle.vehicle_attributes.wheels.tires_burst = {} end
    if vehicle.vehicle_attributes.wheels.tire_smoke_color == nil then vehicle.vehicle_attributes.wheels.tire_smoke_color = {} end
    if vehicle.vehicle_attributes.headlights == nil then vehicle.vehicle_attributes.headlights = {} end
    if vehicle.vehicle_attributes.options == nil then vehicle.vehicle_attributes.options = {} end
    if vehicle.vehicle_attributes.extras == nil then vehicle.vehicle_attributes.extras = {} end
    if vehicle.vehicle_attributes.doors == nil then vehicle.vehicle_attributes.doors = {} end
    if vehicle.vehicle_attributes.doors.broken == nil then vehicle.vehicle_attributes.doors.broken = {} end
    if vehicle.vehicle_attributes.doors.open == nil then vehicle.vehicle_attributes.doors.open = {} end
    if vehicle.vehicle_attributes.windows == nil then vehicle.vehicle_attributes.windows = {} end
    if vehicle.vehicle_attributes.windows.rolled_down == nil then vehicle.vehicle_attributes.windows.rolled_down = {} end
    if vehicle.vehicle_attributes.windows.broken == nil then vehicle.vehicle_attributes.windows.broken = {} end
    if vehicle.vehicle_attributes.mods == nil then vehicle.vehicle_attributes.mods = {} end
end

constructor_lib.serialize_vehicle_attributes = function(vehicle)
    if vehicle.type ~= "VEHICLE" then return end
    debug_log("Serializing vehicle attributes "..tostring(vehicle.name))
    constructor_lib.default_vehicle_attributes(vehicle)
    if not ENTITY.DOES_ENTITY_EXIST(vehicle.handle) then return end
    debug_log("Serializing vehicle attributes "..tostring(vehicle.name))
    constructor_lib.serialize_vehicle_paint(vehicle)
    constructor_lib.serialize_vehicle_neon(vehicle)
    constructor_lib.serialize_vehicle_wheels(vehicle)
    constructor_lib.serialize_vehicle_headlights(vehicle)
    constructor_lib.serialize_vehicle_options(vehicle)
    constructor_lib.serialize_vehicle_doors(vehicle)
    constructor_lib.serialize_vehicle_windows(vehicle)
    constructor_lib.serialize_vehicle_mods(vehicle)
    constructor_lib.serialize_vehicle_extras(vehicle)
end

constructor_lib.deserialize_vehicle_attributes = function(vehicle)
    if vehicle.vehicle_attributes == nil then return end
    debug_log("Deserializing vehicle attributes "..tostring(vehicle.name))

    VEHICLE.SET_VEHICLE_MOD_KIT(vehicle.handle, 0)
    ENTITY.SET_ENTITY_AS_MISSION_ENTITY(vehicle.handle, true, true)    -- Needed for plate text

    constructor_lib.deserialize_vehicle_neon(vehicle)
    constructor_lib.deserialize_vehicle_paint(vehicle)
    constructor_lib.deserialize_vehicle_wheels(vehicle)
    constructor_lib.deserialize_vehicle_doors(vehicle)
    constructor_lib.deserialize_vehicle_headlights(vehicle)
    constructor_lib.deserialize_vehicle_options(vehicle)
    constructor_lib.deserialize_vehicle_doors(vehicle)
    constructor_lib.deserialize_vehicle_windows(vehicle)
    constructor_lib.deserialize_vehicle_mods(vehicle)
    constructor_lib.deserialize_vehicle_extras(vehicle)
end

constructor_lib.serialize_vehicle_headlights = function(vehicle)
    if vehicle.vehicle_attributes == nil then vehicle.vehicle_attributes = {} end
    if vehicle.vehicle_attributes.headlights == nil then vehicle.vehicle_attributes.headlights = {} end
    vehicle.vehicle_attributes.headlights.headlights_color = VEHICLE.GET_VEHICLE_XENON_LIGHT_COLOR_INDEX(vehicle.handle)
    vehicle.vehicle_attributes.headlights.headlights_type = VEHICLE.IS_TOGGLE_MOD_ON(vehicle.handle, 22)
end

constructor_lib.deserialize_vehicle_headlights = function(vehicle)
    if vehicle.vehicle_attributes.headlights == nil then return end
    VEHICLE.SET_VEHICLE_XENON_LIGHT_COLOR_INDEX(vehicle.handle, vehicle.vehicle_attributes.headlights.headlights_color)
    VEHICLE.TOGGLE_VEHICLE_MOD(vehicle.handle, 22, vehicle.vehicle_attributes.headlights.headlights_type or false)
    VEHICLE.SET_VEHICLE_LIGHT_MULTIPLIER(vehicle.handle, vehicle.vehicle_attributes.headlights.multiplier or 1)
end

constructor_lib.serialize_vehicle_paint = function(vehicle)
    if vehicle.vehicle_attributes == nil then vehicle.vehicle_attributes = {} end
    if vehicle.vehicle_attributes.paint == nil then vehicle.vehicle_attributes.paint = {} end
    if vehicle.vehicle_attributes.paint.primary == nil then vehicle.vehicle_attributes.paint.primary = {} end
    if vehicle.vehicle_attributes.paint.secondary == nil then vehicle.vehicle_attributes.paint.secondary = {} end

    -- Create pointers to hold color values
    local color = { r = memory.alloc(8), g = memory.alloc(8), b = memory.alloc(8) }

    VEHICLE.GET_VEHICLE_COLOR(vehicle.handle, color.r, color.g, color.b)
    vehicle.vehicle_attributes.paint.vehicle_custom_color = { r = memory.read_int(color.r), g = memory.read_int(color.g), b = memory.read_int(color.b) }
    VEHICLE.GET_VEHICLE_COLOURS(vehicle.handle, color.r, color.g)
    vehicle.vehicle_attributes.paint.primary.vehicle_standard_color = memory.read_int(color.r)
    vehicle.vehicle_attributes.paint.secondary.vehicle_standard_color = memory.read_int(color.g)

    vehicle.vehicle_attributes.paint.primary.is_custom = VEHICLE.GET_IS_VEHICLE_PRIMARY_COLOUR_CUSTOM(vehicle.handle)
    if vehicle.vehicle_attributes.paint.primary.is_custom then
        VEHICLE.GET_VEHICLE_CUSTOM_PRIMARY_COLOUR(vehicle.handle, color.r, color.g, color.b)
        vehicle.vehicle_attributes.paint.primary.custom_color = { r = memory.read_int(color.r), g = memory.read_int(color.g), b = memory.read_int(color.b) }
    else
        VEHICLE.GET_VEHICLE_MOD_COLOR_1(vehicle.handle, color.r, color.g, color.b)
        vehicle.vehicle_attributes.paint.primary.paint_type = memory.read_int(color.r)
        vehicle.vehicle_attributes.paint.primary.color = memory.read_int(color.g)
        vehicle.vehicle_attributes.paint.primary.pearlescent_color = memory.read_int(color.b)
    end

    vehicle.vehicle_attributes.paint.secondary.is_custom = VEHICLE.GET_IS_VEHICLE_SECONDARY_COLOUR_CUSTOM(vehicle.handle)
    if vehicle.vehicle_attributes.paint.secondary.is_custom then
        VEHICLE.GET_VEHICLE_CUSTOM_SECONDARY_COLOUR(vehicle.handle, color.r, color.g, color.b)
        vehicle.vehicle_attributes.paint.secondary.custom_color = { r = memory.read_int(color.r), g = memory.read_int(color.g), b = memory.read_int(color.b) }
    else
        VEHICLE.GET_VEHICLE_MOD_COLOR_2(vehicle.handle, color.r, color.g)
        vehicle.vehicle_attributes.paint.secondary.paint_type = memory.read_int(color.r)
        vehicle.vehicle_attributes.paint.secondary.color = memory.read_int(color.g)
    end

    VEHICLE.GET_VEHICLE_EXTRA_COLOURS(vehicle.handle, color.r, color.g)
    vehicle.vehicle_attributes.paint.extra_colors = { pearlescent = memory.read_int(color.r), wheel = memory.read_int(color.g) }
    VEHICLE.GET_VEHICLE_EXTRA_COLOUR_6(vehicle.handle, color.r)
    vehicle.vehicle_attributes.paint.dashboard_color = memory.read_int(color.r)
    VEHICLE.SET_VEHICLE_EXTRA_COLOUR_5(vehicle.handle, color.r)
    vehicle.vehicle_attributes.paint.interior_color = memory.read_int(color.r)
    vehicle.vehicle_attributes.paint.fade = VEHICLE.GET_VEHICLE_ENVEFF_SCALE(vehicle.handle)
    vehicle.vehicle_attributes.paint.dirt_level = VEHICLE.GET_VEHICLE_DIRT_LEVEL(vehicle.handle)
    vehicle.vehicle_attributes.paint.color_combo = VEHICLE.GET_VEHICLE_COLOUR_COMBINATION(vehicle.handle)

    -- Livery is also part of mods, but capture it here as well for when just saving paint
    vehicle.vehicle_attributes.paint.livery = VEHICLE.GET_VEHICLE_MOD(vehicle.handle, 48)
    vehicle.vehicle_attributes.paint.livery_legacy = VEHICLE.GET_VEHICLE_LIVERY(vehicle.handle)
    vehicle.vehicle_attributes.paint.livery2_legacy = VEHICLE.GET_VEHICLE_LIVERY2(vehicle.handle)

end

constructor_lib.deserialize_vehicle_paint = function(vehicle)
    if vehicle.vehicle_attributes == nil or vehicle.vehicle_attributes.paint == nil then return end

    VEHICLE.SET_VEHICLE_MOD_KIT(vehicle.handle, 0)
    if vehicle.vehicle_attributes.paint.color_combo ~= nil then
        VEHICLE.SET_VEHICLE_COLOUR_COMBINATION(vehicle.handle, vehicle.vehicle_attributes.paint.color_combo or -1)
    end

    if vehicle.vehicle_attributes.paint.vehicle_custom_color ~= nil then
        VEHICLE.SET_VEHICLE_CUSTOM_PRIMARY_COLOUR(
                vehicle.handle,
                vehicle.vehicle_attributes.paint.vehicle_custom_color.r,
                vehicle.vehicle_attributes.paint.vehicle_custom_color.g,
                vehicle.vehicle_attributes.paint.vehicle_custom_color.b
        )
        VEHICLE.SET_VEHICLE_CUSTOM_SECONDARY_COLOUR(
                vehicle.handle,
                vehicle.vehicle_attributes.paint.vehicle_custom_color.r,
                vehicle.vehicle_attributes.paint.vehicle_custom_color.g,
                vehicle.vehicle_attributes.paint.vehicle_custom_color.b
        )
    end

    if vehicle.vehicle_attributes.paint.primary ~= nil then
        if vehicle.vehicle_attributes.paint.primary.vehicle_standard_color ~= nil
                or vehicle.vehicle_attributes.paint.secondary.vehicle_standard_color ~= nil then
            VEHICLE.SET_VEHICLE_COLOURS(
                    vehicle.handle,
                    vehicle.vehicle_attributes.paint.primary.vehicle_standard_color,
                    vehicle.vehicle_attributes.paint.secondary.vehicle_standard_color
            )
        end
        if vehicle.vehicle_attributes.paint.primary.is_custom then
            VEHICLE.SET_VEHICLE_CUSTOM_PRIMARY_COLOUR(
                    vehicle.handle,
                    vehicle.vehicle_attributes.paint.primary.custom_color.r,
                    vehicle.vehicle_attributes.paint.primary.custom_color.g,
                    vehicle.vehicle_attributes.paint.primary.custom_color.b
            )
        end
        if vehicle.vehicle_attributes.paint.primary.paint_type ~= nil then
            VEHICLE.SET_VEHICLE_MOD_COLOR_1(
                    vehicle.handle,
                    vehicle.vehicle_attributes.paint.primary.paint_type,
                    vehicle.vehicle_attributes.paint.primary.color,
                    vehicle.vehicle_attributes.paint.primary.pearlescent_color
            )
        end
        if vehicle.vehicle_attributes.paint.secondary.is_custom then
            VEHICLE.SET_VEHICLE_CUSTOM_SECONDARY_COLOUR(
                    vehicle.handle,
                    vehicle.vehicle_attributes.paint.secondary.custom_color.r,
                    vehicle.vehicle_attributes.paint.secondary.custom_color.g,
                    vehicle.vehicle_attributes.paint.secondary.custom_color.b
            )
        end
        if vehicle.vehicle_attributes.paint.secondary.paint_type ~= nil then
            VEHICLE.SET_VEHICLE_MOD_COLOR_2(
                    vehicle.handle,
                    vehicle.vehicle_attributes.paint.secondary.paint_type,
                    vehicle.vehicle_attributes.paint.secondary.color
            )
        end
    end

    if vehicle.vehicle_attributes.paint.extra_colors.pearlescent ~= nil or vehicle.vehicle_attributes.paint.extra_colors.wheel ~= nil then
        VEHICLE.SET_VEHICLE_EXTRA_COLOURS(
                vehicle.handle,
                vehicle.vehicle_attributes.paint.extra_colors.pearlescent,
                vehicle.vehicle_attributes.paint.extra_colors.wheel
        )
    end

    if vehicle.vehicle_attributes.headlights_color ~= nil then
        VEHICLE.SET_VEHICLE_XENON_LIGHT_COLOR_INDEX(vehicle.handle, vehicle.vehicle_attributes.headlights_color)
    end
    if vehicle.vehicle_attributes.paint.dashboard_color ~= nil then
        VEHICLE.SET_VEHICLE_EXTRA_COLOUR_6(vehicle.handle, vehicle.vehicle_attributes.paint.dashboard_color)
    end
    if vehicle.vehicle_attributes.paint.interior_color ~= nil then
        VEHICLE.SET_VEHICLE_EXTRA_COLOUR_5(vehicle.handle, vehicle.vehicle_attributes.paint.interior_color)
    end
    if vehicle.vehicle_attributes.paint.fade ~= nil then
        VEHICLE.SET_VEHICLE_ENVEFF_SCALE(vehicle.handle, vehicle.vehicle_attributes.paint.fade)
    end
    if vehicle.vehicle_attributes.paint.dirt_level ~= nil then
        VEHICLE.SET_VEHICLE_DIRT_LEVEL(vehicle.handle, vehicle.vehicle_attributes.paint.dirt_level)
    end
    if vehicle.vehicle_attributes.paint.livery ~= nil then
        VEHICLE.SET_VEHICLE_MOD(vehicle.handle, 48, vehicle.vehicle_attributes.paint.livery)
    end
    if vehicle.vehicle_attributes.paint.livery_legacy ~= nil then
        VEHICLE.SET_VEHICLE_LIVERY(vehicle.handle, vehicle.vehicle_attributes.paint.livery_legacy)
    end
    if vehicle.vehicle_attributes.paint.livery2_legacy ~= nil then
        VEHICLE.SET_VEHICLE_LIVERY2(vehicle.handle, vehicle.vehicle_attributes.paint.livery2_legacy)
    end
end

constructor_lib.serialize_vehicle_neon = function(vehicle)
    if vehicle.vehicle_attributes == nil then vehicle.vehicle_attributes = {} end
    if vehicle.vehicle_attributes.neon == nil then vehicle.vehicle_attributes.neon = {} end
    vehicle.vehicle_attributes.neon.lights = {
        left = VEHICLE.GET_VEHICLE_NEON_ENABLED(vehicle.handle, 0),
        right = VEHICLE.GET_VEHICLE_NEON_ENABLED(vehicle.handle, 1),
        front = VEHICLE.GET_VEHICLE_NEON_ENABLED(vehicle.handle, 2),
        back = VEHICLE.GET_VEHICLE_NEON_ENABLED(vehicle.handle, 3),
    }
    local color = { r = memory.alloc(8), g = memory.alloc(8), b = memory.alloc(8) }
    if (vehicle.vehicle_attributes.neon.lights.left or vehicle.vehicle_attributes.neon.lights.right
            or vehicle.vehicle_attributes.neon.lights.front or vehicle.vehicle_attributes.neon.lights.back) then
        VEHICLE.GET_VEHICLE_NEON_COLOUR(vehicle.handle, color.r, color.g, color.b)
        vehicle.vehicle_attributes.neon.color = { r = memory.read_int(color.r), g = memory.read_int(color.g), b = memory.read_int(color.b) }
    end
end

constructor_lib.deserialize_vehicle_neon = function(vehicle)
    if vehicle.vehicle_attributes == nil or vehicle.vehicle_attributes.neon == nil then return end
    if vehicle.vehicle_attributes.neon.lights then
        VEHICLE.SET_VEHICLE_NEON_ENABLED(vehicle.handle, 0, vehicle.vehicle_attributes.neon.lights.left or false)
        VEHICLE.SET_VEHICLE_NEON_ENABLED(vehicle.handle, 1, vehicle.vehicle_attributes.neon.lights.right or false)
        VEHICLE.SET_VEHICLE_NEON_ENABLED(vehicle.handle, 2, vehicle.vehicle_attributes.neon.lights.front or false)
        VEHICLE.SET_VEHICLE_NEON_ENABLED(vehicle.handle, 3, vehicle.vehicle_attributes.neon.lights.back or false)
    end
    if vehicle.vehicle_attributes.neon.color then
        VEHICLE.SET_VEHICLE_NEON_COLOUR(
                vehicle.handle,
                vehicle.vehicle_attributes.neon.color.r,
                vehicle.vehicle_attributes.neon.color.g,
                vehicle.vehicle_attributes.neon.color.b
        )
    end
end

local function vehicle_wheels_invis(attachment)
    local DBL_MAX = 1.79769e+308
    constructor_lib.request_control(attachment.handle, 800)
    VEHICLE.SET_VEHICLE_FORWARD_SPEED(attachment.handle, DBL_MAX*DBL_MAX)
    SYSTEM.WAIT(100)
    VEHICLE.SET_VEHICLE_CHEAT_POWER_INCREASE(attachment.handle, DBL_MAX*DBL_MAX)
    VEHICLE.MODIFY_VEHICLE_TOP_SPEED(attachment.handle, DBL_MAX*DBL_MAX)
    ENTITY.APPLY_FORCE_TO_ENTITY(attachment.handle, 1, 0.0, 0.0, -DBL_MAX*DBL_MAX, 0.0, 0.0, 0.0, 0, false, true, true, true, false, true)
    SYSTEM.WAIT(100)
    VEHICLE.SET_VEHICLE_CHEAT_POWER_INCREASE(attachment.handle, 1)
    VEHICLE.MODIFY_VEHICLE_TOP_SPEED(attachment.handle, 1)
end

local function vehicle_wheels_uninvis(attachment)
    constructor_lib.request_control(attachment.handle, 800)
    for wheel_index = 0, 7 do
        VEHICLE.SET_VEHICLE_TYRE_FIXED(attachment.handle, wheel_index)
    end
    VEHICLE.SET_VEHICLE_FIXED(attachment.handle)
    VEHICLE.SET_VEHICLE_DEFORMATION_FIXED(attachment.handle)
    VEHICLE.RESET_VEHICLE_WHEELS(attachment.handle)
    VEHICLE.SET_VEHICLE_DIRT_LEVEL(attachment.handle, 0)
    VEHICLE.SET_VEHICLE_ENGINE_CAN_DEGRADE(attachment.handle, 0)
    VEHICLE.SET_VEHICLE_ENGINE_HEALTH(attachment.handle, 2000)
    VEHICLE.SET_VEHICLE_PETROL_TANK_HEALTH(attachment.handle, 2000)
    VEHICLE.SET_VEHICLE_BODY_HEALTH(attachment.handle, 2000)
    VEHICLE.SET_VEHICLE_UNDRIVEABLE(attachment.handle, false)
    VEHICLE.SET_VEHICLE_ENGINE_ON(attachment.handle, 1, 1)

    VEHICLE.SET_VEHICLE_CHEAT_POWER_INCREASE(attachment.handle, 0)
    VEHICLE.MODIFY_VEHICLE_TOP_SPEED(attachment.handle, 0)
    SYSTEM.WAIT(100)
    VEHICLE.SET_VEHICLE_CHEAT_POWER_INCREASE(attachment.handle, 1)
    VEHICLE.MODIFY_VEHICLE_TOP_SPEED(attachment.handle, 1)
end


constructor_lib.serialize_vehicle_wheels = function(vehicle)
    if vehicle.vehicle_attributes == nil then vehicle.vehicle_attributes = {} end
    if vehicle.vehicle_attributes.wheels == nil then vehicle.vehicle_attributes.wheels = {} end
    if vehicle.vehicle_attributes.wheels.tires_burst == nil then vehicle.vehicle_attributes.wheels.tires_burst = {} end
    vehicle.vehicle_attributes.wheels.wheel_type = VEHICLE.GET_VEHICLE_WHEEL_TYPE(vehicle.handle)
    local color = { r = memory.alloc(8), g = memory.alloc(8), b = memory.alloc(8) }
    VEHICLE.GET_VEHICLE_TYRE_SMOKE_COLOR(vehicle.handle, color.r, color.g, color.b)
    vehicle.vehicle_attributes.wheels.tire_smoke_color = { r = memory.read_int(color.r), g = memory.read_int(color.g), b = memory.read_int(color.b) }
end

constructor_lib.deserialize_vehicle_wheels = function(vehicle)
    if vehicle.vehicle_attributes == nil or vehicle.vehicle_attributes.wheels == nil then return end
    if vehicle.vehicle_attributes.wheels.bulletproof_tires ~= nil then
        VEHICLE.SET_VEHICLE_TYRES_CAN_BURST(vehicle.handle, not vehicle.vehicle_attributes.wheels.bulletproof_tires)
    end
    VEHICLE.SET_VEHICLE_WHEEL_TYPE(vehicle.handle, vehicle.vehicle_attributes.wheels.wheel_type or -1)
    if vehicle.vehicle_attributes.wheels.tire_smoke_color then
        VEHICLE.SET_VEHICLE_TYRE_SMOKE_COLOR(vehicle.handle, vehicle.vehicle_attributes.wheels.tire_smoke_color.r or 255,
                vehicle.vehicle_attributes.wheels.tire_smoke_color.g or 255, vehicle.vehicle_attributes.wheels.tire_smoke_color.b or 255)
    end
    if vehicle.vehicle_attributes.wheels.tires_burst then
        for _, tire_position in pairs(constants.tire_position_names) do
            if vehicle.vehicle_attributes.wheels.tires_burst["_"..tire_position.index] then
                VEHICLE.SET_VEHICLE_TYRE_BURST(vehicle.handle, tire_position.index, true, 1.0)
            else
                VEHICLE.SET_VEHICLE_TYRE_FIXED(vehicle.handle, tire_position.index)
            end
        end
    end
    if vehicle.vehicle_attributes.wheels.invisible_wheels ~= nil then
        if vehicle.vehicle_attributes.wheels.invisible_wheels then
            vehicle_wheels_invis(vehicle)
        else
            vehicle_wheels_uninvis(vehicle)
        end
    end
end

constructor_lib.serialize_vehicle_doors = function(vehicle)
    if vehicle.vehicle_attributes == nil then vehicle.vehicle_attributes = {} end
    if vehicle.vehicle_attributes.doors == nil then
        vehicle.vehicle_attributes.doors = { broken = {}, open = {}, }
    end
    vehicle.vehicle_attributes.doors.open.frontleft = VEHICLE.IS_VEHICLE_DOOR_FULLY_OPEN(vehicle.handle, 0)
    vehicle.vehicle_attributes.doors.open.frontright = VEHICLE.IS_VEHICLE_DOOR_FULLY_OPEN(vehicle.handle, 1)
    vehicle.vehicle_attributes.doors.open.backleft = VEHICLE.IS_VEHICLE_DOOR_FULLY_OPEN(vehicle.handle, 2)
    vehicle.vehicle_attributes.doors.open.backright = VEHICLE.IS_VEHICLE_DOOR_FULLY_OPEN(vehicle.handle, 3)
    vehicle.vehicle_attributes.doors.open.hood = VEHICLE.IS_VEHICLE_DOOR_FULLY_OPEN(vehicle.handle, 4)
    vehicle.vehicle_attributes.doors.open.trunk = VEHICLE.IS_VEHICLE_DOOR_FULLY_OPEN(vehicle.handle, 5)
    vehicle.vehicle_attributes.doors.open.trunk2 = VEHICLE.IS_VEHICLE_DOOR_FULLY_OPEN(vehicle.handle, 6)
end

constructor_lib.deserialize_vehicle_doors = function(vehicle)
    if vehicle.vehicle_attributes == nil or vehicle.vehicle_attributes.doors == nil then return end
    if vehicle.vehicle_attributes.doors.broken.frontleft then VEHICLE.SET_VEHICLE_DOOR_BROKEN(vehicle.handle, 0, true) end
    if vehicle.vehicle_attributes.doors.broken.frontright then VEHICLE.SET_VEHICLE_DOOR_BROKEN(vehicle.handle, 1, true) end
    if vehicle.vehicle_attributes.doors.broken.backleft then VEHICLE.SET_VEHICLE_DOOR_BROKEN(vehicle.handle, 2, true) end
    if vehicle.vehicle_attributes.doors.broken.backright then VEHICLE.SET_VEHICLE_DOOR_BROKEN(vehicle.handle, 3, true) end
    if vehicle.vehicle_attributes.doors.broken.hood then VEHICLE.SET_VEHICLE_DOOR_BROKEN(vehicle.handle, 4, true) end
    if vehicle.vehicle_attributes.doors.broken.trunk then VEHICLE.SET_VEHICLE_DOOR_BROKEN(vehicle.handle, 5, true) end
    if vehicle.vehicle_attributes.doors.broken.trunk2 then VEHICLE.SET_VEHICLE_DOOR_BROKEN(vehicle.handle, 6, true) end

    if vehicle.vehicle_attributes.doors.open.frontleft then VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle.handle, 0, true, true) end
    if vehicle.vehicle_attributes.doors.open.frontright then VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle.handle, 1, true, true) end
    if vehicle.vehicle_attributes.doors.open.backleft then VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle.handle, 2, true, true) end
    if vehicle.vehicle_attributes.doors.open.backright then VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle.handle, 3, true, true) end
    if vehicle.vehicle_attributes.doors.open.hood then VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle.handle, 4, true, true) end
    if vehicle.vehicle_attributes.doors.open.trunk then VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle.handle, 5, true, true) end
    if vehicle.vehicle_attributes.doors.open.trunk2 then VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle.handle, 6, true, true) end

    if vehicle.vehicle_attributes.doors.lock_status ~= nil then
        VEHICLE.SET_VEHICLE_DOORS_LOCKED(vehicle.handle, vehicle.vehicle_attributes.doors.lock_status)
    end
end

constructor_lib.WINDOW_INDEX_NAMES = {
    "frontleft",
    "frontright",
    "rearleft",
    "rearright",
    "front",
    "rear",
    "midleft",
    "midright",
}

constructor_lib.serialize_vehicle_windows = function(vehicle)
    if vehicle.vehicle_attributes == nil then vehicle.vehicle_attributes = {} end
    if vehicle.vehicle_attributes.windows == nil then vehicle.vehicle_attributes.windows = {} end
    if vehicle.vehicle_attributes.windows.broken == nil then vehicle.vehicle_attributes.windows.broken = {} end
    for window_index = 1, 8 do
        local window_name = constructor_lib.WINDOW_INDEX_NAMES[window_index]
        if not VEHICLE.IS_VEHICLE_WINDOW_INTACT(vehicle.handle, window_index-1) then
            vehicle.vehicle_attributes.windows.broken[window_name] = false
        end
    end
end

constructor_lib.deserialize_vehicle_windows = function(vehicle)
    if vehicle.vehicle_attributes == nil then return end
    if vehicle.vehicle_attributes.windows == nil then return end
    for window_index = 1, 8 do
        local window_name = constructor_lib.WINDOW_INDEX_NAMES[window_index]
        local window_rolled_down = vehicle.vehicle_attributes.windows.rolled_down[window_name]
        if window_rolled_down ~= nil then
            if window_rolled_down then
                VEHICLE.ROLL_DOWN_WINDOW(vehicle.handle, window_index-1)
            else
                VEHICLE.ROLL_UP_WINDOW(vehicle.handle, window_index-1)
            end
        end

        local window_broken = vehicle.vehicle_attributes.windows.broken[window_name]
        if window_broken ~= nil then
            if window_broken then
                VEHICLE.SMASH_VEHICLE_WINDOW(vehicle.handle, window_index-1)
            else
                VEHICLE.FIX_VEHICLE_WINDOW(vehicle.handle, window_index-1)
            end
        end
    end
end

constructor_lib.serialize_vehicle_mods = function(vehicle)
    if vehicle.vehicle_attributes == nil then vehicle.vehicle_attributes = {} end
    if vehicle.vehicle_attributes.mods == nil then vehicle.vehicle_attributes.mods = {} end
    for mod_index = 0, 49 do
        local mod_value
        if mod_index >= 17 and mod_index <= 22 then
            mod_value = VEHICLE.IS_TOGGLE_MOD_ON(vehicle.handle, mod_index)
        else
            mod_value = VEHICLE.GET_VEHICLE_MOD(vehicle.handle, mod_index)
        end
        vehicle.vehicle_attributes.mods["_"..mod_index] = mod_value
    end
end

constructor_lib.deserialize_vehicle_mods = function(vehicle)
    if vehicle.vehicle_attributes == nil or vehicle.vehicle_attributes.mods == nil then return end
    for mod_index = 0, 49 do
        if mod_index >= 17 and mod_index <= 22 then
            VEHICLE.TOGGLE_VEHICLE_MOD(vehicle.handle, mod_index, vehicle.vehicle_attributes.mods["_"..mod_index])
        else
            VEHICLE.SET_VEHICLE_MOD(vehicle.handle, mod_index, vehicle.vehicle_attributes.mods["_"..mod_index] or -1)
        end
    end
end

constructor_lib.serialize_vehicle_extras = function(vehicle)
    if vehicle.vehicle_attributes == nil then vehicle.vehicle_attributes = {} end
    if vehicle.vehicle_attributes.extras == nil then vehicle.vehicle_attributes.extras = {} end
    for extra_index = 0, 14 do
        if VEHICLE.DOES_EXTRA_EXIST(vehicle.handle, extra_index) then
            vehicle.vehicle_attributes.extras["_"..extra_index] = VEHICLE.IS_VEHICLE_EXTRA_TURNED_ON(vehicle.handle, extra_index)
        end
    end
end

constructor_lib.deserialize_vehicle_extras = function(vehicle)
    if vehicle.vehicle_attributes == nil or vehicle.vehicle_attributes.extras == nil then return end
    for extra_index = 0, 14 do
        local state = true
        if vehicle.vehicle_attributes.extras["_"..extra_index] ~= nil then
            state = vehicle.vehicle_attributes.extras["_"..extra_index]
        end
        VEHICLE.SET_VEHICLE_EXTRA(vehicle.handle, extra_index, not state)
    end
end

constructor_lib.serialize_vehicle_options = function(vehicle)
    if vehicle.vehicle_attributes == nil then vehicle.vehicle_attributes = {} end
    if vehicle.vehicle_attributes.options == nil then vehicle.vehicle_attributes.options = {} end
    vehicle.vehicle_attributes.options.bulletproof_tires = VEHICLE.GET_VEHICLE_TYRES_CAN_BURST(vehicle.handle)
    vehicle.vehicle_attributes.options.window_tint = VEHICLE.GET_VEHICLE_WINDOW_TINT(vehicle.handle)
    vehicle.vehicle_attributes.options.radio_loud = AUDIO.CAN_VEHICLE_RECEIVE_CB_RADIO(vehicle.handle)
    vehicle.vehicle_attributes.options.engine_running = VEHICLE.GET_IS_VEHICLE_ENGINE_RUNNING(vehicle.handle)
    vehicle.vehicle_attributes.options.siren = VEHICLE.IS_VEHICLE_SIREN_AUDIO_ON(vehicle.handle)
    vehicle.vehicle_attributes.options.emergency_lights = VEHICLE.IS_VEHICLE_SIREN_ON(vehicle.handle)
    vehicle.vehicle_attributes.options.search_light = VEHICLE.IS_VEHICLE_SEARCHLIGHT_ON(vehicle.handle)
    vehicle.vehicle_attributes.options.license_plate_text = VEHICLE.GET_VEHICLE_NUMBER_PLATE_TEXT(vehicle.handle)
    vehicle.vehicle_attributes.options.license_plate_type = VEHICLE.GET_VEHICLE_NUMBER_PLATE_TEXT_INDEX(vehicle.handle)
end

constructor_lib.deserialize_vehicle_options = function(vehicle)
    if vehicle.vehicle_attributes == nil or vehicle.vehicle_attributes.options == nil then return end
    if vehicle.vehicle_attributes.options.siren then
        AUDIO.SET_SIREN_WITH_NO_DRIVER(vehicle.handle, true)
        VEHICLE.SET_VEHICLE_HAS_MUTED_SIRENS(vehicle.handle, false)
        AUDIO.SET_SIREN_BYPASS_MP_DRIVER_CHECK(vehicle.handle, true)
        AUDIO.TRIGGER_SIREN_AUDIO(vehicle.handle, true)
    end
    if vehicle.vehicle_attributes.engine_sound ~= nil then
        local hash = util.joaat(vehicle.vehicle_attributes.engine_sound)
        if STREAMING.IS_MODEL_VALID(hash) and VEHICLE.IS_THIS_MODEL_A_CAR(hash) then
            AUDIO.FORCE_USE_AUDIO_GAME_OBJECT(vehicle.handle, vehicle.vehicle_attributes.engine_sound)
        end
    end
    if vehicle.vehicle_attributes.options.lights_state ~= nil then
        VEHICLE.SET_VEHICLE_LIGHTS(vehicle.handle, vehicle.vehicle_attributes.options.lights_state)
    end
    if vehicle.vehicle_attributes.options.interior_light ~= nil then
        VEHICLE.SET_VEHICLE_INTERIORLIGHT(vehicle.handle, vehicle.vehicle_attributes.options.interior_light)
    end
    if vehicle.vehicle_attributes.options.is_windscreen_detached == true then
        VEHICLE.POP_OUT_VEHICLE_WINDSCREEN(vehicle.handle)
    end
    if vehicle.vehicle_attributes.options.emergency_lights ~= nil then
        VEHICLE.SET_VEHICLE_SIREN(vehicle.handle, vehicle.vehicle_attributes.options.emergency_lights)
    end
    if vehicle.vehicle_attributes.options.search_light ~= nil then
        VEHICLE.SET_VEHICLE_SEARCHLIGHT(vehicle.handle, vehicle.vehicle_attributes.options.search_light, true)
    end
    if vehicle.vehicle_attributes.options.radio_loud ~= nil then
        AUDIO.SET_VEHICLE_RADIO_LOUD(vehicle.handle, vehicle.vehicle_attributes.options.radio_loud)
    end
    if vehicle.vehicle_attributes.options.license_plate_text ~= nil then
        VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT(vehicle.handle, vehicle.vehicle_attributes.options.license_plate_text)
    end
    if vehicle.vehicle_attributes.options.license_plate_type ~= nil then
        VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT_INDEX(vehicle.handle, vehicle.vehicle_attributes.options.license_plate_type)
    end
    if vehicle.vehicle_attributes.options.engine_running == true then
        VEHICLE.SET_VEHICLE_ENGINE_ON(vehicle.handle, true, true, false)
        VEHICLE.SET_VEHICLE_KEEP_ENGINE_ON_WHEN_ABANDONED(vehicle.handle, true)
    end
    if vehicle.vehicle_attributes.options.doors_locked ~= nil then
        VEHICLE.SET_VEHICLE_DOORS_LOCKED(vehicle.handle, vehicle.vehicle_attributes.options.doors_locked or false)
    end
    if vehicle.vehicle_attributes.options.engine_health ~= nil then
        VEHICLE.SET_VEHICLE_ENGINE_HEALTH(vehicle.handle, vehicle.vehicle_attributes.options.engine_health)
    end
end

constructor_lib.default_particle_attributes = function(attachment)
    if attachment.particle_attributes == nil then attachment.particle_attributes = {} end
    if attachment.particle_attributes.bone_index == nil then attachment.particle_attributes.bone_index = 0 end
    if attachment.particle_attributes.scale == nil then attachment.particle_attributes.scale = 1 end
    if attachment.particle_attributes.offset == nil or attachment.particle_attributes.offset == {} then attachment.offset = { x = 0, y = 0, z = 0 } end
    if attachment.particle_attributes.rotation == nil or attachment.particle_attributes.rotation == {} then attachment.rotation = { x = 0, y = 0, z = 0 } end
end

---
--- Ped Attributes
---

constructor_lib.default_ped_attributes = function(attachment)
    if attachment.type ~= "PED" then return end
    debug_log("Defaulting ped attributes "..tostring(attachment.name))
    if attachment.ped_attributes == nil then attachment.ped_attributes = {} end
    if attachment.ped_attributes.armor == nil then attachment.ped_attributes.armor = 0 end
    if attachment.ped_attributes.props == nil then attachment.ped_attributes.props = {} end
    if attachment.ped_attributes.components == nil then attachment.ped_attributes.components = {} end
    if attachment.ped_attributes.weapon == nil then attachment.ped_attributes.weapon = {} end
    for prop_index = 0, 9 do
        if attachment.ped_attributes.props["_"..prop_index] == nil then attachment.ped_attributes.props["_"..prop_index] = {} end
        if attachment.ped_attributes.props["_"..prop_index].drawable_variation == nil then attachment.ped_attributes.props["_"..prop_index].drawable_variation = -1 end
        if attachment.ped_attributes.props["_"..prop_index].texture_variation == nil then attachment.ped_attributes.props["_"..prop_index].texture_variation = 0 end
        attachment.ped_attributes.props["_"..prop_index].num_drawable_variations = PED.GET_NUMBER_OF_PED_PROP_DRAWABLE_VARIATIONS(attachment.handle, prop_index) - 1
        attachment.ped_attributes.props["_"..prop_index].num_texture_variations = PED.GET_NUMBER_OF_PED_PROP_TEXTURE_VARIATIONS(attachment.handle, prop_index, attachment.ped_attributes.props["_"..prop_index].drawable_variation) - 1
    end
    for component_index = 0, 11 do
        if attachment.ped_attributes.components["_"..component_index] == nil then attachment.ped_attributes.components["_"..component_index] = {} end
        if attachment.ped_attributes.components["_"..component_index].drawable_variation == nil then attachment.ped_attributes.components["_"..component_index].drawable_variation = 0 end
        if attachment.ped_attributes.components["_"..component_index].texture_variation == nil then attachment.ped_attributes.components["_"..component_index].texture_variation = 0 end
        if attachment.ped_attributes.components["_"..component_index].palette_variation == nil then attachment.ped_attributes.components["_"..component_index].palette_variation = 1 end
        attachment.ped_attributes.components["_"..component_index].num_drawable_variations = PED.GET_NUMBER_OF_PED_DRAWABLE_VARIATIONS(attachment.handle, component_index) - 1
        attachment.ped_attributes.components["_"..component_index].num_texture_variations = PED.GET_NUMBER_OF_PED_TEXTURE_VARIATIONS(attachment.handle, component_index, attachment.ped_attributes.components["_".. component_index].drawable_variation) - 1
    end
end

constructor_lib.serialize_ped_attributes = function(attachment)
    if attachment.type ~= "PED" then return end
    debug_log("Serializing ped attributes "..tostring(attachment.name))
    constructor_lib.default_ped_attributes(attachment)
    constructor_lib.serialize_hash_and_model(attachment)
    for index = 0, 9 do
        attachment.ped_attributes.props["_"..index] = {
            drawable_variation = PED.GET_PED_PROP_INDEX(attachment.handle, index),
            texture_variation = PED.GET_PED_PROP_TEXTURE_INDEX(attachment.handle, index)
        }
    end
    for index = 0, 11 do
        attachment.ped_attributes.components["_"..index] = {
            drawable_variation = PED.GET_PED_DRAWABLE_VARIATION(attachment.handle, index),
            texture_variation = PED.GET_PED_TEXTURE_VARIATION(attachment.handle, index),
            palette_variation = PED.GET_PED_PALETTE_VARIATION(attachment.handle, index),
        }
    end
end

constructor_lib.deserialize_ped_weapon = function(attachment)
    if attachment.ped_attributes.weapon == nil then return end
    if attachment.ped_attributes.weapon.hash == nil and attachment.ped_attributes.weapon.model ~= nil then
        attachment.ped_attributes.weapon.hash = util.joaat(attachment.ped_attributes.weapon.model)
    end
    if attachment.ped_attributes.weapon.component_hash == nil and attachment.ped_attributes.weapon.component_model ~= nil then
        attachment.ped_attributes.weapon.component_hash = util.joaat(attachment.ped_attributes.weapon.component_model)
    end
    if attachment.ped_attributes.weapon.hash ~= nil then
        WEAPON.GIVE_WEAPON_TO_PED(attachment.handle, attachment.ped_attributes.weapon.hash, 1, false, true)
        WEAPON.SET_CURRENT_PED_WEAPON(attachment.handle, attachment.ped_attributes.weapon.hash, true)
        if attachment.ped_attributes.weapon.component_hash ~= nil then
            WEAPON.GIVE_WEAPON_COMPONENT_TO_PED(
                attachment.handle,
                attachment.ped_attributes.weapon.hash,
                attachment.ped_attributes.weapon.component_hash
            )
        end
    end
end

constructor_lib.deserialize_ped_attributes = function(attachment)
    debug_log("Deserializing ped attributes "..tostring(attachment.name))
    if attachment.ped_attributes == nil then return end
    if attachment.ped_attributes.can_rag_doll ~= nil then
        PED.SET_PED_CAN_RAGDOLL(attachment.handle, attachment.ped_attributes.can_rag_doll)
    end
    constructor_lib.deserialize_ped_weapon(attachment)
    if attachment.ped_attributes.armour then
        PED.SET_PED_ARMOUR(attachment.handle, attachment.ped_attributes.armour)
    end
    if attachment.options.is_on_fire == true then
        FIRE.START_ENTITY_FIRE(attachment.handle)
        ENTITY.SET_ENTITY_PROOFS(
                attachment.handle,
                attachment.options.is_bullet_proof, true,
                attachment.options.is_explosion_proof, attachment.options.is_melee_proof,
                false, 0, false
        )
    elseif attachment.options.is_on_fire == false then
        FIRE.STOP_ENTITY_FIRE(attachment.handle)
        ENTITY.SET_ENTITY_PROOFS(
                attachment.handle,
                attachment.options.is_bullet_proof, attachment.options.is_fire_proof,
                attachment.options.is_explosion_proof, attachment.options.is_melee_proof,
                false, 0, false
        )
    end
    if attachment.ped_attributes.props ~= nil then
        for index = 0, 9 do
            local prop = attachment.ped_attributes.props["_".. index]
            if prop ~= nil then
                if prop.drawable_variation >= 0 then
                    PED.SET_PED_PROP_INDEX(
                            attachment.handle,
                            index,
                            tonumber(prop.drawable_variation),
                            tonumber(prop.texture_variation),
                            true
                    )
                else
                    PED.CLEAR_PED_PROP(attachment.handle, index)
                end
                prop.num_drawable_variations = PED.GET_NUMBER_OF_PED_PROP_DRAWABLE_VARIATIONS(attachment.handle, index) - 1
                prop.num_texture_variations = PED.GET_NUMBER_OF_PED_PROP_TEXTURE_VARIATIONS(attachment.handle, index, prop.drawable_variation) - 1
            end
        end
    end
    if attachment.ped_attributes.components ~= nil then
        for index = 0, 11 do
            local component = attachment.ped_attributes.components["_".. index]
            if component ~= nil then
                PED.SET_PED_COMPONENT_VARIATION(
                        attachment.handle,
                        index,
                        tonumber(component.drawable_variation),
                        tonumber(component.texture_variation),
                        tonumber(component.palette_variation)
                )
                component.num_drawable_variations = PED.GET_NUMBER_OF_PED_DRAWABLE_VARIATIONS(attachment.handle, index) - 1
                component.num_texture_variations = PED.GET_NUMBER_OF_PED_TEXTURE_VARIATIONS(attachment.handle, index, attachment.ped_attributes.components["_".. index].drawable_variation) - 1
            end
        end
    end
    constructor_lib.animate_peds(attachment)
end

---
--- Construct Serializer
---

constructor_lib.copy_serializable = function(attachment)
    debug_log("Copying serializable "..tostring(attachment.name))
    local serializeable_attachment = {
        children = {}
    }
    for k, v in pairs(attachment) do
        if not (
            k == "handle" or k == "root" or k == "parent" or k == "menus" or k == "children" or k == "temp" or k == "load_menu" or k == "menu_auto_focus"
            or k == "is_preview" or k == "is_editing" or k == "dimensions" or k == "camera_distance" or k == "heading"
        ) then
            serializeable_attachment[k] = constructor_lib.table_copy(v)
        end
    end
    return serializeable_attachment
end

constructor_lib.serialize_attachment = function(attachment)
    debug_log("Serializing attachment "..tostring(attachment.name))
    if attachment.target_version == nil then attachment.target_version = constructor_lib.LIB_VERSION end
    constructor_lib.serialize_vehicle_attributes(attachment)
    constructor_lib.serialize_ped_attributes(attachment)
    local serialized_attachment = constructor_lib.copy_serializable(attachment)
    if attachment.children then
        for _, child_attachment in pairs(attachment.children) do
            if not child_attachment.options.is_temporary then
                table.insert(serialized_attachment.children, constructor_lib.serialize_attachment(child_attachment))
            end
        end
    end
    --debug_log("Serialized attachment "..inspect(serialized_attachment))
    return serialized_attachment
end

---
--- Return
---

return constructor_lib
