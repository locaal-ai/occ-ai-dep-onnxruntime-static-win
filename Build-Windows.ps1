Param($Configuration)

python onnxruntime\tools\ci_build\build.py --cmake_generator "Visual Studio 17 2022" --build_dir build --config $Configuration --parallel --skip_tests --skip_submodule_sync --use_dml

cmake --install build --config $Configuration --prefix release/$Configuration

Compress-Archive release\$Configuration\* release\opencv-windows-$Configuration.zip -Verbose
