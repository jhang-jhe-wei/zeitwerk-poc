require_relative 'poc_loader'
require 'byebug'
VERSION = "v1"
module Car ;end

loader = PocLoader.new
loader.push_dir("lib/car/parts/#{VERSION}", namespace: Car)
loader.enable_reloading
loader.setup

while true
  Car::Wheel.hi
  sleep 1
end

