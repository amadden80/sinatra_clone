class Router
  attr_reader :routes

  def initialize(routes = {get: {}, post: {}, delete: {}})
    @routes = routes
  end

  def create_route(method, path, &block)
    parser = PathParser.new(path)
    route  = Route.new(block, parser)
    @routes[method.to_sym][parser.path] = route
  end

  def process(req)
    method, path = request_method(req), req.path_info
    route = find_route(method, path)
    request_handler = RequestHandler.new(req, route)
    begin
      request_handler.respond
    rescue
      request_handler.not_found
    end
  end

  private

  def request_method(req)
    (req.params["_method"] || req.request_method.downcase).to_sym
  end

  def find_route(method, path)
    method_routes = @routes[method]
    route_key = method_routes.keys.select{ |reg| path.match(reg) }[0]
    method_routes[route_key]
  end

end

class Route
  attr_reader :block, :parser
  def initialize(block, parser)
    @block = block
    @parser = parser
  end
end

class RequestHandler
  def initialize(req, route)
    @block = route.block
    parser = route.parser
    url_params = parser.process_path(req.path_info)
    body_params = req.params
    @params = url_params.merge(body_params)
  end

  def params
    @params.each_with_object({}){|(k,v), hash| hash[k.to_sym] = v} #symbolize keys.
  end

  def respond
    instance_eval &@block
  end

  def render(view)
    [200, {"Content-Type" => "text/html"}, [View.new({view: view.to_s}).render(binding)]]
  end

  def not_found
    [404, {"Content-Type" => "text/html"}, ["<h1>404: Not Found</h1>"]]
  end

  def redirect(uri)
    [302, {'Content-Type' => 'text','Location' => uri}, ['302 found'] ]
  end

  private

end

class PathParser
  def initialize(route_string)
    @keys     = route_string.scan(/:(\w+)/).flatten.map(&:to_sym)
    @regex    = Regexp.new(route_string.gsub(/:\w+/, "(.+)"))
  end

  def process_path(path)
    values = @regex.match(path).captures
    @hash = Hash[@keys.zip(values)]
  end

  def path
    @regex
  end
end























