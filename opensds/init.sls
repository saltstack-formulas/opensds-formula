### opensds/init.sls
include:
  {{ '- epel' if grains.os_family in ('RedHat',) else '' }}  
  - opensds.infra
  - opensds.hotpot
  - opensds.sushi
  - opensds.auth
  - opensds.database
  - opensds.let
  - opensds.dock
  - opensds.dashboard
  - opensds.gelato

opensds init auto-remove debian packages:
  cmd.run:
    - name: apt autoremove -y
    - onlyif: test '{{ grains.os_family }}' = 'Debian'
