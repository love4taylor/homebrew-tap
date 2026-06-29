class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.37-reF1nd/sing-box-1.14.0-alpha.37-reF1nd-darwin-arm64.tar.gz"
      sha256 "321b138e487f0c1b8cf9177bdc5c0932186e721b9e01684b5a8604978aa1ab98"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.37-reF1nd/sing-box-1.14.0-alpha.37-reF1nd-darwin-amd64.tar.gz"
      sha256 "0aeaa9680cdcb316e27a6f1b11c9046a9b7e4b35c5aae8e69ac66deb01e29d01"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.37-reF1nd/sing-box-1.14.0-alpha.37-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "1f50091d4de7eb512ee41725310a0e0f1ffad6c4e8f3ac54adc4038642048853"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.37-reF1nd/sing-box-1.14.0-alpha.37-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "75424598eadf5dfc85c25d28b495928724c3edaf213fe70c4e5c821347d94567"
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
