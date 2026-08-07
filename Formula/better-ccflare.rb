class BetterCcflare < Formula
  desc "Claude Code proxy with load balancing, account rotation and a dashboard"
  homepage "https://github.com/tombii/better-ccflare"
  version "3.5.48"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/tombii/better-ccflare/releases/download/v#{version}/better-ccflare-macos-arm64"
      sha256 "1d65580a6bb303b0021265fe830d289ac96ee8b5252691cf003afa5660e32e3b" # sha:macos-arm64
    end
    on_intel do
      url "https://github.com/tombii/better-ccflare/releases/download/v#{version}/better-ccflare-macos-x86_64"
      sha256 "aebabde015a59714b9d885220f2b66566cecdd5b016a13d8ec2cfd29b961e3a4" # sha:macos-x86_64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tombii/better-ccflare/releases/download/v#{version}/better-ccflare-linux-arm64"
      sha256 "76700121d3536122698cf202b28d4dd05c305decf7ee45096b2f26d9f0996214" # sha:linux-arm64
    end
    on_intel do
      url "https://github.com/tombii/better-ccflare/releases/download/v#{version}/better-ccflare-linux-amd64"
      sha256 "9935decd2acb673823eb09b919caeb685974dca836144461ada61d22918f5404" # sha:linux-amd64
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
