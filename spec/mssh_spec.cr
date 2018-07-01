require "./spec_helper"

describe Mssh::Config do
  it "minimum" do
    a = AssertedExecutor.new
    c = Config.init(path("minimum.yaml"), 1, default_log_dir, a)

    assert_groups(c.groups, 1)
    assert_group(c.groups[0], "group")
    assert_nodes(c.groups[0].nodes, 1)
    assert_node(c.groups[0].nodes[0], "host")
    assert_jobs(c.jobs, 1)
    assert_job(c.jobs[0], "job", ["command"])
    assert_sets(c.sets, 0)

    c.execute(["job"], ["group"])

    assert_executor(a, 0, "host", default_port, default_user, default_key, ["command"], default_log_dir)
  end

  it "user and key for node" do
    a = AssertedExecutor.new
    c = Config.init(path("user_and_key_for_node.yaml"), 1, default_log_dir, a)

    assert_groups(c.groups, 1)
    assert_group(c.groups[0], "group")
    assert_nodes(c.groups[0].nodes, 2)
    assert_node(c.groups[0].nodes[0], "host_1", "user_1", "key_1")
    assert_node(c.groups[0].nodes[1], "host_2", "user_2", "key_2")
    assert_jobs(c.jobs, 1)
    assert_job(c.jobs[0], "job", ["command"])
    assert_sets(c.sets, 0)

    c.execute(["job"], ["group"])

    assert_executor(a, 0, "host_1", default_port, "user_1", "key_1", ["command"], default_log_dir)
    assert_executor(a, 1, "host_2", default_port, "user_2", "key_2", ["command"], default_log_dir)
  end

  it "user and key for group" do
    a = AssertedExecutor.new
    c = Config.init(path("user_and_key_for_group.yaml"), 1, default_log_dir, a)

    assert_groups(c.groups, 1)
    assert_group(c.groups[0], "group", "user", "key")
    assert_nodes(c.groups[0].nodes, 2)
    assert_node(c.groups[0].nodes[0], "host_1")
    assert_node(c.groups[0].nodes[1], "host_2")
    assert_jobs(c.jobs, 1)
    assert_job(c.jobs[0], "job", ["command"])
    assert_sets(c.sets, 0)

    c.execute(["job"], ["group"])

    assert_executor(a, 0, "host_1", default_port, "user", "key", ["command"], default_log_dir)
    assert_executor(a, 1, "host_2", default_port, "user", "key", ["command"], default_log_dir)
  end

  it "user and key nested" do
    a = AssertedExecutor.new
    c = Config.init(path("user_and_key_nested.yaml"), 1, default_log_dir, a)

    assert_groups(c.groups, 1)
    assert_group(c.groups[0], "group", "user_1", "key_1")
    assert_nodes(c.groups[0].nodes, 2)
    assert_node(c.groups[0].nodes[0], "host_1")
    assert_node(c.groups[0].nodes[1], "host_2", "user_2", "key_2")
    assert_jobs(c.jobs, 1)
    assert_job(c.jobs[0], "job", ["command"])
    assert_sets(c.sets, 0)

    c.execute(["job"], ["group"])

    assert_executor(a, 0, "host_1", default_port, "user_1", "key_1", ["command"], default_log_dir)
    assert_executor(a, 1, "host_2", default_port, "user_2", "key_2", ["command"], default_log_dir)
  end

  it "multiple jobs" do
    a = AssertedExecutor.new
    c = Config.init(path("multiple_jobs.yaml"), 1, default_log_dir, a)

    assert_groups(c.groups, 1)
    assert_group(c.groups[0], "group")
    assert_nodes(c.groups[0].nodes, 1)
    assert_node(c.groups[0].nodes[0], "host")
    assert_jobs(c.jobs, 2)
    assert_job(c.jobs[0], "job_1", ["command 1"])
    assert_job(c.jobs[1], "job_2", ["command 2"])
    assert_sets(c.sets, 0)

    c.execute(["job_1", "job_2"], ["group"])

    assert_executor(a, 0, "host", default_port, default_user, default_key, ["command 1"], default_log_dir)
    assert_executor(a, 1, "host", default_port, default_user, default_key, ["command 2"], default_log_dir)
  end

  it "multiple groups" do
    a = AssertedExecutor.new
    c = Config.init(path("multiple_groups.yaml"), 1, default_log_dir, a)

    assert_groups(c.groups, 2)
    assert_group(c.groups[0], "group_1")
    assert_group(c.groups[1], "group_2")
    assert_nodes(c.groups[0].nodes, 1)
    assert_nodes(c.groups[1].nodes, 1)
    assert_node(c.groups[0].nodes[0], "host_1")
    assert_node(c.groups[1].nodes[0], "host_2")
    assert_jobs(c.jobs, 1)
    assert_job(c.jobs[0], "job", ["command"])
    assert_sets(c.sets, 0)

    c.execute(["job"], ["group_1", "group_2"])

    assert_executor(a, 0, "host_1", default_port, default_user, default_key, ["command"], default_log_dir)
    assert_executor(a, 1, "host_2", default_port, default_user, default_key, ["command"], default_log_dir)
  end

  it "group includes groups" do
    a = AssertedExecutor.new
    c = Config.init(path("group_includes_groups.yaml"), 1, default_log_dir, a)

    assert_groups(c.groups, 3)
    assert_group(c.groups[0], "group_1")
    assert_group(c.groups[1], "group_2")
    assert_group(c.groups[2], "group_3")
    assert_jobs(c.jobs, 1)
    assert_job(c.jobs[0], "job", ["command"])
    assert_sets(c.sets, 0)

    c.execute(["job"], ["group_3"])

    assert_executor(a, 0, "host_3", default_port, default_user, default_key, ["command"], default_log_dir)
    assert_executor(a, 1, "host_1", default_port, default_user, default_key, ["command"], default_log_dir)
    assert_executor(a, 2, "host_2", default_port, default_user, default_key, ["command"], default_log_dir)
  end

  it "port for node" do
    a = AssertedExecutor.new
    c = Config.init(path("port_for_node.yaml"), 1, default_log_dir, a)

    assert_groups(c.groups, 1)
    assert_group(c.groups[0], "group")
    assert_nodes(c.groups[0].nodes, 1)
    assert_node(c.groups[0].nodes[0], "host", nil, nil, 2222)
    assert_jobs(c.jobs, 1)
    assert_job(c.jobs[0], "job", ["command"])

    c.execute(["job"], ["group"])

    assert_executor(a, 0, "host", 2222, default_user, default_key, ["command"], default_log_dir)
  end

  it "port for group" do
    a = AssertedExecutor.new
    c = Config.init(path("port_for_group.yaml"), 1, default_log_dir, a)

    assert_groups(c.groups, 1)
    assert_group(c.groups[0], "group", nil, nil, 2222)
    assert_nodes(c.groups[0].nodes, 1)
    assert_node(c.groups[0].nodes[0], "host")
    assert_jobs(c.jobs, 1)
    assert_job(c.jobs[0], "job", ["command"])

    c.execute(["job"], ["group"])

    assert_executor(a, 0, "host", 2222, default_user, default_key, ["command"], default_log_dir)
  end

  it "set" do
    a = AssertedExecutor.new
    c = Config.init(path("set.yaml"), 1, default_log_dir, a)

    assert_groups(c.groups, 1)
    assert_group(c.groups[0], "group")
    assert_nodes(c.groups[0].nodes, 1)
    assert_node(c.groups[0].nodes[0], "host")
    assert_jobs(c.jobs, 1)
    assert_job(c.jobs[0], "job", ["command"])
    assert_sets(c.sets, 1)
    assert_set(c.sets.not_nil![0], ["job"], ["group"])

    c.execute([] of String, [] of String, "set")

    assert_executor(a, 0, "host", default_port, default_user, default_key, ["command"], default_log_dir)
  end
end
