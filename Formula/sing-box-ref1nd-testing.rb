class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.14-reF1nd/sing-box-1.14.0-beta.14-reF1nd-darwin-arm64.tar.gz"
      sha256 "6fb2d6b19a777a2676c38805584feacd47054322c9168efad1106b282aca421c"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.14-reF1nd/sing-box-1.14.0-beta.14-reF1nd-darwin-amd64.tar.gz"
      sha256 "45d426a2c7894bb2e964a819b085bda1baf1079b5b7d53ada95a66b8d8990769"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.14-reF1nd/sing-box-1.14.0-beta.14-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "66cbf52c0e8399e1d8ddf6af386ba3ad46a3e00cff6d8ac9760afe10783ba033"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.14-reF1nd/sing-box-1.14.0-beta.14-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "1dec0b75590fac238b3a8643ef14cb29d94fe5ccce594315a5b1ab621e4326ea"
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
