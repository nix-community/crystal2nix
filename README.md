 [<img src="https://nixos.org/logo/nixos-logo-only-hires.png" width="200" align="right" alt="NixOS">](https://nixos.org)

# Crystal2Nix

Crystal2Nix is a tool designed to generate Nix expressions for Crystal projects. It simplifies the process of managing dependencies and building Crystal applications within the Nix ecosystem.

## Features

- Automatically generates Nix expressions from `shard.yml` files.
- Supports Crystal projects with various dependencies.
- Building and managing Crystal applications.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Testing](#testing)
- [Contributing](#contributing)
- [License](#license)

## Installation

### Prerequisites

- [Nix](https://nixos.org/download.html) installed on your system.
- [Crystal](https://crystal-lang.org/install/) programming language installed.

## Installation

You don't need to install crystal2nix manually. With Nix installed on your system, you can run it directly using the following command:

`nix-shell -p crystal2nix --run crystal2nix`

## Usage

To generate a Nix expression for your Crystal project, simply run:

`crystal2nix`

## Testing

Unit Tests: These tests can be run within the Nix sandbox without requiring network connectivity.

`make check `     # Runs unit tests

## Future plans 

Support for Fossil resources: Expanding source control compatibility.
Additional integration test cases: Enhancing the robustness of our test suite.


## Contributing

We value contributions from the community. If you have suggestions, bug reports, or improvements, please submit them through GitHub issues or pull requests. Your involvement helps us make crystal2nix better for everyone.

1. Fork it (<https://github.com/your-github-user/crystal2nix/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

crystal2nix is licensed under the MIT License. You are free to use, modify, and distribute this software under the terms of this license.

## Contributors

- [Michael Fellinger](https://github.com/manveru)
- [Peter Hoeg](https://github.com/peterhoeg)
- [Vidhvath J](https://github.com/vidhvath28)