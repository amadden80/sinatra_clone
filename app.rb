# Q: What is a Web Application?
# A: A Web Site With procedurally generated content.

require 'rack'
require 'erb'
require 'pry'

class View

  def initialize(opts)
    file_path = path(opts[:view])
    @template = ERB.new(File.open(file_path).read)
  end

  def render(binding)
    rendered_html = @template.result(binding)
    # places results of rendered template in
    layout { rendered_html }
  end

  private

  def path(file_name)
    "views/#{file_name}.html.erb"
  end

  def layout
    ERB.new(File.open('views/layout.html.erb').read).result(binding{ yield })
  end

end


class Application

  BEATLES = ["john", "paul", "george", "ringo", "yoko"]
  STONES  = ['mick', 'keith', 'ronnie', 'charlie']

  def call(env)
    case path = env["PATH_INFO"]
    when /beatles/
      @beatles = BEATLES
      [200, {"Content-Type" => "text/html"}, [View.new({view: 'beatles'}).render(binding)]]
    when /stones/
      @stones = STONES
      [200, {"Content-Type" => "text/html"}, [View.new({view: 'stones'}).render(binding)]]
    else
      [404, {"Content-Type" => "text/html"}, ["<h1>404: NOT FOUND</h1>"]]
    end
  end
end

thin = Rack::Handler::Thin
thin.run Application.new

