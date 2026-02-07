prism.registerActor("Player", function()
   return prism.Actor.fromComponents {
      prism.components.Name("Player"),
      prism.components.Drawable { index = "@", color = prism.Color4.BLUE },
      prism.components.Position(),
      prism.components.Collider(),
      prism.components.PlayerController(),
      prism.components.Senses(),
      prism.components.LightSight { range = 24, fov = true, darkvision = 2 / 16 },
      prism.components.Mover { "walk" },
      -- Light effects modify the colour of the light over time. We provide a few, each with a set of
      -- options to play around with.
      prism.components.Light(prism.Color4.YELLOW, 9, prism.lighteffects.FlickerEffect()),
   }
end)
