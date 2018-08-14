#!/bin/bash

python assetsUpdate_release/createAssetsUpdate.py

python assetsUpdate_release/updateConfig.py

sh crypto.sh