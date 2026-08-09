class SingBoxRef1ndTesting < Formula
  desc "Universal proxy platform (reF1nd fork, testing releases)"
  homepage "https://github.com/reF1nd/sing-box/tree/reF1nd-testing"
  license "GPL-3.0-or-later"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.12-reF1nd/sing-box-1.14.0-beta.12-reF1nd-darwin-arm64.tar.gz"
      sha256 "5150cc02b8c9cfd8849e94f760109c441b4ef21c94a2874276567b9b613cfbf6"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.12-reF1nd/sing-box-1.14.0-beta.12-reF1nd-darwin-amd64.tar.gz"
      sha256 "99945430879a6c661936151d10ceebc4e4c0414700df1a8478a8da3543d0dfa6"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.12-reF1nd/sing-box-1.14.0-beta.12-reF1nd-linux-arm64-musl.tar.gz"
      sha256 "9a14807284c2b6612c3b781688201693a50fd8096561d202e50a4460f146d4a1"
    else
      url "https://github.com/reF1nd/sing-box-releases/releases/download/v1.14.0-beta.12-reF1nd/sing-box-1.14.0-beta.12-reF1nd-linux-amd64-musl.tar.gz"
      sha256 "b282a972a3345c5b92e1d3de55c7ab46d0d97897464276b0e76910bb3bbaf401"
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
