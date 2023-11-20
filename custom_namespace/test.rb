require_relative 'poc_loader'
require 'byebug'
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

