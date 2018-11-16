# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

7z x -y windows_package.7z
$env:MXNET_LIBRARY_PATH=join-path $pwd.Path build\libmxnet.dll
$env:PYTHONPATH=join-path $pwd.Path python
$env:Path += ";$PATH;C:\Program Files\OpenBLAS-v0.2.19\bin;C:\Program Files\OpenCV-v3.4.1\build\x64\vc14\bin;C:\Program Files\mingw64_dll;C:\Program Files (x86)\Windows Kits\10\bin\10.0.16299.0\x86"
$env:MXNET_STORAGE_FALLBACK_LOG_VERBOSE=0
C:\Python37\Scripts\pip install -r tests\requirements.txt
C:\Python37\python.exe -m nose -v --with-xunit --xunit-file nosetests_unittest.xml tests\python\unittest
if (! $?) { Throw ("Error running unittest") }
C:\Python37\python.exe-m nose -v --with-xunit --xunit-file nosetests_train.xml tests\python\train
if (! $?) { Throw ("Error running train tests") }
