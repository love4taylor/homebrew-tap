class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd fork)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  version "1.14.0"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-reF1nd/sing-box-1.14.0-reF1nd-darwin-arm64.tar.gz"
      sha256 "5b754ebd4c6cb82dd20fb406b16c6050284a67a8f422fb539686df5e62e47577"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-reF1nd/sing-box-1.14.0-reF1nd-darwin-amd64.tar.gz"
      sha256 "fa70466ec5ee42f26ec0c8fa7afe8f37520e86b7c189937928183566b27bbe0d"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-reF1nd/sing-box-1.14.0-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "d9939db25eee1179e7f5e9e2cb843b6052bea58b472b257e6d2d628475f9ca03"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-reF1nd/sing-box-1.14.0-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "e4beeb36625b9136229b3d2e39c53a69eebb3dc20e60bc66ede584701b34ebd7"
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
