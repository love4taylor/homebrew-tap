class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.45-reF1nd/sing-box-1.14.0-alpha.45-reF1nd-darwin-arm64.tar.gz"
      sha256 "1f205155cd5a54191ee137dc1b4279e63d5cdd65cc0480fb7acf3d3a8bfd657b"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.45-reF1nd/sing-box-1.14.0-alpha.45-reF1nd-darwin-amd64.tar.gz"
      sha256 "92056ce95bd58ab8764c9728a9f692cde67c14dd298446ba866389735a33f8b2"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.45-reF1nd/sing-box-1.14.0-alpha.45-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "0410172b6b7aa3c7a0d12737a9536b6bcff558bffceadb6ab5854eeb2a48b622"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.45-reF1nd/sing-box-1.14.0-alpha.45-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "0f1ef4fdf36abd4d59a9239593a3f810051044712342c75fb638232085a6917c"
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
