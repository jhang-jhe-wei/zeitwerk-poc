require 'zeitwerk'

loader = Zeitwerk::Loader.new
loader.push_dir("lib")
loader.setup

A.hi
