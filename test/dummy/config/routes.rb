Rails.application.routes.draw do
  mount BrDb::Engine => "/br_db"
end
