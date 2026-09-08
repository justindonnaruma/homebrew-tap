class BetterCcflare < Formula
  desc "Claude Code proxy with load balancing, account rotation and a dashboard"
  homepage "https://github.com/tombii/better-ccflare"
  version "3.5.77"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/tombii/better-ccflare/releases/download/v#{version}/better-ccflare-macos-arm64"
      sha256 "8394f28ab61f91c04b5d789aa367635e0ea1fcc9580dcbf19a1bc7ef4f24655a" # sha:macos-arm64
    end
    on_intel do
      url "https://github.com/tombii/better-ccflare/releases/download/v#{version}/better-ccflare-macos-x86_64"
      sha256 "3035c466311d16c5df473092bab4768485ef0c003976a27e24d8b64327134372" # sha:macos-x86_64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tombii/better-ccflare/releases/download/v#{version}/better-ccflare-linux-arm64"
      sha256 "e112819fc444958b9d82f73974cc6146db3b7f908c902cf998e3b8e99a220140" # sha:linux-arm64
    end
    on_intel do
      url "https://github.com/tombii/better-ccflare/releases/download/v#{version}/better-ccflare-linux-amd64"
      sha256 "9ecb24992686d7f18721fbc266517c7796de6cb6a0dbb58a6cab0a237959187f" # sha:linux-amd64
    end
  end

  def install
    binary = Dir["better-ccflare-*"].first
    odie "no better-ccflare binary found in archive" if binary.nil?
    bin.install binary => "better-ccflare"
    # Unsigned upstream binaries: strip Gatekeeper quarantine if present.
    quiet_system "/usr/bin/xattr", "-d", "com.apple.quarantine", bin/"better-ccflare" if OS.mac?
  end

  service do
    run [opt_bin/"better-ccflare", "--serve"]
    keep_alive true
    working_dir Dir.home
    log_path var/"log/better-ccflare.log"
    error_log_path var/"log/better-ccflare.log"
  end

  def caveats
    <<~EOS
      To start better-ccflare now and on every login:
        brew services start better-ccflare

      To run it in the foreground without a background service:
        better-ccflare --serve

      Once running, the dashboard is at:
        http://localhost:8080

      Data and config live in:
        ~/.config/better-ccflare/

      Logs:
        #{var}/log/better-ccflare.log
    EOS
  end

  test do
    assert_predicate bin/"better-ccflare", :executable?
  end
end
