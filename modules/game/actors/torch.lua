prism.registerActor("Torch", function()
   return prism.Actor.fromComponents {
      prism.components.Name("Torch"),
      prism.components.Drawable { color = prism.Color4.ORANGE, index = "/" },
      prism.components.Light(prism.Color4.ORANGE, 4),
      prism.components.Position(),
   }
end)
