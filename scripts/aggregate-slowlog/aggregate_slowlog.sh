#!/bin/bash

FORMAT="md"
ENCODING="utf8"
FROM_EPOCH=0
TO_EPOCH=32503680000
FILTER_TABLES=()
OUTPUT_DIR=""

usage() {
  echo "Usage: $0 [--path=/path/to/slow.log] [--output=/path/to/outputdir] [--format=md|csv] [--encoding=utf8|utf8-bom|shift_jis] [--start='YYYYMMDD [hh[:mm[:ss]]'] [--end='YYYYMMDD [hh[:mm[:ss]]'] [--table=table1,table2]"
  exit 1
}

parse_datetime() {
  input="$1"
  if [[ "$input" =~ ^([0-9]{8})([[:space:]]+([0-9]{1,2})(:([0-9]{1,2}))?(:([0-9]{1,2}))?)?$ ]]; then
    y=${BASH_REMATCH[1]:0:4}
    m=${BASH_REMATCH[1]:4:2}
    d=${BASH_REMATCH[1]:6:2}
    H=${BASH_REMATCH[3]:-0}
    M=${BASH_REMATCH[5]:-0}
    S=${BASH_REMATCH[7]:-0}
    printf -v timestamp "%s-%s-%s %02d:%02d:%02d" "$y" "$m" "$d" "$H" "$M" "$S"
    date -d "$timestamp" +%s 2>/dev/null
    if [ $? -ne 0 ]; then
      echo "Invalid date: $input" >&2
      exit 1
    fi
  else
    echo "Invalid datetime format: $input" >&2
    exit 1
  fi
}

for arg in "$@"; do
  case $arg in
    --path=*) SLOWLOG="${arg#*=}" ;;
    --output=*) OUTPUT_DIR="${arg#*=}" ;;
    --format=csv|--format=md) FORMAT="${arg#*=}" ;;
    --encoding=*) ENCODING="${arg#*=}" ;;
    --start=*) FROM_EPOCH=$(parse_datetime "${arg#*=}") ;;
    --end=*) TO_EPOCH=$(parse_datetime "${arg#*=}") ;;
    --table=*) IFS=',' read -ra FILTER_TABLES <<< "${arg#*=}" ;;
    *) usage ;;
  esac
done

if [ -z "$SLOWLOG" ]; then SLOWLOG="/var/log/mysql/slow.log"; fi
if [ ! -f "$SLOWLOG" ]; then echo "Error: File '$SLOWLOG' not found."; exit 1; fi
if [ -n "$OUTPUT_DIR" ] && [ ! -d "$OUTPUT_DIR" ]; then echo "Error: Output directory '$OUTPUT_DIR' not found."; exit 1; fi

# Handle .gz slowlog files
if [[ "$SLOWLOG" == *.gz ]]; then
  TMP_SLOWLOG="$TMP_DIR/slow.log"
  gunzip -c "$SLOWLOG" > "$TMP_SLOWLOG"
  SLOWLOG="$TMP_SLOWLOG"
fi

TMP_DIR=$(mktemp -d)
PARSED="$TMP_DIR/parsed.log"

# ファイル名生成（logファイル名_YYYYMMDDHHMMSS）
BASENAME=$(basename "$SLOWLOG")
NOW=$(date +%Y%m%d%H%M%S)
FILENAME="${BASENAME}_$NOW.$FORMAT"
OUTFILE="$TMP_DIR/$FILENAME"

awk -v from="$FROM_EPOCH" -v to="$TO_EPOCH" '
function to_epoch(y, mo, d, h, mi,    cmd, result) {
  cmd = "date -d \"" y "-" mo "-" d " " h ":" mi "\" +%s"
  cmd | getline result
  close(cmd)
  return result
}
/^# Time: / {
  raw = $3
  y = "20" substr(raw,1,2)
  mo = substr(raw,3,2)
  d = substr(raw,5,2)
  h = (length(raw) >= 8 ? substr(raw,8,2) : "00")
  mi = (length(raw) >= 10 ? substr(raw,10,2) : "00")
  log_epoch = to_epoch(y,mo,d,h,mi)
  keep = (log_epoch >= from && log_epoch <= to)
}
/^# Query_time:/ { qt = $3 }
/^use / { db = $2; gsub(/[`;]/, "", db) }
/^SET timestamp=/ { next }
/^SELECT/ || /^INSERT/ || /^UPDATE/ || /^DELETE/ {
  if (!keep) next
  query=$0
  while ((getline line) > 0) {
    if (line ~ /^#/) break
    query = query " " line
  }
  print qt "|" db "|" query
}
' "$SLOWLOG" > "$PARSED"

awk -v format="$FORMAT" -v tables_filter="${FILTER_TABLES[*]}" -F'|' '
function extract_tables(sql, arr, lower, i, tbls, tbl) {
  lower = tolower(sql)
  n = split(lower, arr, /[[:space:]]+(from|join|update|into)[[:space:]]+/)
  tbls = ""
  for (i = 2; i <= n; i++) {
    if (match(arr[i], /[ \t\n\r`]*([a-zA-Z_][a-zA-Z0-9_\.]*)/, m)) {
      tbl = m[1]
      sub(/\..*$/, "", tbl)
      if (tbl ~ /^(select|where|group|order|limit|on|and|or|case|when|then|else|end|as|using|natural|inner|outer|left|right|cross|straight_join|force|ignore|key|index|use)$/) continue
      if (!(tbl in seen)) {
        seen[tbl] = 1
        tbls = (tbls == "" ? tbl : tbls "," tbl)
      }
    }
  }
  delete seen
  return (tbls == "" ? "unknown" : tbls)
}
BEGIN {
  n_filters = split(tables_filter, filters, /[, ]+/)
}
{
  qt = $1 + 0
  db = $2
  q = $3
  tbls = extract_tables(q, parts)
  if (tbls == "unknown") unknown_list[db "|" q "|" qt] = 1
  matched = (n_filters == 0)
  if (!matched) {
    for (f = 1; f <= n_filters; f++) {
      if (index(tbls, filters[f]) > 0) {
        matched = 1
        break
      }
    }
  }
  if (!matched) next
  key = tbls
  count[key]++
  total_qt[key] += qt
  if (!sample[key]) sample[key] = q
}
END {
  total_count = 0
  total_qt_sum = 0
  if (format == "csv") {
    print "No,Schema,Tables,Count,AvgQueryTime(s),SampleQuery"
  } else {
    print "| No | Schema | Tables | Count | AvgQueryTime(s) |"
    print "|----|--------|--------|-------|------------------|"
  }
  i = 1
  PROCINFO["sorted_in"] = "@val_num_desc"
  for (k in count) {
    avg = total_qt[k] / count[k]
    q = sample[k]
    gsub(/"/, "\"\"", q)
    gsub(/\|/, "\\|", q)
    if (format == "csv") {
      printf "%d,\"%s\",\"%s\",%d,%.6f,\"%s\"\n", i++, db, k, count[k], avg, q
    } else {
      printf "| %d | %s | %s | %d | %.6f |\n", i++, db, k, count[k], avg
    }
    total_count += count[k]
    total_qt_sum += total_qt[k]
  }
  if (format == "csv") {
    print ""
    print ",,,\"Total Count\",\"Average Query Time\""
    printf ",,,%d,%.6f\n", total_count, (total_qt_sum / total_count)
  } else {
    print "|   |          | **Count合計 / AvgQueryTime(s)平均** | **" total_count "** | **" (total_qt_sum / total_count) "** |"
  }
  if (length(unknown_list) > 0) {
    print ""
    print "▼ unknown テーブルとして抽出されたクエリ一覧"
    for (k in unknown_list) {
      split(k, parts, "|")
      print "QueryTime: " parts[3] " / Schema: " parts[1]
      print "Query: " parts[2]
      print ""
    }
  }
}' "$PARSED" > "$OUTFILE"

ENCODED_OUTFILE="$OUTFILE"

if [ "$FORMAT" = "csv" ]; then
  case "$ENCODING" in
    utf8-bom)
      ENCODED_OUTFILE="$TMP_DIR/bom_$FILENAME"
      printf '\xEF\xBB\xBF' > "$ENCODED_OUTFILE"
      cat "$OUTFILE" >> "$ENCODED_OUTFILE"
      ;;
    shift_jis)
      ENCODED_OUTFILE="$TMP_DIR/sjis_$FILENAME"
      nkf -s --overwrite "$OUTFILE"
      cp "$OUTFILE" "$ENCODED_OUTFILE"
      ;;
  esac
fi

if [ -n "$OUTPUT_DIR" ]; then
  cp "$ENCODED_OUTFILE" "$OUTPUT_DIR/$FILENAME"
  echo "Output written to: $OUTPUT_DIR/$FILENAME"
else
  cat "$ENCODED_OUTFILE"
fi

rm -rf "$TMP_DIR"