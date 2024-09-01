# crystal2nix  
crystal2nix is a tool designed to simplify the management and building of Crystal projects using the Nix package manager. It currently supports both Git and Mercurial sources.

`crystal2nix` 

## Installation

You don't need to install crystal2nix manually. With Nix installed on your system, you can run it directly using the following command:

`nix-shell -p crystal2nix --run crystal2nix`

## Usage

To generate a Nix expression for your Crystal project, simply run:

`crystal2nix`

## Testing

crystal2nix includes various test cases to ensure the reliability and functionality of the tool. These are categorized into offline unit tests and online integration tests.

Unit Tests

Offline Unit Tests: These tests can be run within the Nix sandbox without requiring network connectivity.


`make check`

Helps you only test offline test cases .

`make test-all`
These command helps use to test both the offline test cases and the integration test cases together.

`make test-online`
These command helps you to only test the integration test cases .


## Development

We welcome all contributions, whether it's bug fixes, new features, or documentation improvements. If you're interested in contributing to crystal2nix, here's how you can get started:

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
