-- Multiplies the spoil time of the agricultural science pack.
-- Applied ONCE, here in data-final-fixes, so it runs after other mods have
-- finished defining/altering the pack.

local PACK_NAME = "agricultural-science-pack"
local UINT32_MAX = 4294967295 -- spoil_ticks is a uint32

local mult = settings.startup["agri-spoil-multiplier"].value

-- Item prototypes live under many data.raw types, and overhaul mods (e.g.
-- Krastorio 2 Spaced Out) may move science packs out of "tool" entirely, so
-- data.raw.tool can be nil. Search every item type, guarding each table.
local function item_types()
  if defines and defines.prototypes and defines.prototypes.item then
    local types = {}
    for t in pairs(defines.prototypes.item) do types[#types + 1] = t end
    return types
  end
  return {
    "tool", "item", "capsule", "ammo", "module", "armor", "gun", "repair-tool",
    "rail-planner", "item-with-entity-data", "item-with-label",
    "item-with-inventory", "item-with-tags", "blueprint", "blueprint-book",
    "deconstruction-item", "upgrade-item", "selection-tool", "copy-paste-tool",
    "spidertron-remote", "space-platform-starter-pack",
  }
end

local function find_pack()
  for _, t in pairs(item_types()) do
    local tbl = data.raw[t]
    if tbl and tbl[PACK_NAME] then return tbl[PACK_NAME] end
  end
end

local pack = find_pack()
if not pack then
  log("[agri-spoil-multiplier] '" .. PACK_NAME .. "' not found; nothing to change.")
elseif not pack.spoil_ticks or pack.spoil_ticks <= 0 then
  log("[agri-spoil-multiplier] '" .. PACK_NAME .. "' does not spoil; nothing to change.")
else
  local ticks = math.floor(pack.spoil_ticks * mult + 0.5)
  pack.spoil_ticks = math.max(1, math.min(ticks, UINT32_MAX))
end
