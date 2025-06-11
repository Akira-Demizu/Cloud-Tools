#!/bin/bash

# === 引数処理 ===
if [ $# -lt 1 ]; then
  echo "Usage: $0 /path/to/slow.log [csv|md]"
  exit 1
fi

SLOWLOG="$1"
FORMAT="${2:-md}"  # デフォルトは markdown

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

# === 集計・出力 ===
awk -v format="$FORMAT" -F'|' '
function extract_tables(sql, arr,    lower, i, tbls, tbl) {
  lower = tolower(sql)
  n = split(lower, arr, /(from|join|update|into)/)
  tbls = ""
  for (i = 2; i <= n; i++) {
    if (match(arr[i], /[ \t\n\r`]*([a-zA-Z_][a-zA-Z0-9_\.]*)/, m)) {
      tbl = m[1]
      sub(/\..*$/, "", tbl)  # スキーマ除去
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
    print "No,Tables,Count,AvgQueryTime(s),SampleQuery"
  } else {
    print "| No | Tables | Count | AvgQueryTime(s) | SampleQuery |"
    print "|----|--------|--------|------------------|--------------|"
  }

  i = 1
  PROCINFO["sorted_in"] = "@val_num_desc"
  for (k in count) {
    avg = total_qt[k] / count[k]
    q = sample[k]
    gsub(/"/, "\"\"", q)
    if (format == "csv") {
      printf "%d,\"%s\",%d,%.6f,\"%s\"\n", i++, k, count[k], avg, q
    } else {
      gsub(/\|/, "\\|", q)  # マークダウン対策
      printf "| %d | %s | %d | %.6f | `%s` |\n", i++, k, count[k], avg, q
    }
  }
}
' "$PARSED"

# === クリーンアップ ===
rm -rf "$TMP_DIR"