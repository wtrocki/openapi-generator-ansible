#!/usr/bin/env bash

# generates an API client for the given OpenAPI spec file
generate_sdk() {
    local oas_file_name=$1
    local output_path=$2
    local package_name=$3
     
    # echo "Validating OpenAPI ${oas_file_name}"
    # npx @openapitools/openapi-generator-cli validate -i "$oas_file_name"

    echo "Generating source code based on ${oas_file_name}"

    # remove old generated models
    rm -Rf $OUTPUT_PATH

    echo "Generating SDK"
    npx @openapitools/openapi-generator-cli generate -g python -i\
        $oas_file_name -o $output_path \
        --package-name="$package_name" \
        --ignore-file-override=.openapi-generator-ignore \
        --template-dir ./.templates/python \
        --package-name=$package_name

}

OPENAPI_FILENAME=".openapi/kas-fleet-manager.yaml"
PACKAGE_NAME="module"
OUTPUT_PATH="build/generated"

generate_sdk $OPENAPI_FILENAME $OUTPUT_PATH $PACKAGE_NAME

mkdir -p build/ansible/plugins/module
cp build/generated/module/api/* build/ansible/plugins/module
cp build/generated/requirements.txt build/ansible/requirements.txt
rm -Rf build/generated