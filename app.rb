# Q: What should a router do?
# A: It should provide a means of specifying routes and matching them to controller actions

# Q: What is the view still doing in app.rb?
# A: It should not be there, let's move it lib.

# Q: This feels very close to the metal.  How can we abstract away from rack
# A: Applications should inherit from application class.

require 'rack'
require 'erb'
require 'pry'

require_relative 'lib/view'


class Router
  attr_reader :routes

  def initialize(routes = {get: {}, post: {}})
    @routes   = routes
  end

  def create_route(method, path, &block)
    @routes[method.to_sym][path] = block
  end

  def route(req)
    method, path = req.request_method.downcase.to_sym, req.path_info
    @routes[method][path].call(req)
  end

end

class Application

  BEATLES = ["john", "paul", "george", "ringo", "yoko"]
  STONES  = ['mick', 'keith', 'ronnie', 'charlie']


  def initialize
    @router = Router.new

    # we have to pass the request into the block
    @router.create_route('get', '/beatles') do |req|
      @band = BEATLES
      @name = "beatles"
      [200, {"Content-Type" => "text/html"}, [View.new({view: 'band'}).render(binding)]]
    end

    @router.create_route('post', '/beatles') do |req|
      @band = BEATLES
      @name = "beatles"
      BEATLES.push(req.params['member']) if req.params['member']
      [200, {"Content-Type" => "text/html"}, [View.new({view: 'band'}).render(binding)]]
    end
  end

  def call(env)
    req = Rack::Request.new(env)
    @router.route(req)
  end
end

thin = Rack::Handler::Thin
thin.run Application.new

