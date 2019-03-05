
local function createParticles(suffix, areaScale)
  data:extend({
    scaleParticle(data.raw["leaf-particle"]["leaf-particle"], suffix, areaScale),
    scaleParticle(data.raw["particle"]["branch-particle"], suffix, areaScale),
  })
end

return createParticles
