class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.11-reF1nd/sing-box-1.15.0-alpha.11-reF1nd-darwin-arm64.tar.gz"
      sha256 "7b502c038e0bd5459c81702e7b14be78037f27dfebd94f0ae45fd2d67fc13122"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.11-reF1nd/sing-box-1.15.0-alpha.11-reF1nd-darwin-amd64.tar.gz"
      sha256 "e4643d57f2ac05cca4a892c79c083df1cf7d54c9c06064114ce411cb53d91004"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.11-reF1nd/sing-box-1.15.0-alpha.11-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "6840a1c1ec3d924bf6620126a2736a89098bf562c50eccd2c2de577dc8a75e1c"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.11-reF1nd/sing-box-1.15.0-alpha.11-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "7179981f14c225e3e872ac60af2086d6d719b4ddfd901c115c86cd9e4581f4fb"
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
