require 'erb'

class ShowExceptions
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      app.call(env)
    rescue => e
      render_exception(e)
    end
  end

  private

  def render_exception(e)
    dir_path = File.dirname(__FILE__)
    template_file = File.read("#{dir_path}/templates/rescue.html.erb")
    template = ERB.new(template_file)

    body = template.result(binding)

    ['500', { 'Content-type' => 'text/html' }, body]
  end

end
