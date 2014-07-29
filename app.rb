# Q: What should a router do?
# A: It should provide a means of specifying routes and matching them to controller actions

# Q: What is the view still doing in app.rb?
# A: It should not be there, let's move it lib.

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
    binding.pry
    @routes[method][path].call
  end
end



class Application

  BEATLES = ["john", "paul", "george", "ringo", "yoko"]
  STONES  = ['mick', 'keith', 'ronnie', 'charlie']

  def initialize
    @router = Router.new
    @router.create_route('get', '/beatles') do
      @band = BEATLES
      @name = "beatles"
      [200, {"Content-Type" => "text/html"}, [View.new({view: 'band'}).render(binding)]]
    end
  end

  def call(env)
    # case path = env["PATH_INFO"]
    # As we start to develop more complex behaviors on the server,
    # it is advantageous for us to create a new Rack::Request object
    req = Rack::Request.new(env)
    @router.route(req)
  end
    # case req.path_info
    # when /beatles/
    #   @band = BEATLES
    #   @name = "beatles"
    #   if req.request_method == 'GET'
    #     [200, {"Content-Type" => "text/html"}, [View.new({view: 'band'}).render(binding)]]
    #   elsif req.request_method == 'POST'
    #     member = req.params['member']
    #     BEATLES.pus2h(member) if req.params['member']
    #     [200, {"Content-Type" => "text/html"}, [View.new({view: 'band'}).render(binding)]]
    #   end
    # when /stones/
    #   @band = STONES
    #   @name = "stones"
    #   if req.request_method == 'GET'
    #     [200, {"Content-Type" => "text/html"}, [View.new({view: 'band'}).render(binding)]]
    #   elsif
    #     member = req.params['member']
    #     BEATLES.push(member) if req.params['member']
    #     [200, {"Content-Type" => "text/html"}, [View.new({view: 'band'}).render(binding)]]
    #   end
    # else
    #   binding.pry
    #   [404, {"Content-Type" => "text/html"}, ["<h1>404: NOT FOUND</h1>"]]
    # end
  # end
end

thin = Rack::Handler::Thin
thin.run Application.new

