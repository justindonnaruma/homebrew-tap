class BetterCcflare < Formula
  desc "Claude Code proxy with load balancing, account rotation and a dashboard"
  homepage "https://github.com/tombii/better-ccflare"
  version "3.5.44"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/tombii/better-ccflare/releases/download/v#{version}/better-ccflare-macos-arm64"
      sha256 "bdd5529f46778fa5058a672158a1fcd5748cadcfa94330b056aeffffbd3972ef" # sha:macos-arm64
    end
    on_intel do
      url "https://github.com/tombii/better-ccflare/releases/download/v#{version}/better-ccflare-macos-x86_64"
      sha256 "0f70a80666e6d509d22bda3a7d9d34531b1660a44693b5dfaf4dbe202ea0497f" # sha:macos-x86_64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tombii/better-ccflare/releases/download/v#{version}/better-ccflare-linux-arm64"
      sha256 "e1ddd7288076dd5dc6186d93ed1440aadbbc30448ea5e2a7451b77edf0cf5171" # sha:linux-arm64
    end
    on_intel do
      url "https://github.com/tombii/better-ccflare/releases/download/v#{version}/better-ccflare-linux-amd64"
      sha256 "1ea4ec3896a5f2f8390defbfe17f2f9218badbbb6d618bb1d0a0c627ea061baf" # sha:linux-amd64
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
