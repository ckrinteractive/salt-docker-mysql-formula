{% set container_name = 'mysql' %}
{% set host_port = salt['pillar.get']('mysql:port', '3306') %}
{% set host_ip = salt['grains.get']('mysql:host') %}

mysql:
  docker.pulled:
    - name: mysql

mysql-container:
  require:
     - docker: mysql
  docker.installed:
    - name: {{ container_name }}
    - image: mysql
    - environment:
      - MYSQL_ROOT_PASSWORD: {{ salt['pillar.get']('mysql:root_password', '')  }}

mysql-running:
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
