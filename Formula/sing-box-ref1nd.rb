class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd fork)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  version "1.13.16"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.16-reF1nd/sing-box-1.13.16-reF1nd-darwin-arm64.tar.gz"
      sha256 "c4b81b6e0d9cd59148c36a69098ee58df57de9f153f41ea2e6cb31da1b423092"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.16-reF1nd/sing-box-1.13.16-reF1nd-darwin-amd64.tar.gz"
      sha256 "a54a69a38c80ce6cde517bceaba2896448be611108644b94e079f527a196c8e3"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.16-reF1nd/sing-box-1.13.16-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "a55906041dd14b7a16b1432368aae6394955a16548d6c6e4405c213d069ee92f"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.13.16-reF1nd/sing-box-1.13.16-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "31a2f86546c05a23d41ba9b4888a74fb2174f32ac60651edb0f1d942b7a9bd46"
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
