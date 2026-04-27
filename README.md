# homebrew-tap

Personal Homebrew tap maintained by [@justindonnaruma](https://github.com/justindonnaruma).

## Formulae

### `better-ccflare`

Pre-built binary install of [tombii/better-ccflare](https://github.com/tombii/better-ccflare) — a Claude Code proxy with load balancing, account rotation and a dashboard.

```sh
brew tap justindonnaruma/tap
brew install better-ccflare
```

Or in one shot:

```sh
brew install justindonnaruma/tap/better-ccflare
```

#### Run as a background service

```sh
brew services start better-ccflare
```

That registers a launchd (macOS) / systemd (Linux) job that starts on login and restarts on crash. The dashboard is at <http://localhost:8080>; data lives in `~/.config/better-ccflare/`.

To stop:

```sh
brew services stop better-ccflare
```

#### Run in the foreground

```sh
better-ccflare --serve
```

## Auto-bump

A daily GitHub Actions workflow ([`.github/workflows/bump.yml`](.github/workflows/bump.yml)) checks `tombii/better-ccflare` for new releases. When upstream publishes a new tag, the workflow recomputes the four release-asset SHA256s and opens a pull request with the version + checksum bump. Merging the PR publishes the new version through the tap.

You can also trigger the workflow manually from the **Actions** tab, or via `repository_dispatch` (event type `upstream-release`) if you wire upstream to call it.

## License

MIT — see [LICENSE](LICENSE). The packaged binaries are © their upstream authors and distributed under their respective licenses.
