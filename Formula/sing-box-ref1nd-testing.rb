class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-rc.4-reF1nd/sing-box-1.14.0-rc.4-reF1nd-darwin-arm64.tar.gz"
      sha256 "315788baef9be714054e1c140b4b1c2eb5d4b63f45f66273f28214681ca90527"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-rc.4-reF1nd/sing-box-1.14.0-rc.4-reF1nd-darwin-amd64.tar.gz"
      sha256 "f5e7d4aaf4ac487c00128a01c5e581dfe011404b675b4c84d5d635b880b08d85"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-rc.4-reF1nd/sing-box-1.14.0-rc.4-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "046dc1f39f848a3e9d1e4a8df2e4b51431cb6fc8c73f9b9e9c52d8ca9e1888a0"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-rc.4-reF1nd/sing-box-1.14.0-rc.4-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "66dba6a4f1a403bbb378781339b51006e61988739b5a57e0864f0c5f038389b2"
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
