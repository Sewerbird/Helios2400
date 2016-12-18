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
			army_description = "House Militia",
			base_cash_cost = 5,
			base_build_point_cost = 10,
			max_hp = 100,
			assault_rating = {
				ewar = 0,
				indirect = 0,
				direct = 2,
				close = 5
			},
			defense_rating = {
				ewar = 0,
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
			army_description = "'Axion' Bombard Cannon",
			base_cash_cost = 15,
			base_build_point_cost = 20,
			max_hp = 30,
			assault_rating = {
				ewar = 0,
				indirect = 5,
				direct = 2,
				close = 0
			},
			defense_rating = {
				ewar = 0,
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
			army_description = "'Mad Dog' Mechwalkers",
			base_cash_cost = 20,
			base_build_point_cost = 100,
			max_hp = 50,
			assault_rating = {
				ewar = 0,
				indirect = 0,
				direct = 5,
				close = 2
			},
			defense_rating = {
				ewar = 2,
				indirect = 2,
				direct = 2,
				close = 2
			}
		},
		{
			specId = "SPEC_UNIT_SPY_1",
			specType = "UnitData",
			icon_sprite = "UNIT_SPY_1",
			movement_types = { "LAND" },
			max_move = 9,
			army_type = "walker",
			army_description = "'Coderbunker' Hackers",
			base_cash_cost = 20,
			base_build_point_cost = 50,
			max_hp = 50,
			assault_rating = {
				ewar = 5,
				indirect = 0,
				direct = 0,
				close = 0
			},
			defense_rating = {
				ewar = 3,
				indirect = 0,
				direct = 0,
				close = 0
			}
		}

	}
}