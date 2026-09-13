class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.3-reF1nd/sing-box-1.15.0-alpha.3-reF1nd-darwin-arm64.tar.gz"
      sha256 "dba42c71924f96926dd216ef327474dfa24c9ab08a77ef38f94188280967e367"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.3-reF1nd/sing-box-1.15.0-alpha.3-reF1nd-darwin-amd64.tar.gz"
      sha256 "2ec45ef4d30ce8910cb368c5d7150f4f8915ec5dae3c6c674e588a8587304fec"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.3-reF1nd/sing-box-1.15.0-alpha.3-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "e4003814f681a5a65c32df51c48ef0c3568877f25464bc00a942d1321815e106"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.3-reF1nd/sing-box-1.15.0-alpha.3-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "07501cf1636236ddb4ff82e6ec9dc01115e9de75d6dc48a35e253644fa325436"
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
