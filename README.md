<img src="Assets/FlexLandscape.png" alt="Flex" width="512px">

### Flex - Simple and lightweight UI Framework for ROBLOX.

---

To get Flex, paste this into the Roblox Studio command line.

```lua
local folder=Instance.new("Folder",game.StarterPlayer.StarterPlayerScripts)
local flex=Instance.new("ModuleScript",folder)
local elementClass=Instance.new("ModuleScript",flex)
local http=game:GetService("HttpService")
flex.Source=http:GetAsync("http://raw.githubusercontent.com/polalagi-dev/Flex/main/Flex.lua")
elementClass.Source=http:GetAsync("http://raw.githubusercontent.com/polalagi-dev/Flex/main/ElementClass.lua")
flex.Name="Flex"
elementClass.Name="ElementClass"
folder.Name="FlexWorkspace"
warn(`[Flex] [Command] Flex added in {folder.Name} in StarterPlayerScripts.`)
```
