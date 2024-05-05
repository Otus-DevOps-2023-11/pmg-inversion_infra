yc compute instance create \
  --name gtilab-ci-vm \
  --cores=2 \
  --memory=4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-2004-lts,size=50 \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --zone ru-central1-a \
  --ssh-key ~/.ssh/ubuntu.pub
  --metadata serial-port-enable=1 \
  --metadata-from-file user-data=create-node.yaml
