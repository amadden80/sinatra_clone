class View

  def initialize(opts)
    file_path = path(opts[:view])
    @template = ERB.new(File.open(file_path).read)
  end

  def render(binding)
    process_instance_variables(binding)
    rendered_html = @template.result(binding)
    layout{ rendered_html }
  end

  private

  def path(file_name)
    "views/#{file_name}.html.erb"
  end

  def layout
    ERB.new(File.open('views/layout.html.erb').read).result(binding{ yield })
  end

  def process_instance_variables(binding)
    eval("instance_variables", binding).each do |var|
      self.instance_variable_set(var.to_s, eval(var.to_s, binding))
    end
  end

end
