### 概要

MySQLスローログを集計するスクリプト。

### 対象ログ

```
# Time: 250530  4:58:34
# User@Host: sample-net[sample-net] @ localhost []
# Thread_id: 1648217  Schema: sample-net  QC_hit: No
# Query_time: 1.992582  Lock_time: 0.000240  Rows_sent: 10  Rows_examined: 63723
# Rows_affected: 0  Bytes_sent: 194
use sample-net;
SET timestamp=1748548714;
SELECT SQL_CALC_FOUND_ROWS  wp_2_posts.ID
                                         FROM wp_2_posts
                                         WHERE 1=1  AND (((wp_2_posts.post_title LIKE '%所得拡大%') OR (wp_2_posts.post_excerpt LIKE '%所得拡大%') OR (wp_2_posts.post_content LIKE '%所得拡大%')))  AND (wp_2_posts.post_password = '')  AND ((wp_2_posts.post_type = 'post' AND (wp_2_posts.post_status = 'publish' OR wp_2_posts.post_status = 'acf-disabled' OR wp_2_posts.post_status = 'wc-pending' OR wp_2_posts.post_status = 'wc-processing' OR wp_2_posts.post_status = 'wc-on-hold' OR wp_2_posts.post_status = 'wc-completed' OR wp_2_posts.post_status = 'wc-cancelled' OR wp_2_posts.post_status = 'wc-refunded' OR wp_2_posts.post_status = 'wc-failed' OR wp_2_posts.post_status = 'wc-shipped')) OR (wp_2_posts.post_type = 'page' AND (wp_2_posts.post_status = 'publish' OR wp_2_posts.post_status = 'acf-disabled' OR wp_2_posts.post_status = 'wc-pending' OR wp_2_posts.post_status = 'wc-processing' OR wp_2_posts.post_status = 'wc-on-hold' OR wp_2_posts.post_status = 'wc-completed' OR wp_2_posts.post_status = 'wc-cancelled' OR wp_2_posts.post_status = 'wc-refunded' OR wp_2_posts.post_status = 'wc-failed' OR wp_2_posts.post_status = 'wc-shipped')) OR (wp_2_posts.post_type = 'attachment' AND (wp_2_posts.post_status = 'publish' OR wp_2_posts.post_status = 'acf-disabled' OR wp_2_posts.post_status = 'wc-pending' OR wp_2_posts.post_status = 'wc-processing' OR wp_2_posts.post_status = 'wc-on-hold' OR wp_2_posts.post_status = 'wc-completed' OR wp_2_posts.post_status = 'wc-cancelled' OR wp_2_posts.post_status = 'wc-refunded' OR wp_2_posts.post_status = 'wc-failed' OR wp_2_posts.post_status = 'wc-shipped')) OR (wp_2_posts.post_type = 'product' AND (wp_2_posts.post_status = 'publish' OR wp_2_posts.post_status = 'acf-disabled' OR wp_2_posts.post_status = 'wc-pending' OR wp_2_posts.post_status = 'wc-processing' OR wp_2_posts.post_status = 'wc-on-hold' OR wp_2_posts.post_status = 'wc-completed' OR wp_2_posts.post_status = 'wc-cancelled' OR wp_2_posts.post_status = 'wc-refunded' OR wp_2_posts.post_status = 'wc-failed' OR wp_2_posts.post_status = 'wc-shipped')) OR (wp_2_posts.post_type = 'hs_newstopics' AND (wp_2_posts.post_status = 'publish' OR wp_2_posts.post_status = 'acf-disabled' OR wp_2_posts.post_status = 'wc-pending' OR wp_2_posts.post_status = 'wc-processing' OR wp_2_posts.post_status = 'wc-on-hold' OR wp_2_posts.post_status = 'wc-completed' OR wp_2_posts.post_status = 'wc-cancelled' OR wp_2_posts.post_status = 'wc-refunded' OR wp_2_posts.post_status = 'wc-failed' OR wp_2_posts.post_status = 'wc-shipped')) OR (wp_2_posts.post_type = 'hs_authorinfo' AND (wp_2_posts.post_status = 'publish' OR wp_2_posts.post_status = 'acf-disabled' OR wp_2_posts.post_status = 'wc-pending' OR wp_2_posts.post_status = 'wc-processing' OR wp_2_posts.post_status = 'wc-on-hold' OR wp_2_posts.post_status = 'wc-completed' OR wp_2_posts.post_status = 'wc-cancelled' OR wp_2_posts.post_status = 'wc-refunded' OR wp_2_posts.post_status = 'wc-failed' OR wp_2_posts.post_status = 'wc-shipped')))

                                         ORDER BY wp_2_posts.post_title LIKE '%所得拡大%' DESC, wp_2_posts.post_date DESC
                                         LIMIT 190, 10;
# Time: 250530  4:59:41
# User@Host: sample-net[sample-net] @ localhost []
# Thread_id: 1648341  Schema: sample-net  QC_hit: No
# Query_time: 1.951006  Lock_time: 0.000211  Rows_sent: 10  Rows_examined: 63613
# Rows_affected: 0  Bytes_sent: 197
SET timestamp=1748548781;
SELECT SQL_CALC_FOUND_ROWS  wp_2_posts.ID
                                         FROM wp_2_posts
                                         WHERE 1=1  AND (((wp_2_posts.post_title LIKE '%生計を一にする%') OR (wp_2_posts.post_excerpt LIKE '%生計を一にする%') OR (wp_2_posts.post_content LIKE '%生計を一にする%')))  AND (wp_2_posts.post_password = '')  AND ((wp_2_posts.post_type = 'post' AND (wp_2_posts.post_status = 'publish' OR wp_2_posts.post_status = 'acf-disabled' OR wp_2_posts.post_status = 'wc-pending' OR wp_2_posts.post_status = 'wc-processing' OR wp_2_posts.post_status = 'wc-on-hold' OR wp_2_posts.post_status = 'wc-completed' OR wp_2_posts.post_status = 'wc-cancelled' OR wp_2_posts.post_status = 'wc-refunded' OR wp_2_posts.post_status = 'wc-failed' OR wp_2_posts.post_status = 'wc-shipped')) OR (wp_2_posts.post_type = 'page' AND (wp_2_posts.post_status = 'publish' OR wp_2_posts.post_status = 'acf-disabled' OR wp_2_posts.post_status = 'wc-pending' OR wp_2_posts.post_status = 'wc-processing' OR wp_2_posts.post_status = 'wc-on-hold' OR wp_2_posts.post_status = 'wc-completed' OR wp_2_posts.post_status = 'wc-cancelled' OR wp_2_posts.post_status = 'wc-refunded' OR wp_2_posts.post_status = 'wc-failed' OR wp_2_posts.post_status = 'wc-shipped')) OR (wp_2_posts.post_type = 'attachment' AND (wp_2_posts.post_status = 'publish' OR wp_2_posts.post_status = 'acf-disabled' OR wp_2_posts.post_status = 'wc-pending' OR wp_2_posts.post_status = 'wc-processing' OR wp_2_posts.post_status = 'wc-on-hold' OR wp_2_posts.post_status = 'wc-completed' OR wp_2_posts.post_status = 'wc-cancelled' OR wp_2_posts.post_status = 'wc-refunded' OR wp_2_posts.post_status = 'wc-failed' OR wp_2_posts.post_status = 'wc-shipped')) OR (wp_2_posts.post_type = 'product' AND (wp_2_posts.post_status = 'publish' OR wp_2_posts.post_status = 'acf-disabled' OR wp_2_posts.post_status = 'wc-pending' OR wp_2_posts.post_status = 'wc-processing' OR wp_2_posts.post_status = 'wc-on-hold' OR wp_2_posts.post_status = 'wc-completed' OR wp_2_posts.post_status = 'wc-cancelled' OR wp_2_posts.post_status = 'wc-refunded' OR wp_2_posts.post_status = 'wc-failed' OR wp_2_posts.post_status = 'wc-shipped')) OR (wp_2_posts.post_type = 'hs_newstopics' AND (wp_2_posts.post_status = 'publish' OR wp_2_posts.post_status = 'acf-disabled' OR wp_2_posts.post_status = 'wc-pending' OR wp_2_posts.post_status = 'wc-processing' OR wp_2_posts.post_status = 'wc-on-hold' OR wp_2_posts.post_status = 'wc-completed' OR wp_2_posts.post_status = 'wc-cancelled' OR wp_2_posts.post_status = 'wc-refunded' OR wp_2_posts.post_status = 'wc-failed' OR wp_2_posts.post_status = 'wc-shipped')) OR (wp_2_posts.post_type = 'hs_authorinfo' AND (wp_2_posts.post_status = 'publish' OR wp_2_posts.post_status = 'acf-disabled' OR wp_2_posts.post_status = 'wc-pending' OR wp_2_posts.post_status = 'wc-processing' OR wp_2_posts.post_status = 'wc-on-hold' OR wp_2_posts.post_status = 'wc-completed' OR wp_2_posts.post_status = 'wc-cancelled' OR wp_2_posts.post_status = 'wc-refunded' OR wp_2_posts.post_status = 'wc-failed' OR wp_2_posts.post_status = 'wc-shipped')))

                                         ORDER BY wp_2_posts.post_title LIKE '%生計を一にする%' DESC, wp_2_posts.post_date DESC
                                         LIMIT 80, 10;
```

### 要件
スクリプト：シェル
パラメータ：対象slow.logへのパス
出力結果：マークダウン（デフォルト） or CSV
出力項目：No、対象テーブル、発生回数、平均クエリ時間（s）、サンプルクエリ
出力順序：発生回数の降順

### 実行

```
chmod +x aggregate_slowlog.sh
# デフォルト（マークダウンで出力）
./aggregate_slowlog.sh --path=/path/to/slow.log

# CSVで出力
./aggregate_slowlog.sh --path=/path/to/slow.log --output=csv

# サンプルクエリあり
./aggregate_slowlog.sh --path=/path/to/slow.log --detail

# 日時指定（6/1 0時～6/1 23:59）
./aggregate_slowlog.sh --path=/path/to/slow.log --start="20250601" --end="20250601 23:59"

# 特定テーブル
./aggregate_slowlog.sh --path=/path/to/slow.log --table=wp_posts
```

### 出力例

#### マークダウン

```
| No | Tables        | Count | AvgQueryTime(s) | SampleQuery |
|----|---------------|--------|------------------|--------------|
| 1  | wp_2_posts    | 2     | 1.971794         | `SELECT SQL_CALC_FOUND_ROWS wp_2_posts.ID FROM ...` |
```

#### CSV

```
No,Tables,Count,AvgQueryTime(s),SampleQuery
1,"wp_2_posts",2,1.971794,"SELECT SQL_CALC_FOUND_ROWS wp_2_posts.ID FROM wp_2_posts WHERE ..."
2,"some_custom_table",1,0.872115,"SELECT * FROM some_custom_table JOIN another_table ..."
```
