class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.10-reF1nd/sing-box-1.15.0-alpha.10-reF1nd-darwin-arm64.tar.gz"
      sha256 "b76754db8aa66956298c477ff7691491f82297808f23e6ca2e2141de57b6b580"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.10-reF1nd/sing-box-1.15.0-alpha.10-reF1nd-darwin-amd64.tar.gz"
      sha256 "6cec51820733da0e3fa882d11669bdda69354a48369ea43720747bb76b8a69c2"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.10-reF1nd/sing-box-1.15.0-alpha.10-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "36a49f4a7180a9fe0b09b731444780be21d6f8928b001bfe61c3d2cf953f0964"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.10-reF1nd/sing-box-1.15.0-alpha.10-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "e46f76d6165881dd8890eff7b79a0be6b3ce68a66530a42971364fa114d1b5c9"
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
