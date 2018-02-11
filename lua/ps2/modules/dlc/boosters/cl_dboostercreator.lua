local PANEL = {}

function PANEL:Init( )
	self.modelAndPositioningPanel = vgui.Create( "DItemCreator_BoosterStage" )
	self.stepsPanel:AddStep( "Booster Settings", self.modelAndPositioningPanel )
end

vgui.Register( "DBoosterCreator", PANEL, "DItemCreator_Steps" )

local PANEL = {}
function PANEL:Paint( )
end

function PANEL:Init( )
	self.typeElem = vgui.Create( "DComboBoxHack" )
	function self.typeElem.OnSelect( _self, index, value, data )
		self.settingsPanel:Initialize( data.Settings )
		self.selectedType = data.Name
	end
	--self.typeElem:SetSkin( Pointshop2.Config.DermaSkin )
	self.typeElem:SetWide( 200 )
	for k, v in pairs( Pointshop2.BoosterTypes ) do
		local option = self.typeElem:AddChoice( v.Name, v )
	end
	
	local cont = self:addFormItem( "Type", self.typeElem )
	function cont.PerformLayout( )
		self.typeElem:PerformLayout( )
		cont:SetTall( self.typeElem:GetTall( ) )
	end
	--cont:SetTall( 35 )
	
	self.settingsPanel = vgui.Create( "DPanel", self )
	self.settingsPanel:Dock( TOP )
	function self.settingsPanel:Paint( w, h )
	end
	
	function self.settingsPanel:PerformLayout( )
		if IsValid( self.actualSettings ) then
			self.actualSettings:SizeToChildren( false, true )
		end
		self:SizeToChildren( false, true )
	end

	function self.settingsPanel:SetSettings( settingsTbl )
		self.actualSettings:SetData( settingsTbl )
	end
	
	function self.settingsPanel:Initialize( settingsInfoTbl )
		if IsValid( self.actualSettings ) then
			self.actualSettings:Remove( )
		end	
		
		self.actualSettings = vgui.Create( "DSettingsPanel", self )
		self.actualSettings:Dock( FILL )
		self.actualSettings:AutoAddSettingsTable( settingsInfoTbl )
		self:InvalidateLayout()
	end
	
	function self.settingsPanel:GetSettingsTable( )
		return self.actualSettings.settings
	end
	
	self.typeElem:ChooseOptionID( 1 )
	
	
	self.selectMatElem = vgui.Create( "DPanel" )
	self.selectMatElem:SetTall( 64 )
	self.selectMatElem:SetWide( self:GetWide( ) )
	function self.selectMatElem:Paint( ) end
	
	self.materialPanel = vgui.Create( "DImage", self.selectMatElem )
	self.materialPanel:SetSize( 64, 64 )
	self.materialPanel:Dock( LEFT )
	self.materialPanel:SetMouseInputEnabled( true )
	self.materialPanel:SetTooltip( "Click to Select" )
	self.materialPanel:SetMaterial( "boosters/small65.png" )
	local frame = self
	function self.materialPanel:OnMousePressed( )
		--Open model selector
		local window = vgui.Create( "DMaterialSelector" )
		window:Center( )
		window:MakePopup( )
		window:DoModal()
		Pointshop2View:getInstance( ):requestMaterials( "boosters" )
		:Done( function( files )
			window:SetMaterials( "boosters", files )
		end )
		function window:OnChange( )
			frame.manualEntry:SetText( window.matName )
			frame.materialPanel:SetMaterial( window.matName )
		end
	end
	
	local rightPnl = vgui.Create( "DPanel", self.selectMatElem )
	rightPnl:Dock( FILL )
	function rightPnl:Paint( )
	end

	self.manualEntry = vgui.Create( "DTextEntry", rightPnl )
	self.manualEntry:Dock( TOP )
	self.manualEntry:DockMargin( 5, 0, 5, 5 )
	self.manualEntry:SetText( "boosters/small65.png" )
	self.manualEntry:SetTooltip( "Click on the icon or manually enter the material path here and press enter" )
	function self.manualEntry:OnEnter( )
		frame.materialPanel:SetMaterial( self:GetText( ) )
	end

	self.infoPanel = vgui.Create( "DInfoPanel", self )
	self.infoPanel:SetSmall( true )
	self.infoPanel:Dock( TOP )
	self.infoPanel:SetInfo( "Materials Location", 
[[To add a material to the selector, put it into this folder: 
addons/ps2_passives/materials/boosters
Don't forget to upload the material to your fastdl, too!]] )
	self.infoPanel:DockMargin( 5, 5, 5, 5 )
	
	local cont = self:addFormItem( "Material", self.selectMatElem )
	cont:SetTall( 64 )
	
	
	
	timer.Simple( 0, function( )
		self:Center( )
	end )
end

function PANEL:SaveItem( saveTable )
	saveTable.material = self.manualEntry:GetText( )
	saveTable.boostType = self.selectedType
	saveTable.boostParams = self.settingsPanel:GetSettingsTable( )
end

function PANEL:EditItem( persistence, itemClass )
	self.manualEntry:SetText( persistence.material )
	self.materialPanel:SetMaterial( persistence.material )
	
	for id, data in pairs( self.typeElem.Data ) do
		if data.Name == persistence.boostType then
			self.typeElem:ChooseOptionID( id )
		end
	end
	
	self.settingsPanel:Initialize( Pointshop2.GetBoosterByName( persistence.boostType ).Settings )
	self.settingsPanel:SetSettings( persistence.boostParams )
end

function PANEL:Validate( saveTable )
	return true
end

vgui.Register( "DItemCreator_BoosterStage", PANEL, "DItemCreator_Stage" )