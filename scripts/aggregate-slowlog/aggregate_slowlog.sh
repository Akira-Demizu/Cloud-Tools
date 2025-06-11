#!/bin/bash

# === デフォルト設定 ===
FORMAT="md"           # デフォルトはマークダウン
INCLUDE_SAMPLE=false  # デフォルトはサンプルクエリ非表示

# === 引数処理（ロングオプション） ===
for arg in "$@"; do
  case $arg in
    --path=*)
      SLOWLOG="${arg#*=}"
      shift
      ;;
    --output=csv)
      FORMAT="csv"
      shift
      ;;
    --output=md)
      FORMAT="md"
      shift
      ;;
    --detail)
      INCLUDE_SAMPLE=true
      shift
      ;;
    *)
      echo "Usage: $0 --path=/path/to/slow.log [--output=csv|md] [--detail]"
      exit 1
      ;;
  esac
done

# === 必須チェック ===
if [ -z "$SLOWLOG" ]; then
  echo "Error: --path is required."
  exit 1
fi

if [[ ! -f "$SLOWLOG" ]]; then
  echo "Error: File '$SLOWLOG' not found."
  exit 1
fi

# === 一時ファイル ===
TMP_DIR=$(mktemp -d)
PARSED="$TMP_DIR/parsed.log"

# === クエリ抽出 ===
awk '
/^# Query_time:/ {
  split($0, a, " ");
  qt=a[3];
}
/^use / { db=$2 }
/^SET timestamp=/ { next }
/^SELECT/ || /^INSERT/ || /^UPDATE/ || /^DELETE/ {
  query=$0;
  while ((getline line) > 0) {
    if (line ~ /^#/) break;
    query = query " " line;
  }
  print qt "|" db "|" query;
}' "$SLOWLOG" > "$PARSED"

# === 集計＆出力 ===
awk -v format="$FORMAT" -v include_sample="$INCLUDE_SAMPLE" -F'|' '
function extract_tables(sql, arr,    lower, i, tbls, tbl) {
  lower = tolower(sql)
  n = split(lower, arr, /(from|join|update|into)/)
  tbls = ""
  for (i = 2; i <= n; i++) {
    if (match(arr[i], /[ \t\n\r`]*([a-zA-Z_][a-zA-Z0-9_\.]*)/, m)) {
      tbl = m[1]
      sub(/\..*$/, "", tbl)
      if (!(tbl in seen)) {
        seen[tbl] = 1
        tbls = (tbls == "" ? tbl : tbls "," tbl)
      }
    }
  }
  delete seen
  return (tbls == "" ? "unknown" : tbls)
}

{
  qt = $1 + 0
  db = $2
  q = $3

  tbls = extract_tables(q, parts)
  key = tbls
  count[key]++
  total_qt[key] += qt
  if (!sample[key]) sample[key] = q
}

END {
  if (format == "csv") {
    if (include_sample == "true") {
      print "No,Tables,Count,AvgQueryTime(s),SampleQuery"
    } else {
      print "No,Tables,Count,AvgQueryTime(s)"
    }
  } else {
    if (include_sample == "true") {
      print "| No | Tables | Count | AvgQueryTime(s) | SampleQuery |"
      print "|----|--------|--------|------------------|--------------|"
    } else {
      print "| No | Tables | Count | AvgQueryTime(s) |"
      print "|----|--------|--------|------------------|"
    }
  }

  i = 1
  PROCINFO["sorted_in"] = "@val_num_desc"
  for (k in count) {
    avg = total_qt[k] / count[k]
    q = sample[k]
    gsub(/"/, "\"\"", q)
    gsub(/\|/, "\\|", q)
    if (format == "csv") {
      if (include_sample == "true") {
        printf "%d,\"%s\",%d,%.6f,\"%s\"\n", i++, k, count[k], avg, q
      } else {
        printf "%d,\"%s\",%d,%.6f\n", i++, k, count[k], avg
      }
    } else {
      if (include_sample == "true") {
        printf "| %d | %s | %d | %.6f | `%s` |\n", i++, k, count[k], avg, q
      } else {
        printf "| %d | %s | %d | %.6f |\n", i++, k, count[k], avg
      }
    }
  }
}
' "$PARSED"

rm -rf "$TMP_DIR"