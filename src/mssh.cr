require "yaml"
require "ssh2"
require "colorize"
require "file_utils"
require "option_parser"

module Mssh
  def default_user : String
    `whoami`.strip
  end

  def default_key : String
    File.expand_path("~/.ssh/id_rsa")
  end

  def default_port : Int32
    22
  end

  def default_log_dir : String
    File.expand_path("./.mssh")
  end
end

require "./cli"
require "./executor"
require "./models"
require "./queue"
