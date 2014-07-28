# Q: What is a Web Application?
# A: A Web Site With procedurally generated content.

# Q: How can I interact with application through brower
# A: HTTP

# Q: What is HTTP?
# A: (INSERT GOOD ANSWER)

# Q: (INSERT GOOD QUESTION)
# A: (ABSTRACT VIEW CLASS)

# Q: DO WE NEED TWO VIEWS FOR BEATLES AND STONES?
# A: NO


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
      @band = BEATLES
      @name = "The Beatles"
      [200, {"Content-Type" => "text/html"}, [View.new({view: 'band'}).render(binding)]]
    when /stones/
      @band = STONES
      @name = "The Rolling Stones"
      [200, {"Content-Type" => "text/html"}, [View.new({view: 'band'}).render(binding)]]
    else
      [404, {"Content-Type" => "text/html"}, ["<h1>404: NOT FOUND</h1>"]]
    end
  end
end

thin = Rack::Handler::Thin
thin.run Application.new

