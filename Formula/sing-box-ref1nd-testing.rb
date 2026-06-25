class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.35-reF1nd/sing-box-1.14.0-alpha.35-reF1nd-darwin-arm64.tar.gz"
      sha256 "db8ead235c1fe4f3dd69d7382d946016a5e9b16ee82a4a03cd6136861fec029c"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.35-reF1nd/sing-box-1.14.0-alpha.35-reF1nd-darwin-amd64.tar.gz"
      sha256 "f24405b113767f54a5a4c5260c4610d5518b61e4a142293058a401962a39ec18"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.35-reF1nd/sing-box-1.14.0-alpha.35-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "482d4f418b1aa953e56ba02c605d45743bf94cd1241b29e8a1c72dd3fc7681ba"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.35-reF1nd/sing-box-1.14.0-alpha.35-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "5cc40e107b43a440a06e094437a79f9959f6cf1a0ce9d8289e6b1bcc2e39c9d7"
    end
  end

  conflicts_with "sing-box-ref1nd", because: "both install sing-box-ref1nd binary"

  def install
    # The tarball extracts directly into buildpath.
    # The binary is named `sing-box` — rename to avoid conflict with original sing-box.
    bin.install "sing-box" => "sing-box-ref1nd"
  end

  post_install_steps do
    mkdir_p "sing-box-ref1nd", base: :etc
  end

  def caveats
    <<~EOS
      No default configuration is provided. Place your JSON config files under:
        #{etc}/sing-box-ref1nd/
    EOS
  end

  service do
    run [opt_bin/"sing-box-ref1nd", "run",
         "--config-directory", etc/"sing-box-ref1nd",
         "--directory", var/"lib/sing-box-ref1nd"]
    run_type :immediate
    keep_alive true
    require_root true
    process_type :background
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sing-box-ref1nd version")
  end
end
