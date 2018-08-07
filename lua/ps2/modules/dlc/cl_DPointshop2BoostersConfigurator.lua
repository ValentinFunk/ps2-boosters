local PANEL = {}

function PANEL:Init( )
	self:SetSkin( Pointshop2.Config.DermaSkin )
	self:SetTitle( "Pointshop2 Boosters Settings" )
	self:SetSize( 300, 600 )
	
	self:AutoAddSettingsTable( { BoosterSettings = Pointshop2.GetModule( "Pointshop 2 DLC" ).Settings.Shared.BoosterSettings }, self )
end

function PANEL:DoSave( )
	Pointshop2View:getInstance( ):saveSettings( self.mod, "Shared", self.settings )
end

derma.DefineControl( "DPointshop2BoostersConfigurator", "", PANEL, "DSettingsEditor" )
