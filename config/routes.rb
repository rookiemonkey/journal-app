Rails.application.routes.draw do

  # HOME
  root                                          to: 'home#home'
  get     '/task/new',                          to: 'home#new_task',        as: 'home_new_task'
  post    '/task/new',                          to: 'home#create_task',     as: 'home_create_task'
  

  # CATEGORIES
  get     '/categories/new',                    to: 'category#new',         as: 'categories_new'
  post    '/categories/new',                    to: 'category#create',      as: 'categories_create'
  delete  '/categories/:id/delete',             to: 'category#delete',      as: 'categories_delete'
  get     '/categories/:id/edit',               to: 'category#edit',        as: 'categories_edit'
  patch   '/categories/:id/edit',               to: 'category#update',      as: 'categories_update'


  # TASKS
  get     '/categories/:id/tasks',              to: 'task#index',           as: 'tasks'
  get     '/categories/:id/tasks/new',          to: 'task#new',             as: 'tasks_new'
  post    '/categories/:id/tasks/new',          to: 'task#create',          as: 'tasks_create'
  get     '/categories/:id/tasks/:tid/edit',    to: 'task#edit',            as: 'tasks_edit'
  patch   '/categories/:id/tasks/:tid/edit',    to: 'task#update',          as: 'tasks_update'
  delete  '/categories/:id/tasks/:tid/delete',  to: 'task#delete',          as: 'tasks_delete'

end
