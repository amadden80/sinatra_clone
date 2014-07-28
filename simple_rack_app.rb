require 'rack'

thin = Rack::Handler::Thin
app  = lambda { |env| [200, {"Content-Type" => "text/plain"}, ["Hello WDI. The time is #{Time.now}"]] }

thin.run app
