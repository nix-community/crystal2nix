# crystal2nix

`crystal2nix` is a tool that helps you generate Nix expressions for your Crystal projects. It simplifies the process of integrating Crystal projects with the Nix package manager, allowing you to easily build and manage your Crystal dependencies using Nix.

## Installation

You don't need to install crystal2nix manually. With Nix installed on your system, you can run it directly using the following command:

`nix-shell -p crystal2nix --run crystal2nix`

This command creates a shell environment with crystal2nix available, allowing you to use it without any additional setup.

## Usage

To generate a Nix expression for your Crystal project, simply run:

`crystal2nix`

This command will create a shards.nix file in your project directory, containing the necessary Nix expressions to build your project with Nix.

## Testing

Unit Tests

To test only the unit test cases
Unit tests focus on verifying the functionality of individual components within the crystal2nix project. These tests are designed to be quick and isolated, ensuring that each class or method behaves as intended under various conditions.

`make check`

All Tests

To run all available test cases, including integration tests, use:

`make all-tests`

These commands ensure that your changes are tested thoroughly before being pushed to the repository.


## Development

We welcome all contributions, whether it's bug fixes, new features, or documentation improvements. If you're interested in contributing to crystal2nix, here's how you can get started:

## Contributing

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
