local ChanceBooster = {}

ChanceBooster.Name = "TTT: Role Chance"

--Same format as for module settings
ChanceBooster.Settings = {
	BasicSettings = {
		info = {
			label = "Role Chance Settings",
		},
		Duration = {
			label = "Duration in seconds",
			tooltip = "Duration after which the booster item expires. Use 0 for unlimited.",
			value = 3600
		},
		ChanceIncrease = {
			label = "Chance increase in percent",
			tooltip = "The increase of the chance of being picked for the role in percent. 100% means double chance.",
			value = 50
		},
		Role = {
			label = "Role to boost chance for",
			tooltip = "The role that the chance should be increased for",
			value = "Traitor", 
			possibleValues = {
				"Traitor",
				"Detective",
			},
			type = "option",
		}
	}
}

ChanceBooster.ShouldDrainTime = function( )
	return true
end

Pointshop2.AddBoosterType( ChanceBooster )