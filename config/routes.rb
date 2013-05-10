Valeur::Application.routes.draw do
  
  resources :projets do
    resources :etudes
  end

  # map '/' to be a redirect to '/projets'

match "/" => redirect("/projets")
match '/aide_projets', :to => redirect('/aide_projets.html')

end
