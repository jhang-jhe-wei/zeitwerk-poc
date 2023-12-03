chroot = File.expand_path(File.dirname(__FILE__))
Dir.chdir(chroot)

require_relative 'poc_loader'

loader = PocLoader.new
loader.push_dir("lib")
loader.setup

while true
  loader.reload
  Car::Wheel.hi
  Ship::Keel.hi
  sleep 1
end
