
python assetsUpdate_release/createAssetsUpdate.py

python assetsUpdate_release/updateConfig.py

sh crypto.sh

python ./frameworks/runtime-src/proj.android/build_native.py -b release


python assetsUpdate_release/apkReName.py