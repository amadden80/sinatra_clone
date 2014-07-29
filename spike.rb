require 'pry'

class Router
  attr_reader :routes

  def initialize(routes = {get: {}, post: {}})
    @routes   = routes
  end

  def create_route(method, path, &block)
    @routes[method.to_sym][path] = block
  end

  def handle_route(req)
    method, path = req.request_method, req.path_info

  end
end

router = Router.new
router.create_route('get', '/beatles') do
  puts "all the beatles"
end

binding.pry