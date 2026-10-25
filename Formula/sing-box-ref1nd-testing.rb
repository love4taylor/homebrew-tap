class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.13-reF1nd/sing-box-1.15.0-alpha.13-reF1nd-darwin-arm64.tar.gz"
      sha256 "54bb6a5634bd8b4c7d54c68204ceb70f2ed01d134d6905405e8b82368bc0545a"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.13-reF1nd/sing-box-1.15.0-alpha.13-reF1nd-darwin-amd64.tar.gz"
      sha256 "65f564e09bff803306ab89ea6ec4cbcc5943fdaf540474fd559b539c49f8db2e"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.13-reF1nd/sing-box-1.15.0-alpha.13-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "a7488e25fa1e07ddb7c290bcef6ce4d42d7e452e04eafd43ded96b8fe70a343a"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.15.0-alpha.13-reF1nd/sing-box-1.15.0-alpha.13-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "c99bf450be654c7ce6dcca569aee12f584711ae365e5660847ae2ecd285f8ecd"
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
