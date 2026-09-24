class BetterCcflare < Formula
  desc "Claude Code proxy with load balancing, account rotation and a dashboard"
  homepage "https://github.com/tombii/better-ccflare"
  version "3.5.88"
  license "MIT"
  revision 1

  on_macos do
    on_arm do
      url "https://github.com/tombii/better-ccflare/releases/download/v#{version}/better-ccflare-macos-arm64"
      sha256 "33289886fa0e40feb44f9c03dab0979f3714a4920107313413d343e106fea0ae" # sha:macos-arm64
    end
    on_intel do
      url "https://github.com/tombii/better-ccflare/releases/download/v#{version}/better-ccflare-macos-x86_64"
      sha256 "0f82544a717c889357a6bd07c9e1565cc686c95d918326371c620009148c3d74" # sha:macos-x86_64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tombii/better-ccflare/releases/download/v#{version}/better-ccflare-linux-arm64"
      sha256 "c41c52c9281c5ab28f96fb1e941edbd4b062e21729f4b58fd2420266491f30ae" # sha:linux-arm64
    end
    on_intel do
      url "https://github.com/tombii/better-ccflare/releases/download/v#{version}/better-ccflare-linux-amd64"
      sha256 "07ecd61c7a499673789b73cd108dd1c8f9446bee4a720fca405aef597adb9f86" # sha:linux-amd64
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
    base_url = "http://localhost:8080"
    case File.basename(ENV.fetch("SHELL", ""))
    when "fish"
      rc = "~/.config/fish/config.fish"
      export_line = "set -gx ANTHROPIC_BASE_URL #{base_url}"
    when "bash"
      rc = "~/.bash_profile"
      export_line = "export ANTHROPIC_BASE_URL=#{base_url}"
    else
      rc = "~/.zshrc"
      export_line = "export ANTHROPIC_BASE_URL=#{base_url}"
    end

    <<~EOS
      To start better-ccflare now and on every login:
        brew services start better-ccflare

      To run it in the foreground without a background service:
        better-ccflare --serve

      Point Claude Code at the proxy by setting ANTHROPIC_BASE_URL.
      Homebrew can't edit your shell for you, but this one-liner persists it
      so every new shell picks it up automatically:
        echo '#{export_line}' >> #{rc}

      Apply it to your current shell now with:
        #{export_line}

      No API key needed when Claude CLI is already logged in via OAuth.

      Once running, the dashboard is at:
        #{base_url}

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
