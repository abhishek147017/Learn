{ pkgs, ... }: {
  channel = "stable-24.05";

  packages = [
    pkgs.jdk17
    pkgs.maven
    pkgs.go_1_21
    pkgs.nodejs_20
    pkgs.git
    pkgs.curl
    pkgs.wget
    pkgs.unzip
    pkgs.jq
    pkgs.tree
    pkgs.tmux
    pkgs.postgresql_15
  ];

  # DO NOT TOUCH PATH HERE
  env = {
    JAVA_HOME = "${pkgs.jdk17}";
    GOPATH = "$PWD/.go";
  };

  idx = {
    workspace = {
      onStart = {
        setup = ''
          export PATH="$PATH:$GOPATH/bin"

          echo "Environment ready"
          java -version
          mvn -v | head -n 1
          go version
          node -v
          psql --version
        '';
      };
    };
  };
}