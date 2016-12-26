class Static
  attr_reader :app, :root, :file_server
  def initialize(app)
    @app = app
    @root = :public
    @file_server = FileServer.new(@root)
  end

  def call(env)
    req = Rack::Request.new(env)
    path = req.path

    res = path.index("/#{root}") ? @file_server.call(env) : @app.call(env)
    res
  end
end

class FileServer
  MIMES = {
    '.txt' => 'text/plain',
    '.jpg' => 'image/jpeg',
    '.zip' => 'application/zip'
  }.freeze

  def initialize(root)
    @root = root
  end

  def call(env)
    res = Rack::Response.new
    req = Rack::Request.new(env)

    path = req.path
    dir_name = File.dirname(__FILE__)
    file_name = File.join(dir_name, "..", path)


    if File.exist?(file_name)
      extension = File.extname(file_name)
      content_type = MIMES[extension]
      file = File.read(file_name)
      res["Content-type"] = content_type
      res.write(file)
    else
      res.status = 404
      res.write("File not found")
    end
    res
  end
end
