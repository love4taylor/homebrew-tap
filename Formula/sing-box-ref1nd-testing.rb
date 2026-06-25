class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.34-reF1nd/sing-box-1.14.0-alpha.34-reF1nd-darwin-arm64.tar.gz"
      sha256 "23c09fa054a43a1b772357d1dd4096313521289892c172765da985cfaeb92c25"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.34-reF1nd/sing-box-1.14.0-alpha.34-reF1nd-darwin-amd64.tar.gz"
      sha256 "2af26180e9695ccfefe093818ff2322dc1c81207000dfffb4d0e7847f9d277d3"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.34-reF1nd/sing-box-1.14.0-alpha.34-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "53fe4ef513ab56bbc8ce5d6e7f426587d641c3f8876b8ee8e3fb891a8fbd8468"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.34-reF1nd/sing-box-1.14.0-alpha.34-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "25ba2f09dbd353c917fab200d83ec1f8063d969f1d77ec2c73b1318aa5046177"
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
