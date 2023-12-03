require_relative './monkey_patches'
require 'byebug'
require 'set'

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
        namespace = define_namespace(cname, root_namespace)
        cname_without_namespace = cname.split('::').last
        namespace.autoload cname_without_namespace, abs_path
      end
    end
  end

  private

  def define_namespace(cname, root_namespace)
    namespaces = cname.split('::')
    # remove last element
    namespaces.pop
    namespaces.each do |namespace|
      unless root_namespace.const_defined?(namespace)
        root_namespace.const_set(namespace, Module.new)
      end
      root_namespace = root_namespace.const_get(namespace)
    end
    root_namespace
  end

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
    set = Set.new
    Dir.glob("#{dir}/*").each do |relat_path|
      base_path = relat_path.gsub(/#{dir}\//, '')
      cname = base_path.remove_rb_extension.camelize
      set << cname.split('::').first
    end
    set.each do |cname|
      namespace.send(:remove_const, cname)
    end
  end
 
  def list_files(directory)
    children_files = Dir.glob(File.join(directory, '**', '*.rb'))
    children_files.sort!
    byebug
    children_files.each do |file|
      abs_path = File.absolute_path(file)
      relat_path = file.gsub(/#{directory}\//, '')
      yield(abs_path, relat_path) if block_given?
    end
  end
end
