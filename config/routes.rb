Brdb::Engine.routes.draw do
  get "import_cities", to: "import_cities#create"
  get "import_states", to: "import_states#create"
  get "import_countries", to: "import_countries#create"
  get "import_zip_codes", to: "import_zip_codes#create"
end
