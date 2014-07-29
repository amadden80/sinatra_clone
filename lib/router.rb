class Router
  attr_reader :routes

  def initialize(routes = {get: {}, post: {}})
    @routes = routes
  end

  def create_route(method, path, &block)
    @routes[method.to_sym][path] = block
  end

  def route(req)
    method, path = req.request_method.downcase.to_sym, req.path_info
    @routes[method][path].call(req)
  end

end


