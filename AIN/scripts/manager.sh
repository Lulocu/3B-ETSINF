#!/bin/bash
# ejecuta pygomas
echo 'empezar'
source ~/anaconda3/bin/activate root

pygomas manager -j manager_luilocu2@gtirouter.dsic.upv.es -m map_arena -sj service_luilocu2@gtirouter.dsic.upv.es -np 25
echo 'FIN'