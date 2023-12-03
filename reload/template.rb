require 'zeitwerk'

loader = Zeitwerk::Loader.new
loader.push_dir("lib")
loader.enable_reloading
loader.setup

while true
  loader.reload
  A.hi
  sleep 1
end
