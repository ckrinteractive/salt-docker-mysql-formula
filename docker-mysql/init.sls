{% set container_name = 'mysql' %}
{% set host_port = salt['pillar.get']('mysql:port', '3306') %}
{% set host_ip = salt['grains.get']('mysql:host') %}
{% set env_vars = {
  'MYSQL_ROOT_PASSWORD': salt['pillar.get']('mysql:root_password'),
} %}

mysql-pulled:
  docker.pulled:
    - name: mysql

mysql-container:
  require:
     - docker: mysql-pulled
  docker.installed:
    - name: {{ container_name }}
    - image: mysql
    - environment:
      {% for env_var, env_val in env_vars.items() -%}
        - {{ env_var }}: {{ env_val }}
      {% endfor %}

{{ container_name }}:
  require:
    - docker: mysql-container
  docker.running:
    - container: {{ container_name }}
    - image: mysql
    - restart_policy: always
    - ports:
        "3306/tcp":
            HostIp: {{ host_ip }}
            HostPort: {{ host_port }}
