Rails.application.routes.draw do

  get '/categories', to: 'category#index', as: 'categories'
  get '/categories/:id', to: 'category#show', as: 'categories_show'
  delete '/categories/:id', to: 'category#delete', as: 'categories_delete'
  get '/categories/:id/edit', to: 'category#edit', as: 'categories_edit'
  get '/categories/new', to: 'category#new', as: 'categories_new'

end
