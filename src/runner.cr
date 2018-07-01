require "./mssh"
require "./runner/runner"

runner = Mssh::Runner.new
runner.parse!
runner.run
