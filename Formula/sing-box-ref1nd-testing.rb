class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.44-reF1nd/sing-box-1.14.0-alpha.44-reF1nd-darwin-arm64.tar.gz"
      sha256 "0a0a50ceb3b1b129b91230da6c74bfbd67cd97074b962fa77f657afc16207bb8"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.44-reF1nd/sing-box-1.14.0-alpha.44-reF1nd-darwin-amd64.tar.gz"
      sha256 "056a9b2fde496da2e67f4aed42c9c3895da4d94fa165149170ce003824c0e908"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.44-reF1nd/sing-box-1.14.0-alpha.44-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "17df2d921a5bfb021b26cc351300a374645f9967e6c43b2b516c2f385e4ba3c3"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.44-reF1nd/sing-box-1.14.0-alpha.44-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "5225d69f04d72e1cb76d513ce50b26ca4570455195850ead122d1533a4482d85"
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
