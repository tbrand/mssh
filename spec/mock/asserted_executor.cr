class AssertedExecutor < Mssh::Executor

  alias Command = NamedTuple(
          host:     String,
          port:     Int32,
          username: String,
          pubkey:   String,
          commands: Array(String),
          log_dir:  String,
        )

  getter commands : Array(Command) = [] of Command

  def command(host, port, username, pubkey, commands, log_dir)
    @commands << {
      host:     host,
      port:     port,
      username: username,
      pubkey:   pubkey,
      commands: commands,
      log_dir:  log_dir,
    }
  end
end
