--twitter.com/polalagi
--ModuleScript
local element = {}

element.__index=element

function element.new(className,options,coreProperties,parent,name)
	assert(options,"[Flex] [Element] Options are required.")
	local self={}
	
	setmetatable(self,element)
	
	local sizeExists=options["Size"]~=nil
	local positionExists=options["Position"]~=nil
	local styleExists=options["Props"]~=nil
	local effectExists=options["Effect"]~=nil
	
	self.className=className
	self.size=sizeExists and options["Size"] or UDim2.fromScale(0.1,0.1)
	self.position=positionExists and options["Position"] or UDim2.fromScale(0,0)
	self.styling=styleExists and options["Props"] or {}
	self.coreStyling=coreProperties
	self.parent=parent or "UseRoot"
	self.name=name
	self.id=options["Id"] or options["Identifier"]
	assert(self.id,"[Flex] [Element] An ID for the element is required.")
	self.rendered=false
	self.effect=effectExists and options["Effect"] or nil
	self.obj=nil
	self.new=nil
	
	function self:render()
		self.rendered=true
		local obj=Instance.new(self.className)
		obj.Size=self.size
		obj.Position=self.position
		obj.BorderSizePixel=0
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

return element
