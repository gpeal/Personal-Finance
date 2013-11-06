rbenv-deps:
  pkg.installed:
    - pkgs:
      - bash
      - git
      - openssl
      - curl

ruby-2.0.0-p247:
  rbenv.installed:
    - default: True
    - user: vagrant
    - require:
      - pkg: rbenv-deps

/home/vagrant/.profile:
  file.append:
    - user: vagrant
    - text:
      - export PATH="$HOME/.rbenv/bin:$PATH"
      - eval "$(rbenv init -)"

/home/vagrant/.rbenv/bin/rbenv rehash:
  cmd.run:
    - user: vagrant

rails:
  gem.installed:
    - runas: vagrant
    - version: 2.0.1

bundler:
  gem.installed:
    - runas: vagrant