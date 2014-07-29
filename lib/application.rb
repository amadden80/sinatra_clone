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

  def self.get(path, &block)
    @@router.create_route(:get, path, &block)
  end

  def self.post(path, &block)
    @@router.create_route(:get, path, &block)
  end

end