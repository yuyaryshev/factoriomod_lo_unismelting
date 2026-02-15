-- An experiment that shows that there can exist several smelting recipes for one item
-- Some of them can be locked with a tech.
-- Furnace will always sort them using 'order' field and pick the first one the is unlocked (enabled)
data:extend({
  {
    type = "technology",
    name = "test-smelting-upgrade",
    icon = "__base__/graphics/technology/advanced-material-processing.png",
    icon_size = 256,
    prerequisites = {},
    effects = {
      {type = "unlock-recipe", recipe = "test-smelt-copper-to-circuit"}
    },
    unit = {
      count = 1,
      ingredients = {}, -- no packs required
      time = 1
    },
    order = "a[test-smelting-upgrade]"
  },
  {
    type = "recipe",
    name = "test-smelt-copper-to-circuit",
    category = "smelting",
    enabled = false,
    energy_required = 1,
    ingredients = {
      {type = "item", name = "copper-plate", amount = 1}
    },
    results = {
      {type = "item", name = "electronic-circuit", amount = 1}
    },
    subgroup = "intermediate-product",
    order = "a-test-smelt-copper-to-circuit",
  },
  {
    type = "recipe",
    name = "test-smelt-copper-to-cable",
    category = "smelting",
    enabled = true,
    energy_required = 1,
    ingredients = {
      {type = "item", name = "copper-plate", amount = 1}
    },
    results = {
      {type = "item", name = "copper-cable", amount = 2}
    },
    subgroup = "intermediate-product",
    order = "z-test-smelt-copper-to-cable",
  }
})