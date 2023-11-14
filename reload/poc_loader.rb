# monkey patch String
class String
  def constantize
    Object.const_get(self)
  end

  def camelize(uppercase_first_letter = true)
    string = self
    if uppercase_first_letter
      string = string.sub(/^[a-z\d]*/) { |match| match.capitalize }
    else
      string = string.sub(/^(?:(?=\b|[A-Z_])|\w)/) { |match| match.downcase }
    end
    string.gsub(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{$2.capitalize}" }.gsub("/", "::")
  end
end

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
      rbfiles = File.join("**", "*.rb")
      Dir.glob(rbfiles, base: 'lib').each do |f|
        file = File.basename(f, ".*")
        Object.send(:remove_const, file.camelize)
      end
    end
    setup
  end

  def setup
    autoload_paths.each do |dir|
      Dir.glob("#{dir}/**/*.rb").each do |file|
        byebug
        require_relative file
      end
    end
  end
end
