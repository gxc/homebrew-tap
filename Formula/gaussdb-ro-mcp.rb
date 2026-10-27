class GaussdbRoMcp < Formula
  desc "Read-only MCP server for Huawei GaussDB, built for coding agents"
  homepage "https://github.com/gxc/gaussdb-ro-mcp"
  version "0.3.0"
  license "Apache-2.0"

  releases_url = "https://github.com/gxc/gaussdb-ro-mcp/releases/download/v#{version}"

  # 版本号不带平台后缀的预编译单二进制；sha256 与 Release 页 SHA256SUMS.txt 一致，
  # 升级版本时同步替换（assets 由同一 CI 构建生成，文件名不含版本号）。
  on_macos do
    if Hardware::CPU.arm?
      url "#{releases_url}/gaussdb-ro-mcp-darwin-arm64"
      sha256 "a0bca523b3327cb1544f78eead6ea38f32bd448bb24fa484bdfd5c738badb2b8"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "#{releases_url}/gaussdb-ro-mcp-linux-amd64"
      sha256 "bb929917d69edc854c141dba9dbede684490b5935381e41b6a2e01f6a81ec844"
    elsif Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "#{releases_url}/gaussdb-ro-mcp-linux-arm64"
      sha256 "7e93ccf6927487f5d4642e08db2623493cf7a2f6a8c211c2b968dd43e6953b46"
    end
  end

  def install
    bin.install Dir["gaussdb-ro-mcp-*"].first => "gaussdb-ro-mcp"
    chmod 0755, bin/"gaussdb-ro-mcp"
  end

  def caveats
    <<~EOS
      A YAML config file is required. Register the server with your coding agent, e.g.:

        claude mcp add gaussdb-readonly -- #{opt_bin}/gaussdb-ro-mcp -config /path/to/gaussdb-ro-mcp.yaml

      See https://github.com/gxc/gaussdb-ro-mcp#readme for the config format.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gaussdb-ro-mcp --version")
  end
end
