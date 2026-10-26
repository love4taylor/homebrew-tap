class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd fork)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  version "1.14.4"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.4-reF1nd/sing-box-1.14.4-reF1nd-darwin-arm64.tar.gz"
      sha256 "bab6ea4cc20d4e6c995aa5181a4114942dbda5603cfe77d3e4361ea4964f2ced"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.4-reF1nd/sing-box-1.14.4-reF1nd-darwin-amd64.tar.gz"
      sha256 "2c97867e15a303663e442a5d55e4d0ea0733c011aa31a790d1aafb36fb0ea6ba"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.4-reF1nd/sing-box-1.14.4-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "0a0828c76a9c7561825b1873f8029b8b3b8cb414bdc3d68b953c5c8da40962df"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.4-reF1nd/sing-box-1.14.4-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "b40bd43acf85ef225436b3b762473a08674af9d43249ebd3c50b3666f4a9468a"
    end
  end

  conflicts_with "sing-box-ref1nd-testing", because: "both install sing-box-ref1nd binary"

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
