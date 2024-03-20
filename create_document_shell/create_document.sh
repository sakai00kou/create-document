#!/bin/bash
# -----------------------------------------------------------------------------
# AWSリソース情報取得シェル(Mac/Linux用)
#
#【機能概要】
# resourceディレクトリ配下の情報取得用リソースファイルを実行し、AWSの各種リソース情報一覧を
# outputディレクトリ配下に出力する。
#
# 更新日           内容
# @(#)2023.02.18  新規作成
#
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# 【環境変数】
# OS_TYPE         ：OS種別
# OVERWRITE_OPTION：sedコマンドのオプション
# RESOURCE_DIR    ：リソースファイル格納ディレクトリの指定
# FILETYPE        ：出力ファイル形式の指定（デフォルトMarkdown形式）
# OUTPUT_DIR      ：出力ファイル格納ディレクトリの指定
# CMDNAME         ：実行シェル名の指定
# CMDTMP          ：リソースリスト作成用tmpファイル
# -----------------------------------------------------------------------------
OS_TYPE=$(uname -s)
if [ ${OS_TYPE} == "Darwin" ]; then
  OVERWRITE_OPTION=".tmp"
else
  OVERWRITE_OPTION=""
fi

RESOURCE_DIR="./resource"
FILETYPE="md"
OUTPUT_DIR="./docs"
CMDNAME=${0##*/}
CMDTMP=.${CMDNAME}.tmp

# -----------------------------------------------------------------------------
# 【関数】
# -----------------------------------------------------------------------------
# USAGE用関数
function USAGE()
{
	echo "Usage: ${CMDNAME} [-ch] [-f outputfilename] [-i resourcedir] [-o outputdir] ResourceName"
	echo "  -c : CSV形式で出力"
	echo "  -f : 出力ファイル名の指定（拡張子は不要）"
	echo "  -h : コマンドヘルプ"
	echo "  -i : リソースファイル格納ディレクトリの指定"
	echo "  -o : 出力ファイル格納ディレクトリの指定"
	echo ""
	echo "指定可能な[ResourceName]"
	echo "[all]の場合はリソースファイル格納ディレクトリ内のリソース全てを実行"
	echo "但し[-f]オプションと併用不可"
	echo -e "\tall"
	if [ ! -d ${RESOURCE_DIR} ]; then
		echo -e "Error: リソースファイル格納ディレクトリが存在しません。"
	else
		ls ${RESOURCE_DIR} | awk '{print "\t"$0}'
	fi
	exit 2
}

# CSVファイル形式変換用関数
function EXPORT_CSV()
{
	ITEMS=$1
	OUTPUT_PATH=$2

	# セクションごとのMarkdown形式書式行の検出
	for((i=${ITEMS};i>=0;i--))
	do
		sed -i ${OVERWRITE_OPTION} -e "$((${ROW_COUNT[${i}]}+2))d" ${OUTPUT_PATH}
	done
  sed -i ${OVERWRITE_OPTION} -e "s/^|//g" -e "s/|$//g" -e "s/|/,/g" -e "s/^#* //g" ${OUTPUT_PATH}
}

# -----------------------------------------------------------------------------
# 【オプション処理】
# -----------------------------------------------------------------------------
[ -z $1 ] && USAGE
while getopts "cf:hi:o:" OPTION
do
	case ${OPTION} in
		# CSVオプションが付与されていた場合はファイル名変更
		c)	FILETYPE="csv"
				OUTPUT_FILE="${OUTPUT_NAME}.${FILETYPE}"
				;;
		f)	OUTPUT_NAME=$(basename ${OPTARG})
				;;
		h)	USAGE
				;;
		i)	RESOURCE_DIR=${OPTARG}
				;;
		o)	OUTPUT_DIR=${OPTARG}
				;;
		*)	USAGE
				;;
	esac
done
shift $((${OPTIND}-1))

# リソース名の設定
RESOURCE_NAME=$1

# 実行リソースファイル読み込み用判定
if [ ${RESOURCE_NAME} == "all" ]; then
	ls -r ${RESOURCE_DIR} >| ${CMDTMP}
else
	echo ${RESOURCE_NAME} >| ${CMDTMP}
fi

# -----------------------------------------------------------------------------
# 【メイン処理】
# -----------------------------------------------------------------------------
# リソースファイル格納ディレクトリが存在しない場合、エラーで終了
if [ ! -d ${RESOURCE_DIR} ]; then
	echo "Error: リソースファイル格納ディレクトリが存在しません。"
	exit 1
fi

# 出力ファイル格納ディレクトリが存在しない場合、ディレクトリ作成
if [ ! -d ${OUTPUT_DIR} ]; then
	mkdir -p ${OUTPUT_DIR}
fi

while read RESOURCE_NAME
do
	if [ -z ${OUTPUT_NAME} ] || [ ${RESOURCE_NAME} == "all" ]; then
		OUTPUT_NAME="${RESOURCE_NAME}_list"
	fi

	OUTPUT_FILE="${OUTPUT_NAME}.${FILETYPE}"
	OUTPUT_PATH="${OUTPUT_DIR}/${OUTPUT_FILE}"

	# -----------------------------------------------------------------------------
	# 【AWSパラメータ出力用リソースファイル実行】
	# resourceディレクトリ配下の情報取得用シェルを実行
	# -----------------------------------------------------------------------------
	source ${RESOURCE_DIR}/${RESOURCE_NAME}

	# OUTPUT_NAMEの初期化
	OUTPUT_NAME=""

done < ${CMDTMP}

# 作業用tmpファイルの削除
rm -f ${CMDTMP}

if [ ${OS_TYPE} == Darwin ]; then
  rm -f ${OUTPUT_PATH}${OVERWRITE_OPTION}
fi