chroot = File.expand_path(File.dirname(__FILE__))
Dir.chdir(chroot)

require_relative 'poc_loader'
VERSION = "v2"
module Car ;end

loader = PocLoader.new
loader.push_dir("lib/car/parts/#{VERSION}", namespace: Car)
loader.enable_reloading
loader.setup

while true
  loader.reload
  Car::Wheel.hi
  sleep 1
end

