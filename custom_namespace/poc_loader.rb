require_relative './monkey_patches'

class PocLoader
  attr_reader :autoload_paths, :root_namespace

  def initialize
    @autoload_paths = []
  end

  # autoloadPaths store hash arry
  # every element is a hash with key: dir, namespace
  def push_dir(dir, root_namespace: Object)
    autoload_paths << { dir: dir, root_namespace: root_namespace }
  end

  def reload
    unload
    setup
  end

  def setup
    autoload_paths.each do |dir:, root_namespace:|
      list_files(dir) do |abs_path, relat_path|
        cname = relat_path.remove_rb_extension.camelize
        root_namespace.autoload cname, abs_path
      end
    end
  end

  private

  def unload
    autoload_paths.each do |dir:, root_namespace:|
      list_files(dir) do |abs_path, relat_path|
        cname = relat_path.remove_rb_extension.camelize
        $LOADED_FEATURES.delete(abs_path)
      end

      remove_shallow_level_constants(dir, root_namespace)
    end
  end

  def remove_shallow_level_constants(dir, namespace)
    Dir.glob("#{dir}/*").each do |relat_path|
      base_path = relat_path.gsub(/#{dir}\//, '')
      cname = base_path.remove_rb_extension.camelize
      namespace.send(:remove_const, cname)
    end
  end
 
  def list_files(directory)
    Dir.glob(File.join(directory, '**', '*.rb')).each do |file|
      abs_path = File.absolute_path(file)
      relat_path = file.gsub(/#{directory}\//, '')
      yield(abs_path, relat_path) if block_given?
    end
  end
end
