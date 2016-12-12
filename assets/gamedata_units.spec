{
	assetId = "DEBUG_UNIT_SPEC",
	assetType = "gameData",
	data = {
		{
			specId = "SPEC_UNIT_INFANTRY_1",
			specType = "UnitData",
			icon_sprite = "UNIT_INFANTRY_1",
			movement_types = { "LAND" },
			max_move = 4,
			army_type = "regular",
			max_hp = 100,
			assault_rating = {
				indirect = 0,
				direct = 2,
				close = 5
			},
			defense_rating = {
				indirect = 2,
				direct = 2,
				close = 2
			}
		},
		{
			specId = "SPEC_UNIT_ARTILLERY_1",
			specType = "UnitData",
			icon_sprite = "UNIT_ARTILLERY_1",
			movement_types = { "LAND" },
			max_move = 6,
			army_type = "artillery",
			max_hp = 30,
			assault_rating = {
				indirect = 5,
				direct = 2,
				close = 0
			},
			defense_rating = {
				indirect = 2,
				direct = 2,
				close = 2
			}
		},
		{
			specId = "SPEC_UNIT_MECH_1",
			specType = "UnitData",
			icon_sprite = "UNIT_MECH_1",
			movement_types = { "LAND" },
			max_move = 9,
			army_type = "walker",
			max_hp = 50,
			assault_rating = {
				indirect = 0,
				direct = 5,
				close = 2
			},
			defense_rating = {
				indirect = 2,
				direct = 2,
				close = 2
			}
		}

	}
}