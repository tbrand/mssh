module Mssh
  class Defaults
    @@user : String?

    def self.cache
      @@user = `whoami`.strip
    end

    def self.user : String
      raise "Default values are not initalized. \n" +
            "Please call `Mssh::Defaults.cache` first." unless r = @@user

      r
    end

    def self.key : String
      File.expand_path("~/.ssh/id_rsa")
    end

    def self.port : Int32
      22
    end

    def self.log_dir : String
      File.expand_path("./.mssh")      
    end
  end
end
