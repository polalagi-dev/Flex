--twitter.com/polalagi
--ModuleScript

local flex = {
	DefaultProps={
		["Button"]={
			BackgroundColor3=Color3.fromRGB(40,40,40),
			BorderSizePixel=5,
			BorderColor3=Color3.fromRGB(53,53,53),
			FontFace=Font.fromEnum(Enum.Font.Roboto),
			Text="Button",
			TextWrapped=true,
			TextTruncate=Enum.TextTruncate.AtEnd,
			TextSize=25,
			TextColor3=Color3.fromRGB(255,255,255),
			AutoButtonColor=false,
		},
		["Body"]={
			BackgroundColor3=Color3.fromRGB(40,40,40)
		},
		["Text"]={
			BackgroundTransparency=1,
			FontFace=Font.fromEnum(Enum.Font.Roboto),
			Text="Text",
			TextWrapped=true,
			TextTruncate=Enum.TextTruncate.AtEnd,
			TextSize=25,
			TextColor3=Color3.fromRGB(255,255,255)
		},
		["ClickableImage"]={
			BackgroundColor3=Color3.fromRGB(40,40,40),
			BackgroundTransparency=1
		},
		["Image"]={
			BackgroundColor3=Color3.fromRGB(40,40,40),
			BackgroundTransparency=1
		},
		["ScrollBody"]={
			BackgroundColor3=Color3.fromRGB(40,40,0)
		}
	},
	DefaultHoverProps={
		["Button"]={
			BackgroundColor3=Color3.fromRGB(0, 145, 255)
		}
	},
	elements={},
	classMapping = {
		["Button"]="TextButton",
		["ClickableImage"]="ImageButton",
		["Body"]="Frame",
		["Text"]="TextLabel",
		["Image"]="ImageLabel",
		["ScrollBody"]="ScrollingFrame",
	},
	displayTypeMapping = {
		["Screen"]="ScreenGui",
		["Surface"]="SurfaceGui",
		["Billboard"]="BillboardGui",
	},
	_currentUI=nil,
	_mountCallback={},
	_rendered=false,
	effectMapping = {
		["ListLayout"]="UIListLayout",
		["GridLayout"]="UIGridLayout",
		["TableLayout"]="UITableLayout",
		["PageLayout"]="UIPageLayout",
		["AspectRatioConstraint"]="UIAspectRatioConstraint",
		["SizeConstraint"]="UISizeConstraint",
		["TextSizeConstraint"]="UITextSizeConstraint",
		["Gradient"]="UIGradient",
		["Stroke"]="UIStroke",
		["Corner"]="UICorner",
		["Padding"]="UIPadding",
		["Scale"]="UIScale"
	}
}
local elementClass=require(script.ElementClass)
local http=game:GetService("HttpService")

type Options = {
	Position: UDim2?,
	Size: UDim2?,
	Props: any?,
	Id: string?,
	Parent: string?,
	[any?]: any?,
}

type Effect = "ListLayout" | "GridLayout" | "TableLayout" | "PageLayout" | "AspectRatioConstraint" | "SizeConstraint" | "TextSizeConstraint" | "Gradient" | "Stroke" | "Corner" | "Padding" | "Scale"

type UIEffect = UIListLayout | UIGridLayout | UITableLayout | UIPageLayout | UIAspectRatioConstraint | UISizeConstraint | UITextSizeConstraint | UIGradient | UIStroke | UICorner | UIPadding | UIScale

function flex.create(internalName: string,options: Options)
	assert(flex.classMapping[internalName],`[Flex] [Library] {internalName} is not a valid class.`)
	assert(not flex.getElementById(options["Id"] or options["Identifier"]),`[Flex] [Library] Object with identifier "{options["Id"] or options["Identifier"]}" already exists.`)
	assert(options["Id"] or options["Identifier"],"[Flex] [Library] An ID is required for an element.")
	assert((options["Id"] or options["Identifier"])~="UseRoot","[Flex] [Library] \"UseRoot\" is not allowed as an identifier.")
	local element=elementClass.new(
		flex.classMapping[internalName],
		options,
		flex.DefaultProps[internalName] or {},
		flex.DefaultHoverProps[internalName] or {},
		options["Parent"] or nil,
		http:GenerateGUID(false)
	)
	table.insert(flex.elements,element)
end

function flex.render(parent: PlayerGui | Instance,displayType: "Screen" | "Billboard" | "Surface",displayProps)
	if flex._rendered then
		warn("[Flex] [Library] You cannot render the GUI twice.")
		return
	end
	flex._rendered=true
	local displayClass=flex.displayTypeMapping[displayType] or displayType
	displayProps=if displayProps~=nil or #displayProps>0 then displayProps else {}
	local main=Instance.new(displayClass)
	main.Name=`FlexGUI@{displayType}`
	for k,v in pairs(displayProps) do
		main[k]=v
	end
	main.Parent=parent
	for _,element in pairs(flex.elements) do
		if element.rendered then continue end
		if element.parent~="UseRoot" then
			local p1
			for _,el in pairs(flex.elements) do
				if el.id==element.parent then
					p1=el
					break
				end
			end
			local rendered_p1=p1.obj~=nil
			local p=rendered_p1 and p1.obj or p1:render()
			element.parent=p
		else
			element.parent=main
		end
		element:render()
	end
	flex.currentUI=main
	main.Destroying:Connect(function()
		flex.currentUI=nil
	end)
	for _,callback in pairs(flex._mountCallback) do
		callback(main)
	end
end

function flex.getElementById(id: string)
	local target=nil
	for _,element in pairs(flex.elements) do
		if element.id==id then
			target=element
			break
		end
	end
	return target
end

function flex.getObjectById(id: string)
	local element=flex.getElementById(id)
	return element~=nil and element.obj or nil
end

function flex.onMount(callback: (GuiBase) -> (any))
	table.insert(flex._mountCallback,callback)
end

function flex.applyEffect(effectName: Effect,props: UIEffect)
	assert(flex.effectMapping[effectName],`[Flex] [Library] {effectName} is not a valid effect name.`)
	local effectClass=flex.effectMapping[effectName]
	local isPropsNil=props==nil
	local customProps=props
	local effectInstance=Instance.new(effectClass)
	for k,v in pairs(isPropsNil and {} or customProps) do
		effectInstance[k]=v
	end
	return effectInstance
end

return flex
