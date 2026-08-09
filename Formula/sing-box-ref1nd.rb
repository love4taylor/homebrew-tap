class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd fork)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  version "1.13.18"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.18-reF1nd/sing-box-1.13.18-reF1nd-darwin-arm64.tar.gz"
      sha256 "de059bcffd01e6a9345b1aeb635da431796e6c41a85bd9852d3e7928160be47b"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.18-reF1nd/sing-box-1.13.18-reF1nd-darwin-amd64.tar.gz"
      sha256 "2bc429b55ca63650f5eea745179f9476abcd30fded0f5ca094e2282ff07ee3c3"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.18-reF1nd/sing-box-1.13.18-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "0128b171faa931a6e77e6bd0c98288b4f8c0e9fbce2e49f53f61f8394f8ff5b8"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.18-reF1nd/sing-box-1.13.18-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "482121807eb25efb0154c75663c6ea60ce2a78126d4f12fd464f3f037123da47"
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
