module Mssh
  class Executable < Component
    def initialize(
         @host     : String,
         @port     : Int32,
         @username : String,
         @pubkey   : String,
         @commands : Array(String),
         @log_dir  : String,
       )
    end

    def exec
      __executor.command(
        @host,
        @port,
        @username,
        @pubkey,
        @commands,
        @log_dir
      )

    rescue e : Exception
      L.error e.message.not_nil!
    ensure
      Queue.global.handle
    end

    include Mssh
  end
end
