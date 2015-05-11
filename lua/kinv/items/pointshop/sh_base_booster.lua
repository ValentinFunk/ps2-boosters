ITEM.PrintName = "Pointshop Booster Base"
ITEM.baseClass = "base_pointshop_item"

ITEM.category = "Boosters"

--Constructor
function ITEM:initialize( )
	ITEM.super.initialize( self )
	self.saveFields = self.saveFields or { }
	self.timeLeft = self.class.boostParams["BasicSettings.Duration"] --gets overwritten if loaded from db
	table.insert( self.saveFields, "timeLeft" )
end

--Called in intervals to check if the boost duration should go down
function ITEM:ShouldDrainTime( )
	local booster = Pointshop2.GetBoosterByName( self.class.boostType )
	return booster.ShouldDrainTime( item, self:GetOwner( ) )
end

function ITEM:IsDrainable( )
	return self.class.boostParams["BasicSettings.Duration"] > 0
end

function ITEM:GetSellPrice( )
	local sellPrice, currency = ITEM.super.GetSellPrice( self )
	if self:IsDrainable( ) then
		local factUsed = self.timeLeft / self.class.boostParams["BasicSettings.Duration"]
		return math.floor( sellPrice * factUsed ), currency
	end
	return sellPrice, currency
end

/*
	Inventory icon
*/
function ITEM:getIcon( )
	self.icon = vgui.Create( "DPointshopMaterialInvIcon" )
	self.icon:SetItem( self )
	self.icon:SetSize( 64, 64 )
	return self.icon
end

function ITEM:OnEquip( )
	if not self:IsDrainable( ) then
		return
	end
	
	if SERVER then
		timer.Create( "PS2_SaveItemDrain" .. self.id, 5, 0, function( )
			if not self or not IsValid( self:GetOwner( ) ) or self.timeLeft <= 0 then 
				return 
			end
			
			if not self:ShouldDrainTime( ) then
				return
			end
			
			self:save( )
		end )
	end

	timer.Create( "PS2_ItemDrain" .. self.id, 1, 0, function( )
		if not self or not IsValid( self:GetOwner( ) ) or self.timeLeft <= 0 then 
			return 
		end
		
		if not self:ShouldDrainTime( ) then
			return
		end
		
		self.timeLeft = self.timeLeft - 1
		self.hallo = self.timeLeft - 1
		if self.timeLeft <= 0 and SERVER then
			Pointshop2Controller:getInstance( ):removeItemFromPlayer( self:GetOwner( ), self )
			return
		end
	end )
end

function ITEM:OnHolster( )
	timer.Remove( "PS2_ItemDrain" .. self.id )
	timer.Remove( "PS2_SaveItemDrain" .. self.id )
end

function ITEM.static.GetPointshopIconControl( )
	return "DPointshopMaterialIcon"
end

function ITEM.static:GetPointshopLowendIconControl( )
	return "DPointshopMaterialIcon" 
end

function ITEM.static.GetPointshopDescriptionControl( )
	return "DBoosterItemDescription"
end

function ITEM.static.getPersistence( )
	return Pointshop2.BoosterPersistence
end

function ITEM.static.generateFromPersistence( itemTable, persistenceItem )
	ITEM.super.generateFromPersistence( itemTable, persistenceItem.ItemPersistence )
	itemTable.boostType = persistenceItem.boostType
	itemTable.boostParams = persistenceItem.boostParams
	itemTable.material = persistenceItem.material
end

function ITEM.static.GetPointshopIconDimensions( )
	return Pointshop2.GenerateIconSize( 4, 4 )
end