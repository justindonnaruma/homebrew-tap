class BetterCcflare < Formula
  desc "Claude Code proxy with load balancing, account rotation and a dashboard"
  homepage "https://github.com/tombii/better-ccflare"
  version "3.5.34"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/tombii/better-ccflare/releases/download/v#{version}/better-ccflare-macos-arm64"
      sha256 "eb16230fbc899c45a994581b23a6c98578cf6d6199e4dcf58923abb1c7605c06" # sha:macos-arm64
    end
    on_intel do
      url "https://github.com/tombii/better-ccflare/releases/download/v#{version}/better-ccflare-macos-x86_64"
      sha256 "17dea514c4e58982e11a56a1be97ab8555cf2118b305850f1bd391bc28432e7d" # sha:macos-x86_64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tombii/better-ccflare/releases/download/v#{version}/better-ccflare-linux-arm64"
      sha256 "fe323ac42cec1d2b69d9fdc48acb550c7d31d7bca38eb9ba2c81527ddd838c76" # sha:linux-arm64
    end
    on_intel do
      url "https://github.com/tombii/better-ccflare/releases/download/v#{version}/better-ccflare-linux-amd64"
      sha256 "813918dcbadb86b9946504ea46e3ce516c3e2ba88599b474cbda1144d353d3c4" # sha:linux-amd64
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
