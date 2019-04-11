# This image is meant to measure code coverage of Rust projects using kcov.
# See https://github.com/kennytm/cargo-kcov
# Run with:
#   docker run --security-opt seccomp=unconfined -v "$PWD:/volume" elmtai/docker-rust-kcov

# FROM ragnaroek/kcov_head
FROM ragnaroek/kcov:v33

# Install Rust
# Stable channel
ENV RUST_TOOLCHAIN=1.32.0

# Add GitHub's SSH fingerprint to the image global known host list.
# This allows cargo to clone the registry in a CI environment without asking
# if the user recognize the fingerprint.
RUN echo "github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==" >> /etc/ssh/ssh_known_hosts

RUN printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://security.debian.org jessie/updates main\ndeb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list

# Add extra packages
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
        curl \
        libssl-dev \
        python3.4 \
        libpython3.4 \
        libpython3.4-dev \
        python3 \
    && rm -rf /var/lib/apt/lists/*


ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

ENV HOME=/volume
WORKDIR ${HOME}

# Install the rust toolchain _after_ packages so that installing a nightly
# toolchain can be updated more quickly.
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain ${RUST_TOOLCHAIN}

# Install cargo-kcov
# See https://github.com/kennytm/cargo-kcov
RUN cargo install cargo-kcov

# Overwrite the `CARGO_HOME` variable so that its content can be cached in a
# volume when using `--volume $(PWD):/volume` is used.
ENV CARGO_HOME ${HOME}/.cargo

# Overwrite original image's entrypoint
ENTRYPOINT ["/bin/sh", "-c"]
# CMD ["/bin/bash"]
CMD ["/usr/local/cargo/bin/cargo-kcov kcov -v"]

