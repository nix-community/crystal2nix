# crystal2nix  
crystal2nix is a streamlined tool designed to simplify the integration of Crystal projects with the Nix package manage, it supports seamless builds from both Git and Mercurial repositories.

`crystal2nix` 

## Installation

You don't need to install crystal2nix manually. With Nix installed on your system, you can run it directly using the following command:

`nix-shell -p crystal2nix --run crystal2nix`

## Usage

To generate a Nix expression for your Crystal project, simply run:

`crystal2nix`

## Testing

crystal2nix includes various test cases to ensure the reliability and functionality of the tool. These are categorized into offline unit tests.

Offline Unit Tests: These tests can be run within the Nix sandbox without requiring network connectivity.

`make check`

Helps you test offline test cases.

## Development

We welcome all contributions, whether it's bug fixes, new features, or documentation improvements. If you're interested in contributing to crystal2nix, here's how you can get started:

## Future plans 

Support for Fossil resources: Expanding source control compatibility.
Enhanced Test Suite: Adding more integration test cases to further solidify the reliability of crystal2nix.

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
