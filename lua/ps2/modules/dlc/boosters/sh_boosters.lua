Pointshop2.BoosterTypes = {}

function Pointshop2.AddBoosterType( tbl )
	Pointshop2.BoosterTypes[tbl.Name] = tbl
end

function Pointshop2.GetBoosterByName( name )
	return Pointshop2.BoosterTypes[name]
end