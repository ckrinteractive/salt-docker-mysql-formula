{% set container_name = 'mysql' %}
{% set image_name = 'mysql:'+salt['pillar.get']('mysql:tag_name', 'latest') %}
{% set host_port = salt['pillar.get']('mysql:port', '3306') %}
{% set host_ip = salt['grains.get']('mysql:host') %}
{% set env_vars = {
  'MYSQL_ROOT_PASSWORD': salt['pillar.get']('mysql:root_password'),
} %}

{{ image_name }}:
  dockerng.image_present

{{ container_name }}:
  require:
     - dockerng: {{ image_name }}
  dockerng.running:
    - name: {{ container_name }}
    - image: {{ image_name }}
    - restart_policy: always
    - environment:
      {% for env_var, env_val in env_vars.items() -%}
        - {{ env_var }}: "{{ env_val }}"
      {% endfor %}
    - port_bindings:
      - {{ salt['grains.get']('ip4_interfaces:eth0:0') }}:{{ host_port }}:3306/tcp
