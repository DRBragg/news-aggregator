require 'sinatra'
require 'CSV'

set :bind, '0.0.0.0'

get '/' do
  redirect '/articles'
end

get '/articles' do
  erb :articles
end

get '/articles/new' do
  erb :new
end

post '/articles/new' do
  @title = params[:articleTitle]
  @url = params[:articleURL]
  @description = params[:articleDescription]

  CSV.open('articles.csv', 'a') do |csv|
    csv << ["#{@title}", "#{@url}", "#{@description}"]
  end

  erb :new
  redirect '/articles/new'
end
