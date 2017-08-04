require 'sinatra'
require 'CSV'
require 'uri'
require 'pry'

set :bind, '0.0.0.0'

before do
  @csv = CSV.read('articles.csv', skip_blanks:true, headers:true)
end

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

  csvArr = CSV.read('articles.csv')
  csvArr.each do |row|
    if row.include?(@url)
      @dupError = true
    end
  end

  uri = URI.parse(@url)

  if uri.scheme != "http" && uri.scheme != "https"
    @errorURL = true
    erb :new
  elsif @description.length < 20
    @errorDesciptLen = true
    erb :new
  elsif @dupError == true
    erb :new
  elsif @title != '' && @url != '' && @description != ''
    CSV.open('articles.csv', 'a') do |csv|
      csv << ["#{@title}", "#{@url}", "#{@description}"]
    end
    redirect '/articles'
  else
    @error = true
    erb :new
  end
end
