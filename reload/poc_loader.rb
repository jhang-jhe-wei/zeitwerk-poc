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

  def reload
    autoload_paths.each do |dir|
      Dir.glob("#{dir}/**/*.rb").each do |file|
        abs_file = File.expand_path(file)
        $LOADED_FEATURES.delete(abs_file)
      end
    end
    setup
  end
end
