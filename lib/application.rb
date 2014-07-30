require 'rack'
require 'erb'

require_relative 'view'
require_relative 'router'

class Application

  @@router = Router.new

  def call(env)
    req = Rack::Request.new(env)
    @@router.route(req)
  end

  def self.render(view)
    [200, {"Content-Type" => "text/html"}, [View.new({view: view.to_s}).render(binding)]]
  end

  def self.get(path, &block)
    @@router.create_route(:get, path, &block)
  end

  def self.post(path, &block)
    @@router.create_route(:post, path, &block)
  end


end