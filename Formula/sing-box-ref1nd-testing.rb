class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.35-reF1nd.1/sing-box-1.14.0-alpha.35-reF1nd.1-darwin-arm64.tar.gz"
      sha256 "11669de2fe460f5edd1a9a612c26fbacfc96c729e7576f0f9521eb79fb840056"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.35-reF1nd.1/sing-box-1.14.0-alpha.35-reF1nd.1-darwin-amd64.tar.gz"
      sha256 "1f982fe8f966504f173b124cb7d5acdf33e34802584cd872f07315a73224ff7b"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.35-reF1nd.1/sing-box-1.14.0-alpha.35-reF1nd.1-linux-arm64-musl.tar.gz"
      sha256 "5397115d2e74c4330ba4dbc9a824b96392f7a91a3ca963e7bd2823fbc3d54efd"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.35-reF1nd.1/sing-box-1.14.0-alpha.35-reF1nd.1-linux-amd64-musl.tar.gz"
      sha256 "f5cebb8e43b05b55ba2f9e33df99c9d64ec104a4346b651595ab8bd5ed7fe3a2"
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
