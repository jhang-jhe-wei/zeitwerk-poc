require_relative './monkey_patches'

class PocLoader
  attr_reader :autoload_paths

  def initialize
    @autoload_paths = []
  end

  def push_dir(dir)
    @autoload_paths << dir
  end

  # don't need to implement this now
  def enable_reloading; end

  # Dir.glob("lib/**/*.rb", base: 'lib')
  def reload
    autoload_paths.each do |dir|
      list_files(dir) do |abs_path, relat_path|
        cname = relat_path.remove_rb_extension.camelize
        $LOADED_FEATURES.delete(abs_path)
        Object.send(:remove_const, cname)
      end
    end
    setup
  end

  def setup
    autoload_paths.each do |dir|
      list_files(dir) do |abs_path, relat_path|
        cname = relat_path.remove_rb_extension.camelize
        Object.autoload cname, abs_path
      end
    end
  end

  private

  def list_files(directory)
    Dir.glob(File.join(directory, '**', '*.rb')).each do |file|
      abs_path = File.absolute_path(file)
      relat_path = file.gsub(/#{directory}\//, '')
      yield(abs_path, relat_path) if block_given?
    end
  end
end
