local PANEL = {}


local function pluralizeString(str, quantity)
	return str .. ((quantity ~= 1) and "" or "s")
end

local function getNumber( seconds )
	if ( seconds == nil ) then return 0 end
	if ( seconds < 60 ) then
		local t = math.floor( seconds )
		return t
	end

	if ( seconds < 60 * 60 ) then
		local t = math.floor( seconds / 60 )
		return t 
	end

	if ( seconds < 60 * 60 * 24 ) then
		local t = math.floor( seconds / (60 * 60) )
		return t
	end

	if ( seconds < 60 * 60 * 24 * 7 ) then
		local t = math.floor( seconds / (60 * 60 * 24) )
		return t
	end
	
	if ( seconds < 60 * 60 * 24 * 7 * 52 ) then
		local t = math.floor( seconds / (60 * 60 * 24 * 7) )
		return t 
	end

	local t = math.floor( seconds / (60 * 60 * 24 * 7 * 52) )
	return t
end

function PANEL:Init( )
end

function PANEL:AddTimeleftInfo( )
	if IsValid( self.timeleftPanel ) then
		self.timeleftPanel:Remove( )
	end
	
	self.timeleftPanel = vgui.Create( "DPanel", self )
	self.timeleftPanel:Dock( TOP )
	self.timeleftPanel:DockMargin( 0, 8, 0, 0 )
	Derma_Hook( self.timeleftPanel, "Paint", "Paint", "InnerPanelBright" )
	self.timeleftPanel:SetTall( 50 )
	self.timeleftPanel:DockPadding( 5, 5, 5, 5 )
	function self.timeleftPanel:PerformLayout( )
		self:SizeToChildren( false, true )
	end
	
	local label = vgui.Create( "DLabel", self.timeleftPanel )
	function label.Think( )
		local item = KInventory.ITEMS[self.item.id] or self.item
		if not item then return end
		label:SetText( string.NiceTime( item.timeLeft ) .. " " .. pluralizeString( "remain", getNumber( item.timeLeft ) ) .. "." ) 
		label:SizeToContents( )
	end
	label:Dock( TOP )
end

function PANEL:SetItem( item, noButtons )
	self.BaseClass.SetItem( self, item, noButtons )
	if item:IsDrainable( ) then
		self:AddTimeleftInfo( )
	end
end

function PANEL:SelectionReset( )
	self.BaseClass.SelectionReset( self )
	if self.timeleftPanel then
		self.timeleftPanel:Remove( )
	end
end

derma.DefineControl( "DBoosterItemDescription", "", PANEL, "DPointshopItemDescription" )