{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "open-policy-agent";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "open-policy-agent";
    repo = "opa";
    rev = "v${version}";
    sha256 = "sha256-SUMTyqzeaCTj/fVdDHFZkh43t+mIFGNt6wendOt9gfw=";
  };
  vendorSha256 = null;

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" "-X github.com/open-policy-agent/opa/version.Version=${version}" ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/opa --help
    $out/bin/opa version | grep "Version: ${version}"
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://www.openpolicyagent.org";
    changelog = "https://github.com/open-policy-agent/opa/blob/v${version}/CHANGELOG.md";
    description = "General-purpose policy engine";
    longDescription = ''
      The Open Policy Agent (OPA, pronounced "oh-pa") is an open source, general-purpose policy engine that unifies
      policy enforcement across the stack. OPA provides a high-level declarative language that let’s you specify policy
      as code and simple APIs to offload policy decision-making from your software. You can use OPA to enforce policies
      in microservices, Kubernetes, CI/CD pipelines, API gateways, and more.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ lewo jk ];
  };
}
