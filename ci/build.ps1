echo Test

git submodule init
git submodule update

$NOT_BROKEN_DEPS = @(
  "assimp", "binary_io", "bindbc-assimp", "bindbc-loader", "CommonLibSSE", "CommonLibSSEPre629", "Detours",
  "eternal", "fmt", "gfm", "glm", "intel-intrinsics", "json", "PolyHool_2_0", "skylib", "spdlog", "stl_interfaces",
  "xbyak"
)

foreach ($dep in $NOT_BROKEN_DEPS) {
  pushd "Deps\$dep"
  git submodule update --init --recursive
  popd
}
