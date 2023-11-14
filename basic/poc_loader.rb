class PocLoader
  attr_reader :autoload_paths

  def initialize
    @autoload_paths = []
  end

  def push_dir(dir)
    @autoload_paths << dir
  end

  def setup
    autoload_paths.each do |dir|
      Dir.glob("#{dir}/**/*.rb").each do |file|
        require_relative file
      end
    end
  end
end
