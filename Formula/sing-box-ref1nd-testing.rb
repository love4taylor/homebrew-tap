class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.8-reF1nd/sing-box-1.14.0-beta.8-reF1nd-darwin-arm64.tar.gz"
      sha256 "23060188c35b5298e846c7011a35851e6d6dccd7cb76892f0ee46224976a3455"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.8-reF1nd/sing-box-1.14.0-beta.8-reF1nd-darwin-amd64.tar.gz"
      sha256 "7a5ca3f8fecffb87cfb3b2708f20e0797d31cf2d33104153416e3f5541908602"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.8-reF1nd/sing-box-1.14.0-beta.8-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "5baaaa9e012a47e820becbe18b65617dc1d375254fef350e52a4412a71d1ee9a"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.8-reF1nd/sing-box-1.14.0-beta.8-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "aa423e99d1d611e769ee9e8405e911c5c13b669235fe403d1b49489abb211c86"
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
