local mult = settings.startup["agri-spoil-multiplier"].value
local pack = data.raw["tool"]["agricultural-science-pack"]
if pack and pack.spoil_ticks then
  pack.spoil_ticks = pack.spoil_ticks * mult
end

