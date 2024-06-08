return {
	"tpope/vim-projectionist",
	dependencies = {
		"tpope/vim-dispatch",
	},
	config = function()
		vim.g.projectionist_heuristics = {
			artisan = {
				["*"] = {
					start = "php artisan serve",
					console = "php artisan tinker",
				},
				["app/*.php"] = {
					type = "source",
					alternate = {
						"tests/Unit/{}Test.php",
						"tests/Feature/{}Test.php",
					},
				},
				["tests/Feature/*Test.php"] = {
					type = "test",
					alternate = "app/{}.php",
				},
				["tests/Unit/*Test.php"] = {
					type = "test",
					alternate = "app/{}.php",
				},
				["app/Providers/*.php"] = {
					type = "provider",
				},
				["app/Filament/*.php"] = {
					type = "filament",
				},
				["app/Livewire/*.php"] = {
					type = "livewire",
				},
				["app/View/Components/*.php"] = {
					type = "component",
				},
				["app/Models/*.php"] = {
					type = "model",
				},
				["app/Http/Controllers/*.php"] = {
					type = "controller",
				},
				["routes/*.php"] = {
					type = "route",
				},
				["database/migrations/*.php"] = {
					type = "migration",
				},
				["resources/views/*.blade.php"] = {
					type = "views",
				},
			},
		}
	end,
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
