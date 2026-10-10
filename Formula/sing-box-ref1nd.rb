class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd fork)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  version "1.14.3"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.3-reF1nd/sing-box-1.14.3-reF1nd-darwin-arm64.tar.gz"
      sha256 "d93245adb36bb9ee6457dcbdbaa503b1203610bf4e4094e5afdf9ff1666e9504"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.3-reF1nd/sing-box-1.14.3-reF1nd-darwin-amd64.tar.gz"
      sha256 "995235817dc7b982728d32a43f79894676802069a7a87292046453da625155c9"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.3-reF1nd/sing-box-1.14.3-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "bcc604ceda94ee6c916fdc3538eb49984427e3780abaa78b591a9ff140e0aa0b"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.3-reF1nd/sing-box-1.14.3-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "69641cf7d98ff89296e07b92e53e43e49632888bd2b934e7846a20de713c6de7"
    end
  end

  conflicts_with "sing-box-ref1nd-testing", because: "both install sing-box-ref1nd binary"

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
