-- =======================================================================
-- Unismelting - data-final-fixes.lua
-- =======================================================================
-- This script automatically generates "uni-" versions of selected
-- assembling machines and their compatible single-ingredient recipes.
-- =======================================================================

local unimachines = {"crusher1", "crusher2", "crusher3"}

local overlay_entities = settings.startup["unismelting-overlay-entities"] and settings.startup["unismelting-overlay-entities"].value
local overlay_icons    = settings.startup["unismelting-overlay-icons"] and settings.startup["unismelting-overlay-icons"].value

-- Helper: deep copy (Factorio-provided util)
local deepcopy = util.table.deepcopy or table.deepcopy

-- Track known "uni-" categories
local known_uni_cats = {}

-- =======================================================================
-- 1. Generate "uni-" versions of selected machines
-- =======================================================================
for _, name in pairs(unimachines) do
    local base = data.raw["assembling-machine"][name]
    if not base then
        log("[Unismelting] Machine not found: " .. name)
    else
        local uni = deepcopy(base)
        uni.name = "uni-" .. base.name
        uni.localised_name = {"entity-name.uni-prefix", base.localised_name or {"entity-name."..base.name}}

        -- Make sure the player can build it using the same item
        if base.minable and base.minable.result then
            uni.minable.result = base.minable.result
        end
        if base.placeable_by then
            uni.placeable_by = deepcopy(base.placeable_by)
        else
            uni.placeable_by = {item = base.name, count = 1}
        end

        -- Convert crafting categories
        local new_categories = {}
        for _, cat in pairs(base.crafting_categories or {}) do
            local new_cat = "uni-" .. cat
            table.insert(new_categories, new_cat)
            known_uni_cats[new_cat] = true
            if not data.raw["recipe-category"][new_cat] then
                data:extend({{type = "recipe-category", name = new_cat}})
            end
        end
        uni.crafting_categories = new_categories

        -- Upgrade chains preserved
        if base.next_upgrade then
            uni.next_upgrade = "uni-" .. base.next_upgrade
        end

        -- Icon overlay
        if overlay_entities then
            local icons = base.icons or {{icon = base.icon}}
            table.insert(icons, {
                icon = "__lo_unismelting__/u.png",
                icon_size = 5,
                scale = 0.25,
                shift = {8, 8}
            })
            uni.icons = icons
        end

        data:extend({uni})
        log("[Unismelting] Created Uni-machine: " .. uni.name)
    end
end

-- =======================================================================
-- 2. Collect single-ingredient recipes and detect conflicts
-- =======================================================================

local item_recipes = {}   -- [item_name] = {recipe1, recipe2, ...}
local conflict_items = {} -- [item_name] = true

for name, recipe in pairs(data.raw.recipe) do
    -- Determine ingredient count
    local ingredients = recipe.normal and recipe.normal.ingredients or recipe.ingredients
    if ingredients and #ingredients == 1 then
        local ing = ingredients[1].name or ingredients[1][1]
        if ing then
            if not item_recipes[ing] then
                item_recipes[ing] = {recipe}
            else
                table.insert(item_recipes[ing], recipe)
                conflict_items[ing] = true
            end
        end
    end
end

-- Remove conflicts
for ing, _ in pairs(conflict_items) do
    log("[Unismelting] Conflict detected for ingredient '" .. ing .. "', multiple single-ingredient recipes found.")
    item_recipes[ing] = nil
end

-- =======================================================================
-- 3. Duplicate recipes into "uni-" categories
-- =======================================================================

for ing, recs in pairs(item_recipes) do
    local r = recs[1]
    local cat = r.category or "crafting"
    local new_cat = "uni-" .. cat

    -- Only generate for categories used by Uni-machines
    if known_uni_cats[new_cat] then
        -- Ensure category exists
        if not data.raw["recipe-category"][new_cat] then
            data:extend({{type = "recipe-category", name = new_cat}})
        end

        local uni = deepcopy(r)
        uni.name = "uni-" .. r.name
        uni.category = new_cat

        -- Ensure unique name
        if data.raw.recipe[uni.name] then
            uni.name = uni.name .. "-auto"
        end

        -- Add overlay icon if enabled
        if overlay_icons then
            local icons = r.icons or {{icon = r.icon}}
            table.insert(icons, {
                icon = "__lo_unismelting__/u.png",
                icon_size = 5,
                scale = 0.25,
                shift = {8, 8}
            })
            uni.icons = icons
        end

        data:extend({uni})
        log("[Unismelting] Added uni-recipe: " .. uni.name)
    end
end

-- =======================================================================
-- 4. Debug summary
-- =======================================================================
log("[Unismelting] Finished generating Uni-machines and Uni-recipes.")
