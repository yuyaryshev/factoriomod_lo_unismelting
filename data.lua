-- data.lua
data:extend({
  {
    type = "selection-tool",
    name = "unismelting-planner",
    icons = {
        {icon = "__lo_unismelting__/unismelting-planner.png", icon_size = 64, icon_mipmaps = 4},
    },
    icon = "__lo_unismelting__/unismelting-planner.png",
    icon_size = 64,
    icon_mipmaps = 1,
    flags = {"not-stackable", "spawnable", "only-in-cursor"},
    hidden = true,
    subgroup = "other",
    order = "unismelting-planner",
    stack_size = 1,

    selection_color = {r = 0, g = 1, b = 0, a = 0.25},
    alt_selection_color = {r = 1, g = 1, b = 0, a = 0.25},

    selection_mode = {"buildable-type"},
    alt_selection_mode = {"buildable-type"},
    selection_cursor_box_type = "entity",
    alt_selection_cursor_box_type = "entity",

    -- These determine which event triggers in control.lua
    selection_tool_instant_deploy = false,

    -- Filters can be filled dynamically, or left open for mod logic
	
	-------------------------------------------------------

    select = {
        border_color = {71, 255, 73}, -- copied from upgrade-planner
        cursor_box_type = "not-allowed", -- copied from upgrade-planner
        mode = {"entity-ghost", "not-same-force", "friend"},
        entity_filter_mode = nil,
        entity_filters = nil,
--      entity_filter_mode = "blacklist",
--		entity_filters = {"unapproved-ghost-placeholder"},
        started_sound = { filename = "__core__/sound/upgrade-select-start.ogg" },
        ended_sound = { filename = "__core__/sound/upgrade-select-end.ogg" },
    },

    alt_select = {
        border_color = {239, 153, 34}, -- copied from upgrade-planner
        cursor_box_type = "not-allowed", -- copied from upgrade-planner
        mode = {"entity-ghost", "same-force"},
        entity_filter_mode = nil,
        entity_filters = nil,
--      entity_filter_mode = "blacklist",
--      entity_filters = {"unapproved-ghost-placeholder"},
        started_sound = { filename = "__core__/sound/upgrade-cancel-start.ogg" },
        ended_sound = { filename = "__core__/sound/upgrade-cancel-end.ogg" },
    },

    -- Note: the below *mostly* works for approval selection.  The problem is that I really need to be able to apply
    -- filters that differentiate between ghosts and non-ghosts, and there doesn't seem to be any good way to do that.
    -- I can implement a filter that selects the approved/unapproved ghosts, but it also selects non-ghost entities
    -- as well, which is weird.  Instead, I think it's better to just select "nothing", as above
    -- selection_mode = {"blueprint"},
    -- entity_filters = {"unapproved-ghost-placeholder"},
    -- tile_filters = {"out-of-map"}, -- forces tiles to never be included in the selection
    -- alt_selection_mode = {"blueprint"},
    -- alt_entity_filter_mode = "blacklist",
    -- -- alt_entity_type_filters = {"entity-ghost", "transport-belt"},
    -- alt_tile_filters = {"out-of-map"}, -- forces tiles to never be included in the selection
  },
})

data:extend({{
  type = "shortcut",
  name = "give-unismelting-planner",
  order = "b[blueprints]-u[unismelting-planner]",
  localised_name = {"shortcut-name.give-unismelting-planner"},
  localised_description = {"shortcut-description.give-unismelting-planner"},
  associated_control_input = "give-unismelting-planner",
  action = "spawn-item",
  item_to_spawn = "unismelting-planner",
  technology_to_unlock = nil, -- optional, available immediately
  style = "blue",
  icon = "__lo_unismelting__/unismelting-planner-32.png",
  icon_size = 32,
  small_icon = "__lo_unismelting__/unismelting-planner-24.png",
  small_icon_size = 24,
}})

data:extend({{
  type = "custom-input",
  name = "give-unismelting-planner",
  localised_name = {"shortcut-name.give-unismelting-planner"},
  localised_description = {"shortcut-description.give-unismelting-planner"},
  key_sequence = "SHIFT + U",
  action = "spawn-item",
  item_to_spawn = "unismelting-planner",
}})
