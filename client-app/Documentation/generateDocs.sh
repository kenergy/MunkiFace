#!/bin/bash
BASE_DIR=`dirname "${0}"`
TMP_DOX_FILE="${BASE_DIR}/tmp"
cp "${BASE_DIR}/Cappuccino.doxygen" "${TMP_DOX_FILE}"


echo "INPUT = ${BASE_DIR}/../" >> "${TMP_DOX_FILE}"
echo "PROJECT_LOGO = ${BASE_DIR}/logo.png" >> "${TMP_DOX_FILE}"
echo "OUTPUT_DIRECTORY = "${BASE_DIR}/ >> "${TMP_DOX_FILE}"

doxygen "${TMP_DOX_FILE}"
rm -rf "${TMP_DOX_FILE}"
