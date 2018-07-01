module Mssh
  module Theme
    def c_verbose
      :light_gray
    end

    def t_verbose(t : String) : String
      t.colorize.fore(c_verbose).to_s
    end

    def c_debug
      :light_gray
    end

    def t_debug(t : String) : String
      t.colorize.fore(c_debug).to_s
    end

    def c_info
      :cyan
    end

    def t_info(t : String) : String
      t.colorize.fore(c_info).to_s
    end

    def c_warning
      :yellow
    end

    def t_warning(t : String) : String
      t.colorize.fore(c_warning).to_s
    end

    def c_error
      :red
    end

    def t_error(t : String) : String
      t.colorize.fore(c_error).to_s
    end

    def c_command
      :light_blue
    end

    def t_command(t : String) : String
      "`#{t.colorize.fore(c_command).to_s}`"
    end

    def c_desc
      :cyan
    end

    def t_desc(t : String) : String
      t.colorize.fore(c_desc).to_s
    end

    def c_remote
      :green
    end

    def t_remote(t : String) : String
      t.colorize.fore(c_remote).to_s
    end

    def c_stdout
      :light_green
    end

    def t_stdout(t : String) : String
      "[#{"STDOUT".colorize.fore(c_stdout)}] #{t}"
    end

    def t_stdout_no_c(t : String) : String
      "[STDOUT] #{t}"
    end

    def c_stderr
       :red
    end

    def t_stderr(t : String) : String
      "[#{"STDERR".colorize.fore(c_stderr)}] #{t}"
    end

    def t_stderr_no_c(t : String) : String
      "[STDERR] #{t}"
    end

    def c_exit_code
      :light_cyan
    end

    def t_exit_code(t : String) : String
      t.colorize.fore(c_exit_code).mode(:bold).to_s
    end
  end
end
