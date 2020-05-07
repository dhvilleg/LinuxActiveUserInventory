#!/bin/sh
#
#  Script %name        dep_epimeteo.sh %
#  %version            1 %
#  Description         Scrip para sacar un informe de usuarios activos del sistema
#  %created_by         Diego Villegas (FDM) %
#  %date_created       Fri Jul  1 152019 ECT 2011
# =====================================================================================
# change log
# =====================================================================================
# Mod.ID         Who                       When                         Description
# =====================================================================================
#
# =====================================================================================
HOME=/home/NAAN1U01
PASSW=/etc/passwd
HOSTNAME=`uname -n`
CONTADOR=0
LIST='servicio_n1_unix@FDM.com.ec'
echo "$HOSTNAME">$HOME/login.tmp
echo "usuario;responsable;home">>$HOME/login.tmp
cat /etc/passwd| awk -F '{ print $1 }'>$HOME/usuarios.tmp
cat /etc/passwd| awk -F '{ print ".",$1,"",$5 }'>$HOME/responsable.tmp
for i in `cat $HOME/usuarios.tmp`
        do
                let CONTADOR=CONTADOR+1
                if [ "$i" != "nfsnobody" ]
                then
                        VAR=`lastlog -u $i|grep -v User|gawk '{print NF}'`
                        if [ $VAR -gt 4 ]
                                then
                                        RESP=`cat $HOME/responsable.tmp|grep -w ". $i" | awk -F '{ print $2 }'`
                                        LOGIN=`lastlog -u $i|grep -v User|gawk '{print $(NF - 4), $(NF - 3), $NF, $(NF - 2)}'`
                                        echo "$CONTADOR;$i;$RESP;$LOGIN">>$HOME/login.tmp
                                else
                                        RESP=`cat $HOME/responsable.tmp|grep -w ". $i" | awk -F '{ print $2 }'`
                                        LOGIN=`lastlog -u $i|grep -v User|gawk '{print $(NF - 2), $(NF - 1), $NF}'`
                                        echo "$CONTADOR;$i;$RESP;$LOGIN">>$HOME/login.tmp
                                fi
                else
                        echo "$CONTADOR;nfsnobody;Anonymous NFS User;**Never logged in**">>$HOME/login.tmp
                fi
        done
mail -s "cuentas de usuario de $HOSTNAME" $LIST < $HOME/login.tmp
#rm -f $HOME/login.tmp
rm -f $HOME/responsable.tmp
rm -f $HOME/usuarios.tmp
