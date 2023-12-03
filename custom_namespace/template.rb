require 'zeitwerk'

loader = Zeitwerk::Loader.new
VERSION = "v2"
module Car ;end
loader.push_dir("lib/car/parts/#{VERSION}", namespace: Car)
loader.enable_reloading
loader.setup

while true
  Car::Wheel.hi
  sleep 1
end
