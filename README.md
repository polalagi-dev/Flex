<img src="Assets/FlexLandscape.png" alt="Flex" width="512px">

### Flex - Simple and lightweight UI Framework for ROBLOX.

---

To get Flex, paste this into the Roblox Studio command line.

```lua
local folder = Instance.new("Folder",game.StarterPlayer.StarterPlayerScripts)
local flex = Instance.new("ModuleScript",folder)
local elementClass = Instance.new("ModuleScript",flex)
local http = game:GetService("HttpService")
flex.Source = http:GetAsync("http://raw.githubusercontent.com/polalagi-dev/Flex/main/Flex.lua")
elementClass.Source = http:GetAsync("http://raw.githubusercontent.com/polalagi-dev/Flex/main/ElementClass.lua")
flex.Name = "Flex"
elementClass.Name = "ElementClass"
folder.Name = "FlexWorkspace"
warn("[Flex] [Command] Flex added in "..folder.Name.." in StarterPlayerScripts.")
```

## Functions

- `Flex.create(elementName: string, options: Options)`

  Create an element.

  Returns an Element. _(Use Flex.getElementById instead)_

- `Flex.render(parent: PlayerGui | Instance, displayType: "Screen" | "Billboard" | "Surface", displayProps: table)`

  Render the GUI.

  Any FlexUI can only be rendered **ONCE**.

- `Flex.onMount(callback: (FlexUI: GuiBase) -> (any))`

  Registers a callback.

  All of the registered `onMount` callbacks will be fired once the GUI is rendered.

- `Flex.getElementById(id: string)`

  If there is an element with the given `id`, it returns the Element, else it returns nil.

- `Flex.getObjectById(id: string)`

  If there is an element with the given `id`, it returns the `GuiObject`, else it returns nil.

- `Flex.applyEffect(effectName: Effect, props: UIEffect)`

  To be used in the options of `Flex.create` as the `Effect` key.

  Applies an effect to the element.
