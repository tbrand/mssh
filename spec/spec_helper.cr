require "spec"
require "../src/mssh"
require "./mock/*"

include Mssh

Mssh::Logger.set_log_level("none")

def path(filename : String) : String
  File.expand_path("../conf/#{filename}", __FILE__)
end

def assert_groups(groups : Groups, size : Int32)
  groups.size.should eq(size)
end

def assert_group(group : Group, name : String, user : String? = nil, key : String? = nil, port : Int32? = nil)
  group.name.should eq(name)
  group.user.should eq(user)
  group.key.should eq(key)
  group.port.should eq(port)
end

def assert_nodes(nodes : Nodes, size : Int32)
  nodes.size.should eq(size)
end

def assert_node(node : Node, host : String, user : String? = nil, key : String? = nil, port : Int32? = nil)
  node.host.should eq(host)
  node.user.should eq(user)
  node.key.should eq(key)
  node.port.should eq(port)
end

def assert_jobs(jobs : Jobs, size : Int32)
  jobs.size.should eq(size)
end

def assert_job(job : Job, name : String, commands : Array(String))
  job.name.should eq(name)
  job.commands.should eq(commands)
end

def assert_sets(sets : Sets?, size : Int32)
  if size == 0
    sets.should be_nil
  else
    sets.not_nil!.size.should eq(size)
  end
end

def assert_set(set : Mssh::Set, jobs : Array(String), groups : Array(String))
  set.jobs.should eq(jobs)
  set.groups.should eq(groups)
end

def assert_executor(a : AssertedExecutor, n : Int32, host : String, port : Int32, username : String,
                    pubkey : String, commands : Array(String), log_dir : String)
  a.commands[n][:host].should eq(host)
  a.commands[0][:port].should eq(port)
  a.commands[n][:username].should eq(username)
  a.commands[n][:pubkey].should eq(pubkey)
  a.commands[n][:commands].should eq(commands)
  a.commands[n][:log_dir].should eq(log_dir)
end
