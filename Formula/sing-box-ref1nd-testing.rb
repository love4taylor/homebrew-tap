class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.2-reF1nd/sing-box-1.15.0-alpha.2-reF1nd-darwin-arm64.tar.gz"
      sha256 "c4ff3b87a1090882ae3373b46e030dde1f7b3a99adc86ed9e30110a0841018dc"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.2-reF1nd/sing-box-1.15.0-alpha.2-reF1nd-darwin-amd64.tar.gz"
      sha256 "b7ebdb1a0f5a7565fd1b97c09039e29681ddeaf66380ed33a907c455abae3044"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.2-reF1nd/sing-box-1.15.0-alpha.2-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "462f20be5d010174a809441accc82f954430042cf249dee6c839f13e819a84f0"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.2-reF1nd/sing-box-1.15.0-alpha.2-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "598c5c4d9961fd4eb67b2bfe4d114561d683ddc23ff3115b04ede6d709f78660"
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
