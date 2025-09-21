class Voxcompose < Formula
  desc "Markdown refiner for speech transcripts (CLI)"
  homepage "https://github.com/cliffmin/voxcompose"
  url "https://github.com/cliffmin/voxcompose/releases/download/v0.4.3/voxcompose-cli-0.4.2-all.jar"
  sha256 "e5258c755f9ba2fbe35b909649022237ee33fa158e159710aa17e9bbe32082d7"
  license "MIT"

  depends_on "openjdk@21"

  def install
    libexec.install "voxcompose-cli-0.4.2-all.jar"
    (bin/"voxcompose").write <<~EOS
      #!/usr/bin/env bash
      exec "#{Formula["openjdk@21"].opt_bin}/java" -jar "#{libexec}/voxcompose-cli-0.4.2-all.jar" "$@"
    EOS
    chmod 0555, (bin/"voxcompose")
  end

  test do
    output = shell_output("#{bin}/voxcompose --version 2>&1")
    assert_match "0.4.2", output
  end
end

