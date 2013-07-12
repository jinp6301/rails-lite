require 'webrick'
trap('INT') { server.shutdown }


root = File.expand_path '/'

server = WEBrick::HTTPServer.new :Port => 8080, :DocumentRoot => root

server.mount_proc '/' do |url, proc|
  res.body = HTTPRequest#path
end

class Server
  def do_GET request, response
    status, content_type, body = do_stuff_with request

    response.status = 200
    response['Content-Type'] = 'text/text'
    response.body = HTTPRequest#path
  end
end


class MyController < ControllerBase
  def go
    render_content("hello world!", "text/html")

    # after you have template rendering, uncomment:
#    render :show

    # after you have sessions going, uncomment:
#    session["count"] ||= 0
#    session["count"] += 1
#    render :counting_show
  end
end

server.mount_proc '/' do |req, res|
  MyController.new(req, res).go
end

server.start
