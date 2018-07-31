#!/usr/bin/env bash

# _clean_lvm_volume_group removes all default LVM volumes
#
# Usage: _clean_lvm_volume_group $vg
function _clean_lvm_volume_group 
{
   local vg=$1
    # Clean out existing volumes
   lvremove -f $vg
}

# _remove_lvm_volume_group removes the volume group
#
# Usage: _remove_lvm_volume_group $vg
function _remove_lvm_volume_group
{
   local vg=$1
    # Remove the volume group
   vgremove -f $vg
}

# _clean_lvm_backing_file() removes the backing file of the
# volume group
#
# Usage: _clean_lvm_backing_file() $backing_file
function _clean_lvm_backing_file
{
    local backing_file=$1
     # If the backing physical device is a loop device, it was probably setup by DevStack
    if [[ -n "$backing_file" ]] && [[ -e "$backing_file" ]];
    then
        local vg_dev
        vg_dev=$(sudo losetup -j $backing_file | awk -F':' '/'.img'/ { print $1}')
        if [[ -n "$vg_dev" ]]; then
         losetup -d $vg_dev
        fi
        rm -f $backing_file
   fi
}

# clean_lvm_volume_group() cleans up the volume group and removes the
# backing file
#
# Usage: clean_lvm_volume_group $vg
function clean_lvm_volume_group
{
    local vg=$1
    _clean_lvm_volume_group $vg
    _remove_lvm_volume_group $vg
     # if there is no logical volume left, it's safe to attempt a cleanup
     # of the backing file
    if [[ -z "$(sudo lvs --noheadings -o lv_name $vg 2>/dev/null)" ]]
    then
         _clean_lvm_backing_file {{ cinder_data_dir }}/${vg}.img
    fi
}
  
clean_lvm_volume_group {{ cinder_volume_group }}
