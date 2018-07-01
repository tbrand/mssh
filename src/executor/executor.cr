module Mssh
  abstract class Executor
    abstract def command(
                  host     : String,
                  port     : Int32,
                  username : String,
                  pubkey   : String,
                  commands : Array(String),
                  log_dir  : String,
                )
  end
end
