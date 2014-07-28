# Q: What is a Web Application?
# A: A Web Site With procedurally generated content.

require 'rack'
require 'erb'

beatles = ["john", "paul", "george", "ringo", "yoko"]


# thin = Rack::Handler::Thin
# app  = lambda { |env| [200, {"Content-Type" => "text/plain"}, ["Hello WDI. The time is #{Time.now}"]] }
# thin.run app






class View

  def initialize(opts)
    file_path = path(opts[:view])
    @template = ERB.new(File.open(file_path).read)
  end

  def render
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