class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.50-reF1nd/sing-box-1.14.0-alpha.50-reF1nd-darwin-arm64.tar.gz"
      sha256 "b0f3fc0b1bd9c19f7f596845ef14d333c3b3b41db95ee04a6222cb4514b5f8f8"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.50-reF1nd/sing-box-1.14.0-alpha.50-reF1nd-darwin-amd64.tar.gz"
      sha256 "ae4951bde39b370e86a9977bb20847ee0944b9b4ed5f7b5d84b8db5afb9700d6"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.50-reF1nd/sing-box-1.14.0-alpha.50-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "66d90bafb149aec4c774435080973141c690296fd8c6a375bf23f5c68b301894"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.50-reF1nd/sing-box-1.14.0-alpha.50-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "2a0d4e396eca943e2ae0d7b619ea2d6ac307182c84f5c50ff0fae9cc92793ec8"
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
