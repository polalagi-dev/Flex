--twitter.com/polalagi
--ModuleScript

local element = {}

element.__index=element

function element.new(className,options,coreProperties,coreHoverProperties,parent,name)
	assert(options,"[Flex] [Element] Options are required.")
	local self={}
	
	setmetatable(self,element)
	
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
			if typeof(self.effect)~="table" then
				self.effect.Parent=obj
			else
				for _,effectObject in pairs(self.effect) do
					effectObject.Parent=obj
				end
			end
		end
		self.obj=obj
		return obj
	end
	
	return self
end

function element.newComponent(component,options,parent,name)
	assert(options,"[Flex] [Element] Options are required.")
	assert(component,"[Flex] [Element] The component is a required argument.")
	local self={}
	
	setmetatable(self,element)
	
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

return element
