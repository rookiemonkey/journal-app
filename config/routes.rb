Rails.application.routes.draw do

  get '/categories',                to: 'category#index',   as: 'categories'
  get '/categories/new',            to: 'category#new',     as: 'categories_new'
  post '/categories/new',           to: 'category#create',  as: 'categories_create'
  get '/categories/:id',            to: 'category#show',    as: 'categories_show'
  delete '/categories/:id/delete',  to: 'category#delete',  as: 'categories_delete'
  get '/categories/:id/edit',       to: 'category#edit',    as: 'categories_edit'

end
