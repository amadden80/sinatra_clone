class View
  def initialize(opts)
    file_path = path(opts[:view])
    @template = ERB.new(File.open(file_path).read)
  end

  def render(binding)
    rendered_html = @template.result(binding)
    layout { rendered_html }
  end

  private

  def path(file_name)
    File.absolute_path("views/#{file_name}.html.erb")
  end

  def layout
    ERB.new(File.open('views/layout.html.erb').read).result(binding{ yield })
  end

end
