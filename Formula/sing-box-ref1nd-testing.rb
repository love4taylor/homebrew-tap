class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.3-reF1nd/sing-box-1.14.0-beta.3-reF1nd-darwin-arm64.tar.gz"
      sha256 "9683337ce05e5bb23b0b459b4241d904fa8544b6f4b066c658d13434eea638da"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.3-reF1nd/sing-box-1.14.0-beta.3-reF1nd-darwin-amd64.tar.gz"
      sha256 "10be66623d693e752f35a16f12fa5ecd1fe3abe19b9ef5d43e46335a045af6f0"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.3-reF1nd/sing-box-1.14.0-beta.3-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "1613df103d06de4ad51d2fb0f268fe4e9e3d7f17585ed02adcc3d8bd90bdef0f"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.3-reF1nd/sing-box-1.14.0-beta.3-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "4e904e6e3377a2c346159b93c455d5b845b4d2c6e1b02fe9e792c3f514bf2ede"
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
