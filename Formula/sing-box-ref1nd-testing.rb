class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.9-reF1nd/sing-box-1.14.0-beta.9-reF1nd-darwin-arm64.tar.gz"
      sha256 "e186f5c3d2880502c750b3653d3f9648f620d8a42fe0eea6797b50ba00efc46e"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.9-reF1nd/sing-box-1.14.0-beta.9-reF1nd-darwin-amd64.tar.gz"
      sha256 "a17033d418be3865f41734a1d2a2adce786fa1424b8709e56372c0202e7fb087"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.9-reF1nd/sing-box-1.14.0-beta.9-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "6a38648b06a119c91976192b0ff3ec540c2845c9a58d2a896f866169a6d7a7de"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.9-reF1nd/sing-box-1.14.0-beta.9-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "c20668381909ff30ee2b30b688c19d312d4ff2988f08c84963ad39f0c6c1208f"
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
