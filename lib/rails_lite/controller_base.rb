require 'erb'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params = "")
    @res = res
    @req = req
    @params = Params.new(req, route_params = "")
    #@route = route
  end

  def session
    @session ||= Session.new(@req)
  end

  def already_rendered?
    !!@already_rendered
  end

  def redirect_to(url)
    unless @response_built
      @res.set_redirect(WEBrick::HTTPStatus::TemporaryRedirect, url)
      @response_built = true
      session.store_session(@res)
    end
  end

  def render_content(content, type)
    unless @already_rendered
      @already_rendered = true 
      @res.content_type = type
      @res.body = content
      session.store_session(@res)
    end
  end

  def render(action_name)
    file = File.read("views/#{self.class.name.underscore}/#{action_name}.html.erb")
    template = ERB.new(file)
    bound = template.result(binding)
    erb_content = bound
    render_content(erb_content,"text/html")
  end

  def invoke_action(name)
    send(name)
    if @already_rendered
      render
  end
end
