{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ddosify";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-90qC0oWUC2nHDbTZsoDeiKuoHVl3YGRyFm0qj42DnOA=";
  };

  vendorSha256 = "sha256-mq82KNa01gHvW+RUREra+ysaJ1YWIwX0v/uYMxmFN4M=";

  ldflags = [
    "-s" "-w"
    "-X main.GitVersion=${version}"
    "-X main.GitCommit=unknown"
    "-X main.BuildDate=unknown"
  ];

  # TestCreateHammerMultipartPayload error occurred - Get "https://upload.wikimedia.org/wikipedia/commons/b/bd/Test.svg"
  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/ddosify -version | grep ${version} > /dev/null
  '';

  meta = with lib; {
    description = "High-performance load testing tool, written in Golang";
    homepage = "https://ddosify.com/";
    changelog = "https://github.com/ddosify/ddosify/releases/tag/v${version}";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ bryanasdev000 ];
  };
}
