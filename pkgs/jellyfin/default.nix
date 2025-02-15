{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  fontconfig,
  freetype,
  jellyfin-ffmpeg,
  jellyfin-web,
  sqlite,
}: let
  pname = "jellyfin";
  version = "10.10.5";
in
  buildDotnetModule rec {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "Veraticus";
      repo = pname;
      rev = "d939b71b35edf67dd781d801702b5b213677e8d0";
      hash = "sha256-KSUoNiZ7oaS9XndL2g1vLEqZNs/nuhc2mZnDRCbe32c=";
    };

    propagatedBuildInputs = [
      sqlite
    ];

    projectFile = "Jellyfin.Server/Jellyfin.Server.csproj";
    executables = ["jellyfin"];
    nugetDeps = ./nuget-deps.json;
    runtimeDeps = [
      fontconfig
      freetype
      jellyfin-ffmpeg
      jellyfin-web
    ];
    dotnet-sdk = dotnetCorePackages.sdk_9_0;
    dotnet-runtime = dotnetCorePackages.aspnetcore_9_0;
    dotnetBuildFlags = ["--no-self-contained"];

    postInstall = ''
      mkdir -p $out/lib/jellyfin/jellyfin-web
      cp -r ${jellyfin-web}/share/jellyfin-web/* $out/lib/jellyfin/jellyfin-web/
    '';

    passthru.updateScript = ./update.sh;

    meta = {
      description = "The Free Software Media System";
      homepage = "https://jellyfin.org/";
      # https://github.com/jellyfin/jellyfin/issues/610#issuecomment-537625510
      license = lib.licenses.gpl2Plus;
      mainProgram = "jellyfin";
      platforms = dotnet-runtime.meta.platforms;
    };
  }
