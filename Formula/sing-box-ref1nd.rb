class SingBoxRef1nd < Formula
  desc "Universal proxy platform (reF1nd fork)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  version "1.14.1"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.1-reF1nd/sing-box-1.14.1-reF1nd-darwin-arm64.tar.gz"
      sha256 "db320138992aa2986070042ba8555fdc46c94a421ec10155aa0b747b4d3e87f2"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.1-reF1nd/sing-box-1.14.1-reF1nd-darwin-amd64.tar.gz"
      sha256 "340467ef1e94825e0ebbf89dd812e08cb9a16605d82ec951f3d7fdb2b29ead87"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.1-reF1nd/sing-box-1.14.1-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "d79cbf831ac82a9113455a08b4ff8e46799cfd5c19c9bb91d4117c37bb0be1f3"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.1-reF1nd/sing-box-1.14.1-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "6b9464b4fd4bcbf5f2820b7563b6ee1727850b703f3b06bc3cc8997eee4514ce"
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
