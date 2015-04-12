目的
====
Elasticsearchとkibana3を実行するDockerfile

内容
====
- Ubuntu 14.04 をベースにしている
- Elasticsearch 1.5を利用（以下、ES）
- Kibana 3.1.xを利用
  - Kibana 3.x 系はHTML + Javascriptで構成されている。通常ではESサーバーのポート9200を利用するが、Firewall等の事情で特殊ポートを利用できないケースがあるため、80番ポートで通信できるようにしている。（http://__host__/es/）
- ESへデータを突っ込む為のFluentdは別に構築することを前提としている。
  - 別にしたほうが構成変更しやすいため都合がいい
- Container維持の為のプロセスはESのlogを`tail -f`している。
  - supervisord等は利用していないので、必要に応じて対応要


使い方
=====
シンプルな使い方
-------------
* ポート開放 80(Kibana, ES用), 9200(Fluentdが接続する為のES用。標準ポート)は必須
* ES_FQDN: ESアクセス用のFQDN。ブラウザがアクセスするES用のURIを定義
* KI_FQDN: elasticsearch.yaml の http.cors.allow-origin に設定する

command:

    docker run -d -p 80:80 -p 9200:9200 ES_FQDN=es.yourhost.local -e KI_FQDN=kibana.yourhost.local exlair/elasticsearch-kibana3:latest

実用的な使い方
-----------
* データの永続性を持たせるために -v を利用。Host:Container の関係。Host側のpathは任意に設定する
* ESのデータ保存ディレクトリは[こちらの資料によると](wwww) `/var/lib/elasticsearch/data` なのだが、少なくとも現時点のdeb 1.5.x の実行結果によると `/var/lib/elasticsearch/elasticsearch`になっている模様。

commands:

	$ mkdir -p /srv/data/elasticsearch (<-- HostのDirectory。事前に作成しておく)
	$ docker run -d -p 80:80 -p 9200:9200 -v /srv/data/elasticsearch:/var/lib/elasticsearch -e ES_FQDN=es.yourhost.local -e KI_FQDN=kibana.yourhost.local exlair/elasticsearch-kibana3:latest

build.shの役割
-------------
buildを少し楽するための物。引数を与えなければ latest として作成。


[www]: http://www.elastic.co/guide/en/elasticsearch/reference/1.5/setup-dir-layout.html "Directory Layout"