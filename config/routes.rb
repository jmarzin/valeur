Valeur::Application.routes.draw do
  
  resources :strategies, only: [:show, :edit, :update]

  resources :rentabilites, only: [:show]

  resources :directs, only: [:show, :edit, :update]

  resources :indirects, only: [:show, :edit, :update]

  resources :fonctions, only: [:show, :edit, :update]

  resources :gains, only: [:show, :edit, :update]

  resources :detail, only: [:show]

  resources :parametrages


  resources :projets do
    resources :etudes
  end

  # map '/' to be a redirect to '/projets'

match "/" => redirect("/projets")
match '/aide_projets', :to => redirect('/aide_projets.html')

end
