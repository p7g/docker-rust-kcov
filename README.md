# Docker Image for Rust Code Coverage (kcov)

This repository contains a `Dockerfile` meant for measuring Rust code coverage
using [kcov](https://github.com/SimonKagstrom/kcov) and
[cargo-kcov](https://github.com/kennytm/cargo-kcov).

To run the code coverage:
```
docker run -it --rm --security-opt seccomp=unconfined --volume "$(PWD):/volume" elmtai/docker-rust-kcov
```

**NOTE**: `cargo-kcov` does _not_ support cargo workspaces. Visit each crate
of a workspace individually to run. You can use the `--workdir` argument to
change the working directory inside the container. For example, if a crate from
a workspace is located in the `$(PWD)/lib` directory:
```
docker run -it --rm --security-opt seccomp=unconfined --volume "$(PWD):/volume" --workdir /volume/lib elmtai/docker-rust-kcov
```

## License
[license]: #license

This work is distributed under the terms of the Apache License (Version 2.0).

See [LICENSE](LICENSE) for details.

