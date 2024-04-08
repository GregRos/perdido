#!/usr/bin/env bash
for cur_cert in /etc/letsencrypt/{archive,live}{,/{*.,}{perdido.bond,gregros.dev,gregros.me}}; do
  chown -R nginx:cert_group $cur_cert;
  chown -R nginx:cert_group "$(realpath $cur_cert)"
  chmod -R 750 $cur_cert;
done
