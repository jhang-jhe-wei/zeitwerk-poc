chroot = File.expand_path(File.dirname(__FILE__))
Dir.chdir(chroot)

require_relative 'poc_loader'

loader = PocLoader.new
loader.push_dir("lib")
loader.enable_reloading
loader.setup

while true
  loader.reload
  Car::Wheel.hi
  A.hi
  sleep 1
end
