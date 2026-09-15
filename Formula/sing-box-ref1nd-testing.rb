class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.4-reF1nd/sing-box-1.15.0-alpha.4-reF1nd-darwin-arm64.tar.gz"
      sha256 "bf193df07906499811c790e91a205dbdd6c8a30a51b3bf03812d7b2e63e2c53c"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.4-reF1nd/sing-box-1.15.0-alpha.4-reF1nd-darwin-amd64.tar.gz"
      sha256 "c6bef582614ddb864bc0a404631870595e28d9d1181dffb61bb67a33ea217c3c"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.4-reF1nd/sing-box-1.15.0-alpha.4-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "ad651a2f0eaded287506781a1f698118ee767f137f40d6872faa83a88b3670a6"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.4-reF1nd/sing-box-1.15.0-alpha.4-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "292fdc450b4236a7932a0937efcf7dfaf0b83edb5c4924862313c7b8eb8abba6"
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
