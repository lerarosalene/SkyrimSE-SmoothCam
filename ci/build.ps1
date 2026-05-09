git config --global submodule.recurse false
git config submodule.recurse false

git submodule init
git submodule update

$NOT_BROKEN_DEPS = @(
  "assimp", "binary_io", "bindbc-loader", "CommonLibSSE", "CommonLibSSEPre629", "Detours",
  "eternal", "fmt", "gfm", "glm", "intel-intrinsics", "json", "PolyHook_2_0", "skylib", "spdlog", "stl_interfaces",
  "xbyak"
)

foreach ($dep in $NOT_BROKEN_DEPS) {
  pushd "Deps\$dep"
  git submodule update --init --recursive
  popd
}

choco install dub ldc -y
choco install python312 -y
choco install 7zip.install --pre -y
choco install zstandard -y

pwsh -File scripts/fetch-buck.ps1

mkdir build-out
./buck2/buck2 build --out build-out --config-file buck2/mode/release_pre629 :SmoothCamAE
./buck2/buck2 build --out build-out --config-file buck2/mode/release :SmoothCamAE
./buck2/buck2 build --out build-out --config-file buck2/mode/release :SmoothCamSSE

ls build-out

$VERSION = (Get-Content -Path "version.txt" -Raw).Trim()

gh release create "${VERSION}" --notes "Automatic release (DLL only, no assets, no PDB). For testing purposes only." -t "${VERSION}" build-out/SmoothCamAE.dll build-out/SmoothCamSSE.dll build-out/SmoothCamAEPre629.dll
