# simplex-chat-nix

Nix flake for the [SimpleX Chat](https://github.com/simplex-chat/simplex-chat) terminal client (`simplex-chat`), packaged from the official prebuilt release binary.

- **No compiling.** Upstream's own flake builds from source with haskell.nix and has no binary cache, which means building GHC and hundreds of Haskell libraries. This flake fetches the release binary, checks its sha256, and links it to zlib, OpenSSL and GMP from nixpkgs.
- **Updated daily.** A GitHub Action checks the latest stable release, updates `source.json`, builds and runs the binary, and commits.
- **x86_64-linux only.**

## Usage

Try it:

```sh
nix run github:yfloress/simplex-chat-nix
```

As a flake input:

```nix
inputs.simplex-chat-nix = {
  url = "github:yfloress/simplex-chat-nix";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

Then add `simplex-chat-nix.packages.x86_64-linux.default` to your packages. `nix flake update` brings in new releases.

## Notes

- `simplex-chat --version` shows the internal version (e.g. `v7.0.0.12` for release `7.0.3`).
- The binary suggests updating with upstream's `install.sh`; ignore that and update through the flake.
- The binary is patched with two separate `patchelf` passes: doing rpath and interpreter in one pass, as `autoPatchelfHook` does, makes it segfault.

## Files

| File | Purpose |
|---|---|
| `package.nix` | The derivation |
| `source.json` | Version and hash, the only thing updates change |
| `update.sh` | Points `source.json` at the latest release, using the sha256 GitHub publishes |
| `.github/workflows/update.yml` | Daily update |

## License

AGPL-3.0, the same as SimpleX Chat.
