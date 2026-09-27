class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.9-reF1nd/sing-box-1.15.0-alpha.9-reF1nd-darwin-arm64.tar.gz"
      sha256 "648f058550ec38fac59910d8c364f5271d1c976946e44b4014ff38b3acd394a7"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.9-reF1nd/sing-box-1.15.0-alpha.9-reF1nd-darwin-amd64.tar.gz"
      sha256 "d980a35059d2b657f8c27d8d6a3da62bc874005a24c85c8645c2cdf11b5f66a2"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.9-reF1nd/sing-box-1.15.0-alpha.9-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "09c160b0a3934828e64f573e75527494f5beaa173fcb6f0daa660851218445c8"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.9-reF1nd/sing-box-1.15.0-alpha.9-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "b9773581ad0583c996298ee2db666654969c95c4924ff8a45c7f88042a0b726e"
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
