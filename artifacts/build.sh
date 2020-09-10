#!/bin/sh


perr() {
  echo "$@" 1>&2
}

usage() {
  perr "usage: $0 [-d] -s image_size"
  perr ""
  perr "  -d generates a DigitalOcean ready image"
  perr "  the image_size unit is GiB"
  exit 1
}


digitalocean=0

while getopts "ds:" opt; do
  case "${opt}" in
    d)
      digitalocean=1
      ;;
    s)
      image_size=${OPTARG}
      ;;
    *)
      usage
      ;;
  esac
done

if [[ -z "$image_size" ]] ; then
  usage
fi

rm -fr input
cp -a artifacts input

if [[ "$digitalocean" -eq "0" ]]; then
        sed 's/digitalOceanTarget =.*/digitalOceanTarget = false;/' -i input/configuration.nix
else
        sed 's/digitalOceanTarget =.*/digitalOceanTarget = true;/' -i input/configuration.nix
fi

set -e
set -x

nix-channel --add https://nixos.org/channels/nixos-20.09 nixpkgs
nix-channel --update

chmod a+rw /dev/kvm
nix-env -i pigz

cd /tmp

rm -f /output/nixos.qcow2 /output/nixos.qcow2.gz 

nix-build --arg imageSize $image_size -I nixpkgs=https://github.com/NixOS/nixpkgs-channels/archive/nixos-20.09.tar.gz /input/image.nix


cp /tmp/result/nixos.qcow2 /output/

pigz /output/nixos.qcow2
chown -R $USERID:$GROUPID /output
chmod u+rw /output/nixos.qcow2.gz
