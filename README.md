<div align="center">

  <img src="assets/FlexLandscape.png" alt="Flex" width="512px">

  <h3>Flex - Simple and lightweight UI Framework for ROBLOX.</h3>

  <img src="https://img.shields.io/github/repo-size/polalagi-dev/Flex?label=Flex%20Size%20%28approx.%29&logo=roblox" />
  <img src="https://img.shields.io/github/directory-file-count/polalagi-dev/Flex/src?extension=lua&label=Flex%20Source%20Files&logo=Roblox&type=file" />

</div>

---

To get Flex, paste this into the Roblox Studio command line.

##### Make sure you have HTTP Requests enabled.

```lua
local folder = Instance.new("Folder",game.StarterPlayer.StarterPlayerScripts)
local flex = Instance.new("ModuleScript",folder)
local elementClass = Instance.new("ModuleScript",flex)
local http = game:GetService("HttpService")
flex.Source = http:GetAsync("http://raw.githubusercontent.com/polalagi-dev/Flex/main/src/Flex.lua")
elementClass.Source = http:GetAsync("http://raw.githubusercontent.com/polalagi-dev/Flex/main/src/ElementClass.lua")
flex.Name = "Flex"
elementClass.Name = "ElementClass"
folder.Name = "FlexWorkspace"
warn("[Flex] [Command] Flex added in "..folder.Name.." in StarterPlayerScripts.")
```

## Functions

- `Flex.create(elementName: string, options: Options)`

  Create an element.

  Returns an Element. _(Use Flex.getElementById instead)_

  Example usage

  ```lua
  Flex.create("Button",{
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromScale(0.25, 0.1),
    Id = "MainButton",
    Parent = "UseRoot",
    Props = {
      AnchorPoint = Vector2.new(0.5,0.5)
    }
  })
  ```

- `Flex.render(parent: PlayerGui | Instance, displayType: "Screen" | "Billboard" | "Surface", displayProps: table)`

  Render the GUI.

  Any FlexUI can only be rendered **ONCE**.

  Example usage

  ```lua
  Flex.render(player.PlayerGui, "Screen" , {
    IgnoreGuiInset=true
  })
  ```

- `Flex.onMount(callback: (FlexUI: GuiBase) -> (any))`

  Registers a callback.

  All of the registered `onMount` callbacks will be fired once the GUI is rendered.

  Example usage

  ```lua
  Flex.onMount(function(FlexUI: GuiBase)
    print(FlexUI.Name)
    return
  end)
  ```

- `Flex.getElementById(id: string)`

  If there is an element with the given `id`, it returns the Element, else it returns nil.

  Example usage

  ```lua
  local MainButton = Flex.getElementById("MainButton")
  ```

- `Flex.getObjectById(id: string)`

  If there is an element with the given `id`, it returns the `GuiObject`, else it returns nil.

  Example usage

  ```lua
  local MainButtonObject = Flex.getObjectById("MainButton")
  ```

- `Flex.applyEffect(effectName: Effect, props: UIEffect)`

  To be used in the options of `Flex.create` as the `Effect` key.

  Applies an effect to the element.

  Example usage

  ```lua
  Flex.create("Button",{
    -- Options
    Effect = Flex.applyEffect("Stroke",{
        LineJoinMode = Enum.LineJoinMode.Round,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Thickness = 5,
        Color = Color3.fromRGB(70,70,70)
    })
  })
  ```

- `Flex.createComponent(component: any, options: Options)`

  Create an component.

  Returns an Component. _(Use Flex.getElementById instead)_

  Example usage

  ```lua
  Flex.createComponent(SwitchComponent,{
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromScale(0.25, 0.1),
    Id = "MainSwitch",
    Parent = "UseRoot",
    Props = {
      AnchorPoint = Vector2.new(0.5,0.5)
    }
  })
  ```

## Components

This is the code of a component, I won't go too much into detail on how it works since you can get a good understanding from just reading the code.
Feel free to contribute to this section though!

```lua
--ModuleScript "LabelComponent"

local component={
  element = nil, -- Required field.
  coreStyling = {
    BorderSizePixel = 0,
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(255,255,255)
  }, -- Can be empty, but the field is required.
  coreHoverStyling = {}, -- Can be empty, but the field is required.
}

component.__index=component

function component.new(data)
  local self={}

  setmetatable(self,component)

  self.element=data

  self.new=nil -- Removing the new function from the component.

  function self:render()
    local obj=Instance.new("TextLabel")

    -- Apply default properties
    for key,value in pairs(self.element.coreStyling) do
			obj[key]=value
		end

		obj.Name=self.element.name

    -- Apply user-defined properties (This for loop can be removed)
		for k,v in pairs(self.element.styling) do
			obj[k]=v
		end

    obj.Parent=self.element.Parent

    return obj -- This return must be here, else the component won't function as intended.
    -- If your going to render multiple objects, return the parent object of the other objects. (e.g. A frame)
  end
end

return component
```

A part of the LocalScript.

```lua
local LabelComponent = require(script.LabelComponent) -- Get the component.

...

Flex.createComponent(LabelComponent,{
  ...
}) -- Create the component with the given props.
```

## License

Flex is licensed under the Apache 2.0 license. See [LICENSE](/LICENSE) for more details.
