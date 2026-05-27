# Testing

```
Home Manager provides a convenient tests command for discovering and running tests:

List all available tests
nix run .#tests -- -l
List tests matching a pattern
nix run .#tests -- -l alacritty
Run all tests matching a pattern
nix run .#tests -- alacritty
Run a specific test
nix run .#tests -- test-alacritty-empty-settings
Run integration tests
nix run .#tests -- -t -l
Interactive test selection (requires fzf)
python3 tests/tests.py -i
Pass additional nix build flags
nix run .#tests -- alacritty -- --verbose
```
