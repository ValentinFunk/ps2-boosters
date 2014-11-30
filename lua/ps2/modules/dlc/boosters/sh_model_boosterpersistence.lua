Pointshop2.BoosterPersistence = class( "Pointshop2.BoosterPersistence" )
local BoosterPersistence = Pointshop2.BoosterPersistence 

BoosterPersistence.static.DB = "Pointshop2"

BoosterPersistence.static.model = {
	tableName = "ps2_boosterpersistence",
	fields = {
		itemPersistenceId = "int",
		boostType = "string",
		boostParams = "luadata",
		material = "string", 
	},
	belongsTo = {
		ItemPersistence = {
			class = "Pointshop2.ItemPersistence",
			foreignKey = "itemPersistenceId",
			onDelete = "CASCADE",
		}
	}
}

BoosterPersistence:include( DatabaseModel )
BoosterPersistence:include( Pointshop2.EasyExport )

function BoosterPersistence.static.createOrUpdateFromSaveTable( saveTable, doUpdate )
	return Pointshop2.ItemPersistence.createOrUpdateFromSaveTable( saveTable, doUpdate )
	:Then( function( itemPersistence )
		if doUpdate then
			return BoosterPersistence.findByItemPersistenceId( itemPersistence.id )
		else
			local boosterPersistence = BoosterPersistence:new( )
			boosterPersistence.itemPersistenceId = itemPersistence.id
			return boosterPersistence
		end
	end )
	:Then( function( boosterPersistence )
		boosterPersistence.boostType = saveTable.boostType
		boosterPersistence.boostParams = saveTable.boostParams
		boosterPersistence.material = saveTable.material
		return boosterPersistence:save( )
	end )
end