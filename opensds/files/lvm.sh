#!/bin/env bash

function _create_lvm_volume_group
{
    local vg=$1
    local size=$2
    local backing_file={{ opensds_work_dir }}/volumegroups/${vg}.img

    if ! sudo vgs $vg; then
        # Only create if the file doesn't already exists
        [[ -f $backing_file ]] || truncate -s $size $backing_file
        local vg_dev
        vg_dev=`sudo losetup -f --show $backing_file`
        # Only create physical volume if it doesn't already exist
        if ! sudo pvs $vg_dev; then
            sudo pvcreate $vg_dev
        fi
        # Only create volume group if it doesn't already exist
        if ! sudo vgs $vg; then
            sudo vgcreate $vg $vg_dev
        fi
    fi
}
modprobe dm_thin_pool
_create_lvm_volume_group {{ opensds_volume_group }} 10G
