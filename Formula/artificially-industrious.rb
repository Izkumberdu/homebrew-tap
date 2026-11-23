class ArtificiallyIndustrious < Formula
  desc "Keeps Teams and Slack Available while your AI tool is still working"
  homepage "https://github.com/Izkumberdu/artificially-industrious"
  url "https://github.com/Izkumberdu/artificially-industrious/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "90b3d7e2741d1bc20b54d6b44210f778e50cd2a67b403f5b88bb90d6e9bbf398"
  license "MIT"

  depends_on :macos
  depends_on "node"

  def install
    libexec.install "bin", "src", "helper", "scripts", "package.json"
    # The stable opt path keeps AI-tool hooks working across brew upgrades.
    (bin/"industrious").write <<~SH
      #!/bin/bash
      export INDUSTRIOUS_BIN="#{opt_bin}/industrious"
      exec "#{formula_opt_bin("node")}/node" "#{opt_libexec}/bin/industrious.js" "$@"
    SH
  end

  def caveats
    <<~EOS
      Finish setup (needs the Xcode Command Line Tools: xcode-select --install):
        industrious install helper
        industrious permission
        industrious install claude --write    # or copilot / cursor

      Before brew uninstall, run industrious uninstall to remove the hooks.
    EOS
  end

  test do
    assert_match "Artificially Industrious", shell_output("#{bin}/industrious help")
  end
end
