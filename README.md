
## Initializing

Clone to `$XDG_CONFIG_HOME/home-manager`.

See: https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-standalone

```sh
sudo mv /etc/nixos/configuration.nix /etc/nixos/configuration.nix.bak
sudo ln -s $XDG_CONFIG_HOME/home-manager/machines/<machine>/configuration.nix /etc/nixos/configuration.nix
nix run home-manager/release-23.11 -- init --switch
```

Create the appropriate Firefox profiles with the profile manager:
```sh
fireofox-developer-edition --ProfileManager
```

## Audio

Start `easyeffects` and select the `perfect-eq` plugin for audio output.
Set microphone volume to 50% initially:
```sh
wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 0.5
```


