require_relative 'poc_loader'
require 'byebug'

loader = PocLoader.new
loader.push_dir("lib")
loader.enable_reloading
loader.setup

while true
  loader.reload
  A.hi
  sleep 1
end
