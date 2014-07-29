require_relative "lib/application"
require 'pry'

class HelloWorld < Application
  get '/' do
    @title   = "Sorry miss jackson..."
    @content = "I am for real."
    [200, {"Content-Type" => "text/html"}, [View.new({view: 'index'}).render(binding)]]
  end
end

thin = Rack::Handler::Thin
thin.run HelloWorld.new








