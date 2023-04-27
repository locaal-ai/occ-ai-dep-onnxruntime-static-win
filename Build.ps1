if (Test-Path prefix) {
  Remove-Item prefix -Recurse -Force
}
New-Item prefix\bin -ItemType Directory -Force
New-Item prefix\include -ItemType Directory -Force
New-Item prefix\lib -ItemType Directory -Force

if (Test-Path onnxruntime-static-win.zip) {
  Remove-Item onnxruntime-static-win.zip -Force
}

python onnxruntime\tools\ci_build\build.py --cmake_generator "Visual Studio 17 2022" --build_dir build --config Release --parallel --skip_tests --skip_submodule_sync --use_dml

$binArray =
  "build\packages\Microsoft.AI.DirectML.1.10.1\bin\x64-win\DirectML.dll",
  "build\packages\Microsoft.AI.DirectML.1.10.1\bin\x64-win\DirectML.lib"

$includeArray =
  "onnxruntime\include\onnxruntime\core\framework\provider_options.h",
  "onnxruntime\include\onnxruntime\core\providers\cpu\cpu_provider_factory.h",
  "onnxruntime\include\onnxruntime\core\providers\dml\dml_provider_factory.h",
  "onnxruntime\include\onnxruntime\core\session\onnxruntime_c_api.h",
  "onnxruntime\include\onnxruntime\core\session\onnxruntime_cxx_api.h",
  "onnxruntime\include\onnxruntime\core\session\onnxruntime_cxx_inline.h",
  "onnxruntime\include\onnxruntime\core\session\onnxruntime_run_options_config_keys.h",
  "onnxruntime\include\onnxruntime\core\session\onnxruntime_session_options_config_keys.h"

$libArray =
  "build\Release\_deps\abseil_cpp-build\absl\base\Release\absl_throw_delegate.lib",
  "build\Release\_deps\abseil_cpp-build\absl\container\Release\absl_raw_hash_set.lib",
  "build\Release\_deps\abseil_cpp-build\absl\hash\Release\absl_city.lib",
  "build\Release\_deps\abseil_cpp-build\absl\hash\Release\absl_hash.lib",
  "build\Release\_deps\abseil_cpp-build\absl\hash\Release\absl_low_level_hash.lib",
  "build\Release\_deps\onnx-build\Release\onnx_proto.lib",
  "build\Release\_deps\onnx-build\Release\onnx.lib",
  "build\Release\_deps\protobuf-build\Release\libprotobuf-lite.lib",
  "build\Release\_deps\re2-build\Release\re2.lib",
  "build\Release\Release\onnxruntime_common.lib",
  "build\Release\Release\onnxruntime_flatbuffers.lib",
  "build\Release\Release\onnxruntime_framework.lib",
  "build\Release\Release\onnxruntime_graph.lib",
  "build\Release\Release\onnxruntime_mlas.lib",
  "build\Release\Release\onnxruntime_optimizer.lib",
  "build\Release\Release\onnxruntime_providers_dml.lib",
  "build\Release\Release\onnxruntime_providers_shared.lib",
  "build\Release\Release\onnxruntime_providers.lib",
  "build\Release\Release\onnxruntime_session.lib",
  "build\Release\Release\onnxruntime_util.lib"

foreach ($bin in $binArray) {
    Copy-Item $bin prefix\bin -Verbose
}

foreach ($include in $includeArray) {
    Copy-Item $include prefix\include -Verbose
}

foreach ($lib in $libArray) {
    Copy-Item $lib prefix\lib -Verbose
}

Compress-Archive prefix\* onnxruntime-static-win.zip -Verbose
