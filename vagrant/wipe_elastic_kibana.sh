#!/usr/bin/env bash

echo ""
echo "Deleting ElasticSearch namespace"
su user -c "kubectl delete namespace logging-elasticsearch"

echo ""
echo "Release the PVs"
su user -c "kubectl patch pv elasticsearch-data -p '{\"spec\":{\"claimRef\": null}}'"

echo ""
echo "Deleting Kibana Deployment"
su user -c "kubectl --namespace=logging delete deployments kibana"

echo ""
echo "Mount Elasticsearch volume"
mkdir -p /data/volumes/elasticsearch-data
mount -t glusterfs master-1:/elasticsearch-data /data/volumes/elasticsearch-data

echo ""
echo "Wait to be sure Elasticsearch is stopped"
sleep 5

echo ""
echo "Wipe Elasticsearch volumes"
rm -Rf /data/volumes/elasticsearch-data/*

echo ""
echo "Provision ElasticSearch & Kibana"
bash /opt/provision/vagrant/ansible_provisioning.sh --tags kubernetes-app-logging-elasticsearch,kubernetes-app-logging-kibana
