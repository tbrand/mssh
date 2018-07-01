module Mssh
  class ExecutorDefault < Executor
    BUFFER_SIZE = 1024

    def read_stdout(channel : SSH2::Channel, buffer_slice : Slice(UInt8), log_file : File) : Bool
      has_stdout = false

      while (len = channel.read(buffer_slice).to_i32) > 0
        string = String.new buffer_slice[0, len]

        log_file.print t_stdout_no_c(string)
        log_file.flush

        STDOUT.print t_stdout(string)

        has_stdout = true
      end

      has_stdout
    end

    def read_stderr(channel : SSH2::Channel, buffer_slice : Slice(UInt8), log_file : File) : Bool
      has_stderr = false

      while (len = channel.read_stderr(buffer_slice).to_i32) > 0
        string = String.new buffer_slice[0, len]

        log_file.print t_stderr_no_c(string)
        log_file.flush

        STDERR.print t_stderr(string)

        has_stderr = true
      end

      has_stderr
    end

    def exec(channel : SSH2::Channel, command : String, log_file : File) : Int32
      channel.command(command)

      until channel.eof?
        buffer_space = uninitialized UInt8[BUFFER_SIZE]
        buffer_slice = buffer_space.to_slice

        has_stdout = read_stdout(channel, buffer_slice, log_file)
        has_stderr = read_stderr(channel, buffer_slice, log_file) unless has_stdout

        sleep 0.01 if !has_stdout && !has_stderr
      end

      channel.exit_status
    end

    def command(host, port, username, pubkey, commands, log_dir)
      remote = t_remote("#{username}@#{host}")

      L.info "execute commands", remote

      FileUtils.mkdir_p(log_dir)

      log_file = File.new("#{log_dir}/#{username}@#{host}", "w+")

      SSH2::Session.open(host, port) do |session|
        L.verbose "session was successfully established", remote

        session.login_with_pubkey(username, File.expand_path(pubkey))

        L.verbose "logged in successfully", remote

        commands.each do |command|
          L.info "execute #{t_command(command)}", remote

          session.open_session do |channel|
            L.verbose "created channel with successfully", remote

            exit_code = exec(channel, command, log_file)

            L.verbose "exit_code of #{t_command(command)} is #{t_exit_code(exit_code.to_s)}", remote

            if exit_code != 0
              raise "exit_code of #{t_command(command)} on #{remote} is #{t_exit_code(exit_code.to_s)}"
            end
          end
        end
      end
    end

    include Theme
  end
end
