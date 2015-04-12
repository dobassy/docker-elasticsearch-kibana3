#!/bin/bash
set -e

# FQDN for ES
ES_FQDN=${ES_FQDN:-elasticsearch.local}
# FQDN for kibana
KI_FQDN=${KI_FQDN:-kibana.local}

## elasticsearch
echo "# enable CORS" >> /etc/elasticsearch/elasticsearch.yml
echo "http.cors.enabled: true" >> /etc/elasticsearch/elasticsearch.yml
echo "http.cors.allow-origin: http://$KI_FQDN" >> /etc/elasticsearch/elasticsearch.yml

/etc/init.d/elasticsearch start
sleep 25

echo "[INFO] default port"
curl localhost:9200


### ES - the reverse proxy setting to access at port 80
cat <<'EOF' > /etc/nginx/sites-available/default
server {
	listen 80 default_server;
	#listen [::]:80 default_server;

	root /var/www/html/kibana/;

	server_name _;

	location / {
		# First attempt to serve request as file, then
		# as directory, then fall back to displaying a 404.
		try_files $uri $uri/ =404;
	}

	location /es/ {
		proxy_pass http://127.0.0.1:9200/;
	}
}
EOF

#echo "[INFO] by 80 port"
#curl localhost/es/

## kibana
sed -i -e "s/http:\/\/\"+window.location.hostname+\":9200/http:\/\/$ES_FQDN\/es\//" /var/www/html/kibana/config.js
/etc/init.d/nginx start

tail -f /var/log/elasticsearch/elasticsearch.log
