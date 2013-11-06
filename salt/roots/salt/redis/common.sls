{% set redis = pillar.get('redis', {}) -%}
{% set version = redis.get('version', 'stable') -%}
{% set checksum = redis.get('checksum', 'sha1=dbd00f83005a2d596c6a391bd1e33d8afe8a86fd') -%}
{% set root = redis.get('root', '/usr/local') -%}

redis-dependencies:
  pkg.installed:
    - names:
        - build-essential
        - python-dev
        - libxml2-dev

## Get redis
get-redis:
  file.managed:
    - name: {{ root }}/redis-{{ version }}.tar.gz
    - source: http://download.redis.io/redis-{{ version }}.tar.gz
    - source_hash: {{ checksum }}
    - require:
      - pkg: redis-dependencies
  cmd.wait:
    - cwd: {{ root }}
    - names:
      - tar -zxvf {{ root }}/redis-{{ version }}.tar.gz -C {{ root }}
    - watch:
      - file: get-redis

make-redis:
  cmd.wait:
    - cwd: {{ root }}/redis-{{ version }}
    - names:
      - make
      - make install
    - watch:
      - cmd: get-redis