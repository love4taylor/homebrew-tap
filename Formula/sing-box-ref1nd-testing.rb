class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.17-reF1nd/sing-box-1.14.0-beta.17-reF1nd-darwin-arm64.tar.gz"
      sha256 "b80682787c536978dd38652526f6dd417ccdb8345cfa1950ee3a7d3f4183797b"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.17-reF1nd/sing-box-1.14.0-beta.17-reF1nd-darwin-amd64.tar.gz"
      sha256 "a98088ee5f7211ec14bfd7aaecd2e86bd824d29a07a6d92d572569c07ea50dff"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.17-reF1nd/sing-box-1.14.0-beta.17-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "21869077ec0cf8b8fb505c048318a44fbd0fdb614e7fb123025f7db9dd91d5da"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.17-reF1nd/sing-box-1.14.0-beta.17-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "0645e69c9b3bec0a0092529eaf4ca0f9dc30ef51d94da12b31519688ae6f5a2e"
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
