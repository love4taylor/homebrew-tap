class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.43-reF1nd/sing-box-1.14.0-alpha.43-reF1nd-darwin-arm64.tar.gz"
      sha256 "8126c6324b0f5e543b64de9a34cadd6cf673837949b97cdd867565bbd715afc1"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.43-reF1nd/sing-box-1.14.0-alpha.43-reF1nd-darwin-amd64.tar.gz"
      sha256 "0acf13935fc7967e876036160ef5da79d04178d6ac98b275c764f01932507686"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.43-reF1nd/sing-box-1.14.0-alpha.43-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "5808b2c2986ca8953a7059ab47edb0f2efdbf730c25839b5748e07cec915f82f"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.43-reF1nd/sing-box-1.14.0-alpha.43-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "3b0eb484f62615294136a80d8020b5cdc3de5cce1e3793347c6082f8cd5244a8"
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
