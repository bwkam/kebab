# 🍢 Kebab
This repository offers haxe-related packages that may be difficult to get working at first, this includes the haxe compiler itself.
## Usage
### Flake
flake.nix
```nix
{
  inputs.kebab.url = "github:bwkam/kebab";
  outputs =  {self, kebab, ...}@args: {
    # rest
  };
  # snip
}
```
You can also try out the packages directly from your terminal.
```
nix run "github:bwkam/kebab#<package>"
```
## Packages
* `haxe_{master, nightly}`
* `kha`

will add more soon :) 
