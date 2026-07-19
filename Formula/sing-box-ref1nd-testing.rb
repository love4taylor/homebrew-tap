class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.48-reF1nd/sing-box-1.14.0-alpha.48-reF1nd-darwin-arm64.tar.gz"
      sha256 "5251ed0b88540ab432604f06a70e0fdfab79e169fdd6ae84b5aa384515504156"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.48-reF1nd/sing-box-1.14.0-alpha.48-reF1nd-darwin-amd64.tar.gz"
      sha256 "91b487ec38222fbc708990f965c010cff039c172772054d09339614a9d8a13b3"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.48-reF1nd/sing-box-1.14.0-alpha.48-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "e277a28d17df87b83e863222ebcc19317095aad30b1b4c5947171cf0c8ad1418"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.48-reF1nd/sing-box-1.14.0-alpha.48-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "0965f45d88f15579dcc85bd0e898cb0000cbc2db0d517f7cf70c42cfc3944326"
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
