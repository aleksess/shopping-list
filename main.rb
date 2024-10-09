require 'bundler/setup'

require 'sinatra'
require_relative 'models/shopping-list'

get '/' do erb :index end

get '/:id' do
  shopping_list = ShoppingList.find(params[:id])

  erb :list, layout: !(request.env['HX-Request'] && !request.env['HX-Boosted']), locals: { list: shopping_list }
rescue ActiveRecord::RecordNotFound
  404
end

post '/lists' do
  list = ShoppingList.new params

  if list.save
    redirect to("/#{list.id}")
  else
    400
  end
end
get '/lists/:id/entries' do
  shopping_list = ShoppingList.find(params[:id])


  erb :entries, layout: false, locals: { entries: shopping_list.shopping_list_entries, listId: shopping_list.id }
rescue ActiveRecord::RecordNotFound
  404
end


post '/lists/:id/entries' do
  shopping_list = ShoppingList.find(params[:id])

  entry = shopping_list.shopping_list_entries.new params[:entry]

  if entry.save
    erb :entry, layout: false, locals: { entry: entry }
  else
    400
  end
rescue ActiveRecord::RecordNotFound
  404
end

patch '/lists/:listId/entries/:id' do
  shopping_list = ShoppingList.find(params[:listId])

  entry = shopping_list.shopping_list_entries.find params[:id]

  entry.done = !entry.done

  entry.save

  erb :entry, layout: false, locals: { entry: entry }
rescue ActiveRecord::RecordNotFound
  404
end

delete '/lists/:listId/entries/:id' do
  shopping_list = ShoppingList.find(params[:listId])

  entry = shopping_list.shopping_list_entries.destroy params[:id]

  200
rescue ActiveRecord::RecordNotFound
  404
end
