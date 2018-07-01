module Mssh
  class Logger
    LL = %w(verbose info none)

    @@log_level = "info"

    def self.set_log_level(log_level : String)
      unless LL.includes?(log_level)
        raise "log level is one of 'verbose', 'info' or 'none'. default is 'info'. you specified '#{log_level}'"
      end

      @@log_level = log_level
    end

    def self.verbose(message : String, host : String? = nil)
      return unless %w(verbose).includes?(@@log_level)

      print_log(c_verbose, "verb", message, host)
    end

    def self.debug(message : String, host : String? = nil)
      return unless %w(verbose).includes?(@@log_level)

      print_log(c_debug, "debg", message, host)
    end

    def self.info(message : String, host : String? = nil)
      return unless %w(verbose info).includes?(@@log_level)

      print_log(c_info, "info", message, host)
    end

    def self.warning(message : String, host : String? = nil)
      return unless %w(verbose info).includes?(@@log_level)

      print_log(c_warning, "warn", message, host)
    end

    def self.error(message : String, host : String? = nil)
      return unless %w(verbose info none).includes?(@@log_level)

      print_log(c_error, "erro", message, host)
    end

    def self.print_log(color, tag, message, host)
      puts "[%4s] %s -- %s : %s" % [tag.colorize.fore(color), ftime, (host || hostname), message]
    end

    def self.ftime : String
      Time.now.to_s("%Y-%m-%d %H:%M:%S")
    end

    def self.hostname : String
      ""
    end

    extend Theme
  end

  alias L = Logger
end
