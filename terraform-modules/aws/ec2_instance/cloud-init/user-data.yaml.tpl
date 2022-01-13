#cloud-config
# Doc: https://cloudinit.readthedocs.io/en/latest/topics/examples.html

# Add groups to the system
groups:
  - fspace

# Add users to the system. Users are added after groups are added.
users:
  - default
  - name: fsinstaller
    gecos: fsinstaller
    shell: /bin/bash
    primary_group: fspace
    sudo: 
      - ALL=(ALL:ALL) NOPASSWD:/usr/bin/rpm
      - ALL=(ALL:ALL) NOPASSWD:/opt/chef/embedded/bin/gem
      - ALL=(ALL:ALL) NOPASSWD:/usr/bin/chef-client
      - ALL=(ALL:ALL) NOPASSWD:/usr/bin/pkill
      - ALL=(ALL:ALL) NOPASSWD:/usr/bin/chef
      - ALL=(ALL:ALL) NOPASSWD:/opt/chefdk/embedded/bin/gem
    lock_passwd: false
    ssh_authorized_keys:
      - ${user_ssh_public_key}
  - name: aric
    gecos: aric
    shell: /bin/bash
    primary_group: fspace
    ssh_authorized_keys:
      - ${user_ssh_public_key}
  

# Installs packages
packages:
  - unzip

# Sets the GOPATH & downloads the demo payload
runcmd:
  - echo "ClientAliveInterval 60" | tee -a /etc/ssh/sshd_config
  - echo "ClientAliveCountMax 10" | tee -a /etc/ssh/sshd_config
  - systemctl restart sshd
  - echo "vm.swappiness=1" | tee -a /etc/sysctl.conf
  - sudo sysctl -p
  - curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.0.30.zip" -o "/tmp/awscliv2.zip"
  - unzip /tmp/awscliv2.zip -d /tmp/
  - /tmp/aws/install
  - if [[ "${ebs_block_device_1_is_set}" == "true" ]]; then export EBS_DEVICE=$(lsblk | grep -e "nvme1.*" | awk '{print $1}'); mkfs -t ext4 /dev/"$${EBS_DEVICE}"; mkdir -p "${ebs_block_device_1_mount_path}"; mount /dev/"$${EBS_DEVICE[$i]}" ${ebs_block_device_1_mount_path}; echo -e "UUID=$(lsblk -o +uuid /dev/"$${EBS_DEVICE[$i]}" | grep "$${EBS_DEVICE[$i]}" | awk '{print $8}') \t ${ebs_block_device_1_mount_path} \t ext4 \t defaults \t 0 \t 0" >> /etc/fstab; fi
  - if [[ "${ebs_block_device_2_is_set}" == "true" ]]; then export EBS_DEVICE=$(lsblk | grep -e "nvme2.*" | awk '{print $1}'); mkfs -t ext4 /dev/"$${EBS_DEVICE}"; mkdir -p "${ebs_block_device_2_mount_path}"; mount /dev/"$${EBS_DEVICE[$i]}" ${ebs_block_device_2_mount_path}; echo -e "UUID=$(lsblk -o +uuid /dev/"$${EBS_DEVICE[$i]}" | grep "$${EBS_DEVICE[$i]}" | awk '{print $8}') \t ${ebs_block_device_2_mount_path} \t ext4 \t defaults \t 0 \t 0" >> /etc/fstab; fi
write_files:
  - encoding: gzip
    content: !!binary |
      ${sudoers}
    path: /etc/sudoers.d/99-custom-sudoers
    permissions: '0440'
