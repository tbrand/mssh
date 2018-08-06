<p align="center">
  :rocket::rocket: <b>Mssh</b> :rocket::rocket:
</p>

<p align="center">
  <img src="https://user-images.githubusercontent.com/3483230/43590592-5088b17a-96ac-11e8-90fc-eaa0560db439.gif" width="1000"/>
  <br>
  <br>
  <i>Simple and powerful job executor on remote nodes</i>
</p>

---

Here is a sample configuration file. I think you don't need a description for it.
```yaml
#
# saved as awesome.yaml
#
groups:
  - name: my-instances
    nodes:
      - host: dummy.instance0.com
      - host: dummy.instance1.com
      - host: dummy.instance2.com

jobs:
  - name: my-awesome-job
    commands:
      - echo "This is an awesome execution! :)"
```

For the execution
```bash
./bin/mssh -c awesome.yaml -j my-awesome-job -g my-instances
```

The configuration structure is very flexible. 

**You can see other sample on [spec/conf](https://github.com/tbrand/mssh/tree/master/spec/conf).**

## Installation

This tool requires `libssh2`. For mac users, you're just needed to do
```bash
brew install libssh2
```

After that, build this project.
```bash
shards build
```

## Usage

Documentation is not ready.

I'll write them up as soon as possible.

## Development

See the [issues](https://github.com/tbrand/mssh/issues). Or you can open new issues on it.

## Contributing

1. Fork it (<https://github.com/tbrand/mssh/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [tbrand](https://github.com/tbrand) Taichiro Suzuki - creator, maintainer
