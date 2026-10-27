#!/usr/bin/env bash
# Points source.json at the latest stable release. GitHub publishes each asset's
# sha256, so the binary is not downloaded here; nix build checks it afterwards.
set -euo pipefail
cd "$(dirname "$0")"

asset=simplex-chat-ubuntu-24_04-x86_64
auth=()
[[ -n "${GITHUB_TOKEN:-}" ]] && auth=(-H "Authorization: Bearer $GITHUB_TOKEN")

release=$(curl -fsSL "${auth[@]}" https://api.github.com/repos/simplex-chat/simplex-chat/releases/latest)
version=$(jq -r .tag_name <<<"$release")
version=${version#v}
digest=$(jq -r --arg a "$asset" '.assets[] | select(.name == $a) | .digest' <<<"$release")

[[ "$digest" == sha256:* ]] || { echo "no sha256 for $asset in v$version" >&2; exit 1; }
hash=$(nix hash convert --hash-algo sha256 --to sri "${digest#sha256:}")

jq -n --arg version "$version" --arg hash "$hash" '{ version: $version, hash: $hash }' > source.json
echo "$version"
