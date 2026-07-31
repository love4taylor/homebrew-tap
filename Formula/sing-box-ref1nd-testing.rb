class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.4-reF1nd/sing-box-1.14.0-beta.4-reF1nd-darwin-arm64.tar.gz"
      sha256 "ee1b4b04f62787e2380cdb27daa47a04df7c80d485f9216a839c1454b9c5cd1c"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.4-reF1nd/sing-box-1.14.0-beta.4-reF1nd-darwin-amd64.tar.gz"
      sha256 "ea2e2e0055f5cfc64e6ec0963908fb8ce2d773342730bf4114f9936801655d33"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.4-reF1nd/sing-box-1.14.0-beta.4-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "1ae38b05f7225d0bed3f830294aba69698a4b08535d67db918d826ba047b5c7c"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.4-reF1nd/sing-box-1.14.0-beta.4-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "a1cb85e99e4426dea66b6d90a550e4ed5b1220389daa24ba7ab641a46370b699"
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
