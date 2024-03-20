#!/bin/bash
# -----------------------------------------------------------------------------
# index.mdファイル作成シェル(Mac/Linux用)
#
#【機能概要】
# docsディレクトリ配下のファイル・ディレクトリ一覧が記載されたindex.mdファイルを
# 各階層ごとに生成する。
#
# 更新日           内容
# @(#)2023.02.18  新規作成
#
# -----------------------------------------------------------------------------
CONTENTS_TMP=".contents.tmp"
INDEX_FILE_NAME="index.md"
BASE_URL="$3"

# パラメータ一覧作成
DOCS_DIR="docs/$1/$2"
GHPAGES_DIR="$1/$2"

ls ${DOCS_DIR} >| ${CONTENTS_TMP}

echo "# ${GHPAGES_DIR} パラメータ一覧" >| ${DOCS_DIR}/${INDEX_FILE_NAME}
echo "" >> ${DOCS_DIR}/${INDEX_FILE_NAME}

while read PARAM_FILE_NAME
do
  if [ "${PARAM_FILE_NAME}" = "${INDEX_FILE_NAME}" ]; then
    continue
  fi

  PARAM_FILE_NAME_HTML=$(echo ${PARAM_FILE_NAME} | sed -e "s/\.md$/.html/g")
  echo "- [${PARAM_FILE_NAME}](${BASE_URL}${GHPAGES_DIR}/${PARAM_FILE_NAME_HTML})" >> ${DOCS_DIR}/${INDEX_FILE_NAME}
done < ${CONTENTS_TMP}

rm -f ${CONTENTS_TMP}

# 環境一覧作成
DOCS_DIR="docs/$1"
GHPAGES_DIR="$1"

ls ${DOCS_DIR} >| ${CONTENTS_TMP}

echo "# ${GHPAGES_DIR} パラメータ一覧" >| ${DOCS_DIR}/${INDEX_FILE_NAME}
echo "## ${GHPAGES_DIR} 環境一覧" >> ${DOCS_DIR}/${INDEX_FILE_NAME}
echo "" >> ${DOCS_DIR}/${INDEX_FILE_NAME}

while read PARAM_FILE_NAME
do
  if [ "${PARAM_FILE_NAME}" = "${INDEX_FILE_NAME}" ]; then
    continue
  fi

  PARAM_FILE_NAME_HTML=$(echo ${PARAM_FILE_NAME}/${INDEX_FILE_NAME} | sed -e "s/\.md$/.html/g")
  echo "- [${PARAM_FILE_NAME}](${BASE_URL}${GHPAGES_DIR}/${PARAM_FILE_NAME_HTML})" >> ${DOCS_DIR}/${INDEX_FILE_NAME}
done < ${CONTENTS_TMP}

rm -f ${CONTENTS_TMP}

# 基盤一覧作成
DOCS_DIR="docs"
GHPAGES_DIR=""
SYSTEM_NAME="$4"

ls ${DOCS_DIR} >| ${CONTENTS_TMP}

echo "# ${SYSTEM_NAME} パラメータ一覧" >| ${DOCS_DIR}/${INDEX_FILE_NAME}
echo "## ${SYSTEM_NAME} 基盤一覧" >> ${DOCS_DIR}/${INDEX_FILE_NAME}
echo "" >> ${DOCS_DIR}/${INDEX_FILE_NAME}

while read PARAM_FILE_NAME
do
  if [ "${PARAM_FILE_NAME}" = "${INDEX_FILE_NAME}" ]; then
    continue
  fi

  PARAM_FILE_NAME_HTML=$(echo ${PARAM_FILE_NAME}/${INDEX_FILE_NAME} | sed -e "s/\.md$/.html/g")
  echo "- [${PARAM_FILE_NAME}](${BASE_URL}${PARAM_FILE_NAME_HTML})" >> ${DOCS_DIR}/${INDEX_FILE_NAME}
done < ${CONTENTS_TMP}

rm -f ${CONTENTS_TMP}
