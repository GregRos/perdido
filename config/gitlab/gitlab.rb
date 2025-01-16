# Listen on distinct ports
external_url 'https://gitlab.perdido.bond'
nginx['listen_port'] = 12341
nginx['listen_https'] = false
nginx['listen_addresses'] = ['127.0.0.1']
registry_external_url 'https://registry.gitlab.perdido.bond'
registry['enable'] = true
registry_nginx['listen_port'] = 12342
registry_nginx['listen_https'] = false
registry_nginx['listen_addresses'] = ['127.0.0.1']
registry_nginx['proxy_set_headers'] = {
    "X-Forwarded-Proto" => "https",
    "X-Forwarded-Ssl" => "on"
}

mattermost_nginx['listen_port'] = 12343
mattermost_nginx['listen_https'] = false
mattermost_nginx['listen_addresses'] = ['127.0.0.1']
pages_nginx['listen_port'] = 12345
pages_nginx['listen_https'] = false
pages_nginx['listen_addresses'] = ['127.0.0.1']

nginx['real_ip_trusted_addresses'] = [ '185.107.44.16', '127.0.0.1']
nginx['real_ip_header'] = 'X-Forwarded-For'
nginx['real_ip_recursive'] = 'on'
# tons of configuration problems involving gitlab kas
# such as https://forum.gitlab.com/t/kas-not-starting-on-fresh-omnibus-installation/72327
# but even if fixed, more problems
# so disabling
gitlab_rails['gitlab_kas_enabled'] = false
gitlab_kas['enable'] = false
gitlab_rails['gitlab_ssh_host'] = 'perdido.bond'
gitlab_rails['gitlab_ssh_user'] = 'git'
gitlab_rails['allowed_hosts'] = ['gitlab.perdido.bond', '127.0.0.1', 'localhost']
# gitlab_kas['listen_address'] = 'localhost:8150'
# gitlab_kas_external_url "ws://localhost:8150/-/kubernetes-agent/"

# gitlab_rails['gitlab_kas_external_url'] = 'ws://localhost:8150/-/kubernetes-agent/'
# gitlab_kas['listen_network'] = 'tcp'
# gitlab_kas['listen_websocket'] = true

# limit # of workers to limit memory usage
puma['worker_processes'] = 3

# limit memory usage per worker
puma['per_worker_max_memory_mb'] = 800
