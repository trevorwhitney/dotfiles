{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "switchyard-server";
  version = "0.2.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-jb56/vjZ4cHKTASa6T8KiRpiJ72RYGS3Okr0smTTqBk=";
  };

  cargoHash = "sha256-EfrdczEoDUWM3xwszIviLck6HDOn33uzg1m0itaC26I=";

  # Network-dependent tests cannot run in the sandbox
  doCheck = false;

  meta = with lib; {
    description = "LLM proxy that routes requests across providers and translates between OpenAI and Anthropic APIs";
    homepage = "https://github.com/NVIDIA-NeMo/Switchyard";
    license = licenses.asl20;
    maintainers = with maintainers; [ trevorwhitney ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
