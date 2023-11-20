require_relative './monkey_patches'

class PocLoader
  attr_reader :autoload_paths, :root_namespace

  def initialize
    @autoload_paths = []
  end

  def push_dir(dir, namespace: Object)
    @autoload_paths << dir
    @root_namespace = namespace
  end

  # don't need to implement this now
  def enable_reloading; end

  def reload
    autoload_paths.each do |dir|
      list_files(dir) do |abs_path, relat_path|
        cname = relat_path.remove_rb_extension.camelize
        $LOADED_FEATURES.delete(abs_path)
      end

      remove_top_level_constants(dir)
    end
    setup
  end

  def setup
    autoload_paths.each do |dir|
      list_files(dir) do |abs_path, relat_path|
        unlazy_load_for_implicit_problem!(relat_path)
        
        base_name = File.basename(relat_path)
        namespace_name = File.dirname(relat_path).camelize
        namespace_name = root_namespace.to_s if namespace_name == '.'
        namespace = namespace_name.constantize

        cname = base_name.remove_rb_extension.camelize
        namespace.autoload cname, abs_path
      end
    end
  end

  private

  def remove_top_level_constants(dir)
    Dir.glob("#{dir}/**").each do |ns|
      namespace_name = ns.gsub(/#{dir}\//, '')
      Object.send(:remove_const, namespace_name.camelize.remove_rb_extension)
    end
  end

  # for implicit problem
  def unlazy_load_for_implicit_problem!(relat_path)
    namespaces = relat_path.split('/')[0..-2]
    namespaces.each do |ns|
      pre_namespace ||= root_namespace
      cname = ns.camelize

      if pre_namespace.const_defined? cname
        pre_namespace = pre_namespace.const_get cname
      else
        pre_namespace = pre_namespace.const_set cname, Module.new
      end
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
