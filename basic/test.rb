require_relative 'poc_loader'

loader = PocLoader.new
loader.push_dir("lib")
loader.setup

A.hi
