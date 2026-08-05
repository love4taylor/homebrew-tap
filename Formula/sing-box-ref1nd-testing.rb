class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.7-reF1nd/sing-box-1.14.0-beta.7-reF1nd-darwin-arm64.tar.gz"
      sha256 "d4829275f20fb7694748e84ca97e56a76b47c8b91348003d21559ec327051ffb"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.7-reF1nd/sing-box-1.14.0-beta.7-reF1nd-darwin-amd64.tar.gz"
      sha256 "58d096695361246d1afacd7290ae6b496a6e6887d00d0011db1b500e2d49dff2"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.7-reF1nd/sing-box-1.14.0-beta.7-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "18975fce6fdb9142077bd8067354d7543ba5262847d542a39c46eba9f5d03671"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.7-reF1nd/sing-box-1.14.0-beta.7-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "3ededde32ed1223b767e68ae7d7c21e3a706ea72596ae2e76c39ec4cfdeb3d09"
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
