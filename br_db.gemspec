require_relative "lib/br_db/version"

Gem::Specification.new do |spec|
  spec.name        = "br_db"
  spec.version     = BrDb::VERSION
  spec.authors     = [ "Ulisses Caon" ]
  spec.email       = [ "ulissescaon@gmail.com" ]
  spec.homepage    = "https://github.com/caonUlisses/br_db"
  spec.summary     = "A Rails engine to download and load Brazilian data"
  spec.description = "Download and import Brazilian data into your Ruby on Rails app"
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/caonUlisses/br_db"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.0.1"
  spec.add_dependency "down", "~> 5.0"
  spec.add_dependency "httparty"
end
