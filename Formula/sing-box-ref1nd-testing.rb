class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.13-reF1nd/sing-box-1.14.0-beta.13-reF1nd-darwin-arm64.tar.gz"
      sha256 "eea8d581e7dca54502a83f7c38ab8d1b4ae909011cbc6b7ccf178de41922178c"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.13-reF1nd/sing-box-1.14.0-beta.13-reF1nd-darwin-amd64.tar.gz"
      sha256 "f39aaf69d52444b07986533d7a846f75cdcf37d4c0b42dbb9e0a8bc0d4484495"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.13-reF1nd/sing-box-1.14.0-beta.13-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "4a3e180b4a076af991222148ebe30b13ebcd323e99cef1a2d0c33bb2c7833afe"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.13-reF1nd/sing-box-1.14.0-beta.13-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "5a63ec824e15f40edff002fce03fe709cae0f5a990fe9a36e650c219ac49e746"
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
