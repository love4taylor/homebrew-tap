class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.6-reF1nd/sing-box-1.15.0-alpha.6-reF1nd-darwin-arm64.tar.gz"
      sha256 "171421c6ded04a11c01641d9828330ca9fabbd5d882fa120a925926e8615f726"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.6-reF1nd/sing-box-1.15.0-alpha.6-reF1nd-darwin-amd64.tar.gz"
      sha256 "a48d9ef83f03cf0d322a848f8a016e2740998d6fa284928e5272d931830c7ec3"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.6-reF1nd/sing-box-1.15.0-alpha.6-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "b2b5d119b29536c656f554c51794cb7aa13a2e78fc2fade6fc685fe9942e2552"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.6-reF1nd/sing-box-1.15.0-alpha.6-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "2983f2ec379ce8ea37530540f544987f97e4d88db260f12b76f9c6afcaa0c54c"
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
