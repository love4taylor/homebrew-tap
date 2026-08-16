class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.15-reF1nd/sing-box-1.14.0-beta.15-reF1nd-darwin-arm64.tar.gz"
      sha256 "e5de2a050fdf320723a39ef20bf5118583a6595298891df12866221e61355bea"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.15-reF1nd/sing-box-1.14.0-beta.15-reF1nd-darwin-amd64.tar.gz"
      sha256 "cfcc95dadb346462d1bfeaacb28974dc7814b69c97d5ce46f507aafbfcad4e53"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.15-reF1nd/sing-box-1.14.0-beta.15-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "bf8972a26516727af8767da2916465e6eb60bc74e2a753ac1b1239c103fe46cb"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.15-reF1nd/sing-box-1.14.0-beta.15-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "66ae7cfde52360b9acb55d97928b28e14f8f74a5607477a821965abbb95277d8"
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
