class BetterCcflare < Formula
  desc "Claude Code proxy with load balancing, account rotation and a dashboard"
  homepage "https://github.com/tombii/better-ccflare"
  version "3.5.22"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/tombii/better-ccflare/releases/download/v#{version}/better-ccflare-macos-arm64"
      sha256 "acda8ccb1fe21a1de92312415f4bb6c3c15d3f0f7c6c0e630dd008582d3f1275" # sha:macos-arm64
    end
    on_intel do
      url "https://github.com/tombii/better-ccflare/releases/download/v#{version}/better-ccflare-macos-x86_64"
      sha256 "8742b59b1c1ae662db372d0957e546cccc94bf5f10c5b00f4d13b5f7b3582757" # sha:macos-x86_64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tombii/better-ccflare/releases/download/v#{version}/better-ccflare-linux-arm64"
      sha256 "672711b4a8a51f77c455d288adf9ab6224294bf0506026d60dd2af308a951652" # sha:linux-arm64
    end
    on_intel do
      url "https://github.com/tombii/better-ccflare/releases/download/v#{version}/better-ccflare-linux-amd64"
      sha256 "c2c6f0d0c25c1caa42513d1852c7cbb4bbb9dbdbe51ce5fab922bba333857c94" # sha:linux-amd64
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
