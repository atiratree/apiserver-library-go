#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE}")/lib/init.sh"

SCRIPT_ROOT=$(dirname ${BASH_SOURCE})/..
CODEGEN_PKG=${CODEGEN_PKG:-$(cd ${SCRIPT_ROOT}; ls -d -1 ./vendor/k8s.io/code-generator 2>/dev/null || echo ../../../k8s.io/code-generator)}

GOFLAGS="" go install ./${CODEGEN_PKG}/cmd/deepcopy-gen

function codegen::join() { local IFS="$1"; shift; echo "$*"; }
function codegen::join_with_space() { local IFS=" "; shift; echo "$*"; }

# enumerate group versions
ALL_FQ_APIS=(
    github.com/openshift/apiserver-library-go/pkg/admission/imagepolicy/apis/imagepolicy/v1
)

echo "Generating deepcopy funcs"
${GOPATH}/bin/deepcopy-gen $(codegen::join_with_space , "${ALL_FQ_APIS[@]}") --output-file zz_generated.deepcopy.go --bounding-dirs $(codegen::join , "${ALL_FQ_APIS[@]}") --go-header-file ${SCRIPT_ROOT}/hack/boilerplate.txt "$@"
