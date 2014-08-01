require 'rack'
require 'erb'
require 'pry'

require_relative 'view'
require_relative 'router'
require_relative 'passive_record'


root = File.expand_path('../../', __FILE__)

Dir["#{root}/models/*.rb"].each {|file| require file } # require all models


class Application

  @@router = Router.new

  def call(env)
    req = Rack::Request.new(env)
    @@router.process(req)
  end

  def self.get(path, &block)
    @@router.create_route(:get, path, &block)
  end

  def self.post(path, &block)
    @@router.create_route(:post, path, &block)
  end

  def self.delete(path, &block)
    @@router.create_route(:delete, path, &block)
  end

end