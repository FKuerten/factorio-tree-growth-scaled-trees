local configuration = {}
configuration.particles = {
  {
    id = "tiny",
    suffix = "-tiny",
    areaScale = 0.1,
  }
}
-- tree entity option table:
-- * id
-- * suffix
-- * particlesSuffix
-- * areaScale
-- * first, boolean
-- * next, a list of upgrades
-- ** suffix, in the prototype there will be name instead
-- ** probability that this upgrade is chosen
-- ** minDelay in ticks
-- ** maxDelay in ticks
local saplingDefinition = {
  id = "sapling",
  suffix = "-sapling",
  particleSuffix = "-tiny",
  areaScale = 0.1,
  first = true,
  next = {
    {
      suffix = "-tiny",
      probability = 1,
      minDelay = 9000,
      maxDelay = 27000,
    },
  },
}
local tinyDefinition = {
  id = "tiny",
  suffix = "-tiny",
  particleSuffix = "-tiny",
  areaScale = 0.3,
  next = {
    {
      suffix = "-large",
      probability = 1,
      minDelay = 9000,
      maxDelay = 27000,
    },
  },
}
local largeDefinition = {
  id = "large",
  suffix = "-large",
  particleSuffix = "",
  areaScale = 0.6,
  next = {
    {
      suffix = "",
      probability = 1,
      minDelay = 9000,
      maxDelay = 27000,
    },
  },  
}

if mods['IndustrialRevolution'] then
  configuration.treeEntities = {
    tinyDefinition,
    largeDefinition,
  }
  configuration.saplingDefinition=saplingDefinition
else
  configuration.treeEntities = {
    saplingDefinition,
    tinyDefinition,
    largeDefinition,
  }
end

return configuration
