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
```

### 要件
スクリプト：シェル
パラメータ：対象slow.logへのパス
出力結果：マークダウン（デフォルト） or CSV
出力項目：No、スキーマ、対象テーブル、発生回数、平均クエリ時間（s）、サンプルクエリ
出力順序：発生回数の降順

### 実行

```
chmod +x aggregate_slowlog.sh
# デフォルト
./aggregate_slowlog.sh

# CSV&サンプルクエリあり&ファイル出力
./aggregate_slowlog.sh --path=/samples/slow.log --output=/outputs --format=csv

# 日時指定（6/1 0時～6/1 23:59）
./aggregate_slowlog.sh --start="20250601" --end="20250601 23:59"

# 特定テーブル
./aggregate_slowlog.sh --table=wp_posts
```

### オプション

| オプション名    | 説明                                                                                     | 例                             |
|-----------------|------------------------------------------------------------------------------------------|--------------------------------|
| `--path=`       | 分析対象の slow.log ファイルパス（省略時は `/var/log/mysql/slow.log`）                   | `--path=/logs/slow.log`        |
| `--output=`     | 出力先ディレクトリ（省略時は標準出力）                                                   | `--output=/tmp`                |
| `--format=`     | 出力フォーマット（`md` または `csv`）※デフォルト: `md`。`csv` の場合のみサンプルクエリを含む | `--format=csv`                 |
| `--encoding=`   | 出力ファイルの文字コード（`utf8`, `utf8-bom`, `shift_jis`）。※CSV時のみ有効               | `--encoding=utf8-bom`          |
| `--start=`      | 対象ログの開始日時（`YYYYMMDD` や `YYYYMMDD hh[:mm[:ss]]` 形式）                         | `--start=20250610 04:00`       |
| `--end=`        | 対象ログの終了日時（同上）                                                               | `--end=20250610 23`            |
| `--table=`      | 対象にするテーブルをカンマ区切りで指定（部分一致・フィルタリング）                       | `--table=wp_posts,wp_postmeta` |

### 出力例

#### マークダウン

```
| No | Schema | Tables | Count | AvgQueryTime(s) |
|----|--------|--------|-------|------------------|
| 1 | test_db | wp_posts,wp_postmeta | 3740 | 2.189744 |
| 2 | test_db | wp_posts | 365 | 1.415544 |
| 3 | test_db | wp_posts,wp_aioseo_posts | 150 | 1.472431 |
| 4 | test_db | wp_posts,wp_term_relationships,wp_postmeta | 85 | 2.281132 |
| 5 | test_db | wp_postmeta | 33 | 4.252126 |
|   |         | **Count合計 / AvgQueryTime(s)平均** | **4373** | **2.11786** |
```

#### CSV

```
No,Schema,Tables,Count,AvgQueryTime(s),SampleQuery
1,"test_db","wp_posts,wp_postmeta",3740,2.189744,"SELECT SQL_CALC_FOUND_ROWS  wp_posts.ID 					 FROM wp_posts  LEFT JOIN wp_postmeta ON ( wp_posts.ID = wp_postmeta.post_id AND wp_postmeta.meta_key = 'is_pr' )  LEFT JOIN wp_postmeta AS mt1 ON ( wp_posts.ID = mt1.post_id ) 					 WHERE 1=1  AND (    (      wp_postmeta.post_id IS NULL      OR      ( mt1.meta_key = 'is_pr' AND mt1.meta_value != '1' )   ) ) AND ((wp_posts.post_type = 'post' AND (wp_posts.post_status = 'publish' OR wp_posts.post_status = 'acf-disabled')) OR (wp_posts.post_type = 'pickup' AND (wp_posts.post_status = 'publish' OR wp_posts.post_status = 'acf-disabled')) OR (wp_posts.post_type = 'special' AND (wp_posts.post_status = 'publish' OR wp_posts.post_status = 'acf-disabled'))) 					 GROUP BY wp_posts.ID 					 ORDER BY wp_posts.menu_order, wp_posts.post_modified DESC 					 LIMIT 0, 30;"
2,"test_db","wp_posts",365,1.415544,"SELECT SQL_CALC_FOUND_ROWS  wp_posts.ID 					 FROM wp_posts  					 WHERE 1=1  AND (((wp_posts.post_title LIKE '%asmr%') OR (wp_posts.post_excerpt LIKE '%asmr%') OR (wp_posts.post_content LIKE '%asmr%')))  AND (wp_posts.post_password = '')  AND ((wp_posts.post_type = 'post' AND (wp_posts.post_status = 'publish' OR wp_posts.post_status = 'acf-disabled')) OR (wp_posts.post_type = 'pickup' AND (wp_posts.post_status = 'publish' OR wp_posts.post_status = 'acf-disabled')) OR (wp_posts.post_type = 'special' AND (wp_posts.post_status = 'publish' OR wp_posts.post_status = 'acf-disabled'))) 					  					 ORDER BY wp_posts.post_title LIKE '%asmr%' DESC, wp_posts.post_date DESC 					 LIMIT 0, 20;"
3,"test_db","wp_posts,wp_aioseo_posts",150,1.472431,"SELECT  	`p`.`ID`, `p`.`post_title`, `p`.`post_content`, `p`.`post_excerpt`, `p`.`post_type`, `p`.`post_password`, `p`.`post_parent`, `p`.`post_date_gmt`, `p`.`post_modified_gmt`, `ap`.`priority`, `ap`.`frequency`, `ap`.`images` FROM wp_posts as p 	LEFT JOIN wp_aioseo_posts as ap ON `ap`.`post_id` = `p`.`ID` WHERE 1 = 1 AND 	`p`.`post_status` = 'publish' 	AND p.post_type IN ( 'post' ) 	AND ( `ap`.`robots_noindex` IS NULL OR `ap`.`robots_default` = 1 OR `ap`.`robots_noindex` = 0 OR post_id = 2907 ) 	AND 1=1 OR `p`.`ID` = 2903 ORDER BY case when `p`.`ID` = 2903 then 0 else 1 end, `ap`.`priority` DESC, `p`.`post_modified_gmt` DESC LIMIT 10000, 1000 /* 1 = 1 */;"
4,"test_db","wp_posts,wp_term_relationships,wp_postmeta",85,2.281132,"SELECT SQL_CALC_FOUND_ROWS  wp_posts.ID 					 FROM wp_posts  LEFT JOIN wp_term_relationships ON (wp_posts.ID = wp_term_relationships.object_id) LEFT JOIN wp_postmeta ON ( wp_posts.ID = wp_postmeta.post_id AND wp_postmeta.meta_key = 'is_pr' )  LEFT JOIN wp_postmeta AS mt1 ON ( wp_posts.ID = mt1.post_id ) 					 WHERE 1=1  AND (    wp_term_relationships.term_taxonomy_id IN (2) ) AND (    (      wp_postmeta.post_id IS NULL      OR      ( mt1.meta_key = 'is_pr' AND mt1.meta_value != '1' )   ) ) AND ((wp_posts.post_type = 'post' AND (wp_posts.post_status = 'publish' OR wp_posts.post_status = 'acf-disabled')) OR (wp_posts.post_type = 'pickup' AND (wp_posts.post_status = 'publish' OR wp_posts.post_status = 'acf-disabled')) OR (wp_posts.post_type = 'special' AND (wp_posts.post_status = 'publish' OR wp_posts.post_status = 'acf-disabled'))) 					 GROUP BY wp_posts.ID 					 ORDER BY wp_posts.post_date DESC 					 LIMIT 0, 30;"
5,"test_db","wp_postmeta",33,4.252126,"SELECT DISTINCT meta_key FROM wp_postmeta WHERE post_id IN(11,22,33);"

,,,"Total Count","Average Query Time"
,,,4373,2.117859
```

### テスト

TODO:テストツールの導入

```shell
./aggregate_slowlog.sh --path=./tests/include_update_text.log
```

```shell
./aggregate_slowlog.sh --path=./tests/reservation.log
```

```shell
./aggregate_slowlog.sh --path=./tests/unknown_text.log
```