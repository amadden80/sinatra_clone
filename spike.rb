require 'sinatra'
require 'pry'
class MyApp < Sinatra::Base

  binding.pry
  get '/' do
  end
end