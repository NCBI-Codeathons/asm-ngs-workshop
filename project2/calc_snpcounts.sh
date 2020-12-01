#!/bin/bash
if [ $# -ne 2 ]
then
        echo " Calculate SNP counts between two assemblies "
        echo " Usage: calc_snp_counts.sh <s6> <kuwaiti> "
        echo " where <s6> and <kuwaiti> are paths to the assemblies "
        exit 1
fi
s6=$1
kuwaiti=$2
s6base=`basename $s6 .fa`
kbase=`basename $kuwaiti _genomic.fna`
dir=nucmer/$s6base/$kbase
filebase=$dir/$s6base.$kbase
mkdir -p $dir
nucmer -t 2 --delta $filebase $s6 $kuwaiti
show-snps -I -T -q -C $filebase > $filebase.snps           
echo -n $s6base$'\t'$kbase$'\t'
awk '{ if ($5 >=20) print $0}' $filebase.snps \
        | awk '{ if ($6 >= 25) print $0}' | wc -l
