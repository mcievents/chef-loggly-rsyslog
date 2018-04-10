default['loggly']['token'] = ''

default['loggly']['tags'] = []

default['loggly']['log_files'] = []

default['loggly']['tls']['enabled'] = true
default['loggly']['tls']['cert_path'] = '/etc/rsyslog.d/keys/ca.d'
default['loggly']['tls']['cert_url'] = 'https://logdog.loggly.com/media/logs-01.loggly.com_sha12.crt'
default['loggly']['tls']['cert_checksum'] = '3bcd557ea8e43599d3fb98fd13857c2fbff5637cb307a3d4bae23e3c8b5c34cc'

default['loggly']['rsyslog']['host'] = 'logs-01.loggly.com'
default['loggly']['rsyslog']['port'] = node['loggly']['tls']['enabled'] ? 6514 : 514

default['loggly']['rsyslog']['input_file_poll_interval'] = 10
