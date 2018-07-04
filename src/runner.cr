require "./mssh"
require "./runner/runner"

Mssh::Defaults.cache

runner = Mssh::Runner.new
runner.parse!
runner.run
