prism.registerActor("Glowshroom", function()
   return prism.Actor.fromComponents {
      prism.components.Name("Glowshroom"),
      prism.components.Drawable { index = '"', color = prism.Color4.LIME },
      prism.components.Light(prism.Color4.LIME, 3),
      prism.components.Position(),
   }
end)
