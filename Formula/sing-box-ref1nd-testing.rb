class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.2-reF1nd/sing-box-1.14.0-beta.2-reF1nd-darwin-arm64.tar.gz"
      sha256 "7e2b924eeb6a9844f76314ca88e8b8b3c0bb256096c042a7fbee9fa03af79c73"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.2-reF1nd/sing-box-1.14.0-beta.2-reF1nd-darwin-amd64.tar.gz"
      sha256 "a2d75ec1eedcd5614a45dab992f96ef087158f7fcb7194ac2cc96dcc09a7474d"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.2-reF1nd/sing-box-1.14.0-beta.2-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "833ac44d27e268d22e6f23a6d6b07340fd174c44d9e0e07aafb37710f96317dd"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.2-reF1nd/sing-box-1.14.0-beta.2-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "58b68739fd8500269a1550454b279f7b51fee4bd8e06cc2418bd868b99b77409"
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
