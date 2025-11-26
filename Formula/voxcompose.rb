class Voxcompose < Formula
  desc "Markdown refiner for speech transcripts (CLI)"
  homepage "https://github.com/cliffmin/voxcompose"
  url "https://github.com/cliffmin/voxcompose/releases/download/v0.4.4/voxcompose-cli-0.4.4-all.jar"
  sha256 "eb6c3c3152d9a286a69e20ae6ebac6d801095538ec12199e6ee5b96eb736655a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "openjdk@21"

  def install
    libexec.install "voxcompose-cli-0.4.4-all.jar"
    (bin/"voxcompose").write <<~EOS
      #!/usr/bin/env bash
      exec "#{Formula["openjdk@21"].opt_bin}/java" -jar "#{libexec}/voxcompose-cli-0.4.4-all.jar" "$@"
    EOS
    chmod 0555, (bin/"voxcompose")
  end

  def caveats
    <<~EOS
      VoxCompose requires Ollama for LLM refinement:

        brew install ollama
        ollama serve &
        ollama pull llama3.1

      Test: echo "pushto github" | voxcompose

      For VoxCore integration, edit ~/.hammerspoon/ptt_config.lua:
        LLM_REFINER = { ENABLED = true, CMD = { "#{opt_bin}/voxcompose" }, ... }
    EOS
  end

  test do
    output = shell_output("#{bin}/voxcompose --version 2>&1")
    assert_match "0.4.4", output
  end
end

