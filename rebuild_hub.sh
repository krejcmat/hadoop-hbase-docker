curl -H "Content-Type: application/json" --data '{"build": true}' -X POST https://registry.hub.docker.com/u/krejcmat/hadoop-hbase-master/trigger/24a443f8-b8bb-4da9-b5e5-24c3739a7185/

curl -H "Content-Type: application/json" --data '{"build": true}' -X POST https://registry.hub.docker.com/u/krejcmat/hadoop-hbase-dnsmasq/trigger/11c513c7-87f9-43b5-bb7d-8480c94d0dd3/

curl -H "Content-Type: application/json" --data '{"build": true}' -X POST https://registry.hub.docker.com/u/krejcmat/hadoop-hbase-base/trigger/558f0a40-ee9e-4ff8-9bfa-ce3f7e53a133/

curl -H "Content-Type: application/json" --data '{"build": true}' -X POST https://registry.hub.docker.com/u/krejcmat/hadoop-hbase-slave/trigger/45d3240a-f4ad-46a0-9b4f-e16a99112d26/

echo done

