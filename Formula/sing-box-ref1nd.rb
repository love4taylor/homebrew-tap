class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd fork)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  version "1.13.14"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.14-reF1nd/sing-box-1.13.14-reF1nd-darwin-arm64.tar.gz"
      sha256 "8253959e0ec926f5c612ae1e8965f9b005b1307c5a15e1a12fe785ad1b054939"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.14-reF1nd/sing-box-1.13.14-reF1nd-darwin-amd64.tar.gz"
      sha256 "51aaea5bf0cc5e8800618806ae0151cbc4fff35fdfa18aeb36d04e4faf25a9d4"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.14-reF1nd/sing-box-1.13.14-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "51458cf565dd8e4a65ab2a5f6e44e2acaaacc3ee520b3902f358ed2b7e15446d"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.14-reF1nd/sing-box-1.13.14-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "10b79e415c93ee913f961c478d0f90ea052ba52852e50071ebec478a5d2c4d45"
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
