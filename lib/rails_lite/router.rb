class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @action = action_name.to_sym
    @pattern = pattern
    @controller_class = self.class.name
    @http_method = http_method 
  end

  def matches?(req)
    @http_method == req.request_method.downcase.to_sym 
  end

  def run(req, res)

  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    # add these helpers in a loop here
    define_method(http_method) do
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  def match(req)
    @http_method == req.request_method.downcase.to_sym 
  end

  def run(req, res)
  end
end
