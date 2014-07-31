require_relative "lib/application"
require 'pry'

class HelloWorld < Application
  get '/' do
    @content = "Sup, Coredogg?"
    render :hello
  end
end

thin = Rack::Handler::Thin
thin.run HelloWorld.new








