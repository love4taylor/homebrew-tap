class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.33-reF1nd/sing-box-1.14.0-alpha.33-reF1nd-darwin-arm64.tar.gz"
      sha256 "dd18d8c78eea9a9b3e29086b3fc11e49f1faa7b1ec92a8710089524c47ba0a57"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.33-reF1nd/sing-box-1.14.0-alpha.33-reF1nd-darwin-amd64.tar.gz"
      sha256 "d6884b14624cf82085792e393f0559511c86dde9ca708aa3a8de0d0fd0b32f79"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.33-reF1nd/sing-box-1.14.0-alpha.33-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "f8474364c530b548e3f0795700dcb977c1398ce12e7b0b6ada6303909d9910a2"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-alpha.33-reF1nd/sing-box-1.14.0-alpha.33-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "1819b865caaf4529dae3c908503cd545740e8372a5d6780c120478db7204bb93"
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
