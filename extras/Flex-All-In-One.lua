--twitter.com/polalagi
--ModuleScript

warn("[Flex] [All-In-One] The All-In-One module will be updated rarely, do not use this for your games, instead use the normal method.")

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

--twitter.com/polalagi
--ModuleScript

local elementClass = {}

elementClass.__index=elementClass

function elementClass.new(className,options,coreProperties,coreHoverProperties,parent,name)
	assert(options,"[Flex] [Element] Options are required.")
	local self={}
	
	setmetatable(self,elementClass)
	
	local sizeExists=options["Size"]~=nil
	local positionExists=options["Position"]~=nil
	local styleExists=options["Props"]~=nil
	local effectExists=options["Effect"]~=nil
	local hoverStylingExists=options["HoverProps"]~=nil
	
	self.className=className
	self.size=sizeExists and options["Size"] or UDim2.fromScale(0.1,0.1)
	self.position=positionExists and options["Position"] or UDim2.fromScale(0,0)
	self.styling=styleExists and options["Props"] or {}
	self.coreStyling=coreProperties
	self.coreHoverStyling=coreHoverProperties
	self.hoverStyling=hoverStylingExists and options["HoverProps"] or {}
	self.parent=parent or "UseRoot"
	self.name=name
	self.id=options["Id"] or options["Identifier"]
	assert(self.id,"[Flex] [Element] An ID for the element is required.")
	self.rendered=false
	self.effect=effectExists and options["Effect"] or nil
	self.obj=nil
	self.new=nil
	self.newComponent=nil
	
	function self:render()
		assert(not self.rendered,"[Flex] [Element] An element can only be rendered once.")
		self.rendered=true
		local obj=Instance.new(self.className)
		obj.Size=self.size
		obj.Position=self.position
		obj.BorderSizePixel=0
		obj.MouseEnter:Connect(function()
			for key1,value1 in pairs(self.coreStyling) do
				obj[key1]=value1
			end
			for key,value in pairs(self.coreHoverStyling) do
				obj[key]=value
			end
			for k1,v1 in pairs(self.styling or {}) do
				obj[k1]=v1
			end
			for k,v in pairs(self.hoverStyling) do
				obj[k]=v
			end
		end)
		obj.MouseLeave:Connect(function()
			for key,value in pairs(self.coreStyling) do
				obj[key]=value
			end
			for k,v in pairs(self.styling or {}) do
				obj[k]=v
			end
		end)
		if self.className=="TextButton" then
			obj.MouseButton1Down:Connect(function()
				for key,value in pairs(self.coreStyling) do
					obj[key]=value
				end
				for k,v in pairs(self.styling or {}) do
					obj[k]=v
				end
			end)
		end
		for key,value in pairs(self.coreStyling) do
			obj[key]=value
		end
		obj.Name=self.name
		for k,v in pairs(self.styling) do
			obj[k]=v
		end
		obj.Parent=self.parent
		if self.effect then
			self.effect.Parent=obj
		end
		self.obj=obj
		return obj
	end
	
	return self
end

function elementClass.newComponent(component,options,parent,name)
	assert(options,"[Flex] [Element] Options are required.")
	assert(component,"[Flex] [Element] The component is a required argument.")
	local self={}
	
	setmetatable(self,elementClass)
	
	local sizeExists=options["Size"]~=nil
	local positionExists=options["Position"]~=nil
	local styleExists=options["Props"]~=nil
	local effectExists=options["Effect"]~=nil
	local hoverStylingExists=options["HoverProps"]~=nil
	
	self.component=component.new(self)
	self.size=sizeExists and options["Size"] or UDim2.fromScale(0.1,0.1)
	self.position=positionExists and options["Position"] or UDim2.fromScale(0,0)
	self.styling=styleExists and options["Props"] or {}
	self.coreStyling=self.component.coreProperties
	self.coreHoverStyling=self.component.coreHoverProperties
	self.hoverStyling=hoverStylingExists and options["HoverProps"] or {}
	self.parent=parent or "UseRoot"
	self.name=name
	self.id=options["Id"] or options["Identifier"]
	assert(self.id,"[Flex] [Element] An ID for the element is required.")
	self.rendered=false
	self.effect=effectExists and options["Effect"] or nil
	self.obj=nil
	self.new=nil
	self.newComponent=nil

	function self:render()
		assert(not self.rendered,"[Flex] [Element] An component can only be rendered once.")
		self.rendered=true
		self.obj=self.component:render()
	end
	
	return self
end

local http=game:GetService("HttpService")

type Options = {
	Position: UDim2?,
	Size: UDim2?,
	Props: any?,
	Id: string?,
	Identifier: string?,
	Parent: string?,
	Effect: any?,
	[any?]: any?,
}

type Effect = "ListLayout" | "GridLayout" | "TableLayout" | "PageLayout" | "AspectRatioConstraint" | "SizeConstraint" | "TextSizeConstraint" | "Gradient" | "Stroke" | "Corner" | "Padding" | "Scale"

type UIEffect = UIListLayout | UIGridLayout | UITableLayout | UIPageLayout | UIAspectRatioConstraint | UISizeConstraint | UITextSizeConstraint | UIGradient | UIStroke | UICorner | UIPadding | UIScale

function flex.create(internalName: string,options: Options)
	assert(flex.classMapping[internalName],"[Flex] [Library] \""..internalName.."\" is not a valid class.")
	assert(not flex.getElementById(options["Id"] or options["Identifier"]),"[Flex] [Library] Object with identifier \""..(options["Id"] or options["Identifier"]).."\" already exists.")
	assert(options["Id"] or options["Identifier"],"[Flex] [Library] An ID is required for an element.")
	assert((options["Id"] or options["Identifier"])~="UseRoot","[Flex] [Library] \"UseRoot\" is not allowed as an identifier.")
	assert(not (options["Id"] and options["Identifier"]),"[Flex] [Library] Please choose only one field - \"Id or Identifier\" - Both fields are not allowed.")
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

function flex.createComponent(component: any,options: Options)
	assert(not flex.getElementById(options["Id"] or options["Identifier"]),"[Flex] [Library] Object with identifier \""..(options["Id"] or options["Identifier"]).."\" already exists.")
	assert(options["Id"] or options["Identifier"],"[Flex] [Library] An ID is required for an element.")
	assert((options["Id"] or options["Identifier"])~="UseRoot","[Flex] [Library] \"UseRoot\" is not allowed as an identifier.")
	assert(not (options["Id"] and options["Identifier"]),"[Flex] [Library] Please choose only one field - \"Id or Identifier\" - Both fields are not allowed.")
	local element=elementClass.newComponent(
		component,
		options,
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
	main.Name="FlexGUI@"..displayType
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
	assert(flex.effectMapping[effectName],"[Flex] [Library] \""..effectName.."\" is not a valid effect name.")
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