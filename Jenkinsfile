// -*- mode: groovy -*-

// Licensed to the Apache Software Foundation (ASF) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
//
// Jenkins pipeline
// See documents at https://jenkins.io/doc/book/pipeline/jenkinsfile/

// mxnet libraries
mx_lib = 'lib/libmxnet.so, lib/libmxnet.a, 3rdparty/dmlc-core/libdmlc.a, 3rdparty/tvm/nnvm/lib/libnnvm.a'

// Python wheels
mx_pip = 'build/*.whl'

// for scala build, need to pass extra libs when run with dist_kvstore
mx_dist_lib = 'lib/libmxnet.so, lib/libmxnet.a, 3rdparty/dmlc-core/libdmlc.a, 3rdparty/tvm/nnvm/lib/libnnvm.a, 3rdparty/ps-lite/build/libps.a, deps/lib/libprotobuf-lite.a, deps/lib/libzmq.a'
// mxnet cmake libraries, in cmake builds we do not produce a libnvvm static library by default.
mx_cmake_lib = 'build/libmxnet.so, build/libmxnet.a, build/3rdparty/dmlc-core/libdmlc.a, build/tests/mxnet_unit_tests, build/3rdparty/openmp/runtime/src/libomp.so'
// mxnet cmake libraries, in cmake builds we do not produce a libnvvm static library by default.
mx_cmake_lib_debug = 'build/libmxnet.so, build/libmxnet.a, build/3rdparty/dmlc-core/libdmlc.a, build/tests/mxnet_unit_tests'
mx_cmake_mkldnn_lib = 'build/libmxnet.so, build/libmxnet.a, build/3rdparty/dmlc-core/libdmlc.a, build/tests/mxnet_unit_tests, build/3rdparty/openmp/runtime/src/libomp.so, build/3rdparty/mkldnn/src/libmkldnn.so.0'
mx_mkldnn_lib = 'lib/libmxnet.so, lib/libmxnet.a, lib/libiomp5.so, lib/libmkldnn.so.0, lib/libmklml_intel.so, 3rdparty/dmlc-core/libdmlc.a, 3rdparty/tvm/nnvm/lib/libnnvm.a'
mx_tensorrt_lib = 'lib/libmxnet.so, lib/libnvonnxparser_runtime.so.0, lib/libnvonnxparser.so.0, lib/libonnx_proto.so, lib/libonnx.so'
mx_lib_cpp_examples = 'lib/libmxnet.so, lib/libmxnet.a, 3rdparty/dmlc-core/libdmlc.a, 3rdparty/tvm/nnvm/lib/libnnvm.a, 3rdparty/ps-lite/build/libps.a, deps/lib/libprotobuf-lite.a, deps/lib/libzmq.a, build/cpp-package/example/lenet, build/cpp-package/example/alexnet, build/cpp-package/example/googlenet, build/cpp-package/example/lenet_with_mxdataiter, build/cpp-package/example/resnet, build/cpp-package/example/mlp, build/cpp-package/example/mlp_cpu, build/cpp-package/example/mlp_gpu, build/cpp-package/example/test_score, build/cpp-package/example/test_optimizer'
mx_lib_cpp_examples_cpu = 'build/libmxnet.so, build/cpp-package/example/mlp_cpu'

// timeout in minutes
max_time = 120


// Python unittest for CPU
// Python 2
def python2_ut(docker_container_name) {
  timeout(time: max_time, unit: 'MINUTES') {
    utils.docker_run(docker_container_name, 'unittest_ubuntu_python2_cpu', false)
  }
}

// Python 3
def python3_ut(docker_container_name) {
  timeout(time: max_time, unit: 'MINUTES') {
    utils.docker_run(docker_container_name, 'unittest_ubuntu_python3_cpu', false)
  }
}

// Python 3
def python3_ut_asan(docker_container_name) {
  timeout(time: max_time, unit: 'MINUTES') {
    utils.docker_run(docker_container_name, 'unittest_ubuntu_python3_cpu_asan', false)
  }
}

def python3_ut_mkldnn(docker_container_name) {
  timeout(time: max_time, unit: 'MINUTES') {
    utils.docker_run(docker_container_name, 'unittest_ubuntu_python3_cpu_mkldnn', false)
  }
}

// GPU test has two parts. 1) run unittest on GPU, 2) compare the results on
// both CPU and GPU
// Python 2
def python2_gpu_ut(docker_container_name) {
  timeout(time: max_time, unit: 'MINUTES') {
    utils.docker_run(docker_container_name, 'unittest_ubuntu_python2_gpu', true)
  }
}

// Python 3
def python3_gpu_ut(docker_container_name) {
  timeout(time: max_time, unit: 'MINUTES') {
    utils.docker_run(docker_container_name, 'unittest_ubuntu_python3_gpu', true)
  }
}

// Python 3 NOCUDNN
def python3_gpu_ut_nocudnn(docker_container_name) {
  timeout(time: max_time, unit: 'MINUTES') {
    utils.docker_run(docker_container_name, 'unittest_ubuntu_python3_gpu_nocudnn', true)
  }
}

def deploy_docs() {
  parallel 'Docs': {
    node(NODE_LINUX_CPU) {
      ws('workspace/docs') {
        timeout(time: max_time, unit: 'MINUTES') {
          utils.init_git()
          utils.docker_run('ubuntu_cpu', 'deploy_docs', false)
          sh "ci/other/ci_deploy_doc.sh ${env.BRANCH_NAME} ${env.BUILD_NUMBER}"
        }
      }
    }
  },
  'Julia docs': {
    node(NODE_LINUX_CPU) {
      ws('workspace/julia-docs') {
        timeout(time: max_time, unit: 'MINUTES') {
          utils.unpack_and_init('cpu', mx_lib)
          utils.docker_run('ubuntu_cpu', 'deploy_jl_docs', false)
        }
      }
    }
  }
}

node('mxnetlinux-cpu') {
  // Loading the utilities requires a node context unfortunately
  checkout scm
  utils = load('ci/Jenkinsfile_utils.groovy')
}
utils.assign_node_labels(linux_cpu: 'mxnetlinux-cpu', linux_gpu: 'mxnetlinux-gpu', linux_gpu_p3: 'mxnetlinux-gpu-p3', windows_cpu: 'new-mxnetwindows-cpu', windows_gpu: 'new-mxnetwindows-gpu')

utils.main_wrapper(
core_logic: {
  stage('Build') {
    parallel 'Build CPU windows':{
      node(NODE_WINDOWS_CPU) {
        timeout(time: max_time, unit: 'MINUTES') {
          ws('workspace/build-cpu') {
            utils.init_git_win()
            powershell 'python ci/build_windows.py -f WIN_CPU'
            stash includes: 'windows_package.7z', name: 'windows_package_cpu'
          }
        }
      }
    },

    'Build GPU windows':{
      node(NODE_WINDOWS_CPU) {
        timeout(time: max_time, unit: 'MINUTES') {
          ws('workspace/build-gpu') {
            utils.init_git_win()
            powershell 'python ci/build_windows.py -f WIN_GPU'
            stash includes: 'windows_package.7z', name: 'windows_package_gpu'
          }
        }
      }
    },
    'Build GPU MKLDNN windows':{
      node(NODE_WINDOWS_CPU) {
        timeout(time: max_time, unit: 'MINUTES') {
          ws('workspace/build-gpu') {
            utils.init_git_win()
            powershell 'python ci/build_windows.py -f WIN_GPU_MKLDNN'
            stash includes: 'windows_package.7z', name: 'windows_package_gpu_mkldnn'
          }
        }
      }
    }
  } // End of stage('Build')

  stage('Tests') {
    parallel 'Python 2: CPU Win':{
      node(NODE_WINDOWS_CPU) {
        timeout(time: max_time, unit: 'MINUTES') {
          ws('workspace/ut-python-cpu') {
            try {
              utils.init_git_win()
              unstash 'windows_package_cpu'
              powershell 'ci/windows/test_py2_cpu.ps1'
            } finally {
              utils.collect_test_results_windows('nosetests_unittest.xml', 'nosetests_unittest_windows_python2_cpu.xml')
            }
          }
        }
      }
    },
    'Python 3: CPU Win': {
      node(NODE_WINDOWS_CPU) {
        timeout(time: max_time, unit: 'MINUTES') {
          ws('workspace/ut-python-cpu') {
            try {
              utils.init_git_win()
              unstash 'windows_package_cpu'
              powershell 'ci/windows/test_py3_cpu.ps1'
            } finally {
              utils.collect_test_results_windows('nosetests_unittest.xml', 'nosetests_unittest_windows_python3_cpu.xml')
            }
          }
        }
      }
    },
    'Python 2: GPU Win':{
      node(NODE_WINDOWS_GPU) {
        timeout(time: max_time, unit: 'MINUTES') {
          ws('workspace/ut-python-gpu') {
            try {
              utils.init_git_win()
              unstash 'windows_package_gpu'
              powershell 'ci/windows/test_py2_gpu.ps1'
            } finally {
              utils.collect_test_results_windows('nosetests_forward.xml', 'nosetests_gpu_forward_windows_python2_gpu.xml')
              utils.collect_test_results_windows('nosetests_operator.xml', 'nosetests_gpu_operator_windows_python2_gpu.xml')
            }
          }
        }
      }
    },
    'Python 3: GPU Win':{
      node(NODE_WINDOWS_GPU) {
        timeout(time: max_time, unit: 'MINUTES') {
          ws('workspace/ut-python-gpu') {
            try {
              utils.init_git_win()
              unstash 'windows_package_gpu'
              powershell 'ci/windows/test_py3_gpu.ps1'
            } finally {
              utils.collect_test_results_windows('nosetests_forward.xml', 'nosetests_gpu_forward_windows_python3_gpu.xml')
              utils.collect_test_results_windows('nosetests_operator.xml', 'nosetests_gpu_operator_windows_python3_gpu.xml')
            }
          }
        }
      }
    },
    'Python 3: MKLDNN-GPU Win':{
      node(NODE_WINDOWS_GPU) {
        timeout(time: max_time, unit: 'MINUTES') {
          ws('workspace/ut-python-gpu') {
            try {
              utils.init_git_win()
              unstash 'windows_package_gpu_mkldnn'
              powershell 'ci/windows/test_py3_gpu.ps1'
            } finally {
              utils.collect_test_results_windows('nosetests_forward.xml', 'nosetests_gpu_forward_windows_python3_gpu_mkldnn.xml')
              utils.collect_test_results_windows('nosetests_operator.xml', 'nosetests_gpu_operator_windows_python3_gpu_mkldnn.xml')
            }
          }
        }
      }
    }
  }
}
,
failure_handler: {
  // Only send email if master or release branches failed
  if (currentBuild.result == "FAILURE" && (env.BRANCH_NAME == "master" || env.BRANCH_NAME.startsWith("v"))) {
    emailext body: 'Build for MXNet branch ${BRANCH_NAME} has broken. Please view the build at ${BUILD_URL}', replyTo: '${EMAIL}', subject: '[BUILD FAILED] Branch ${BRANCH_NAME} build ${BUILD_NUMBER}', to: '${EMAIL}'
  }
}
)
