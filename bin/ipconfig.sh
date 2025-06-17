# 1) 호스트 이름 
SERVER=$(hostname)
cat << EOF
Linux IP 구성
    호스트 이름.....................: $SERVER

EOF

# 2) 이더넷 어뎁터 이름
NICS=$(nmcli device \
        | tail -n +2 \
        | grep -v '^lo' \
        | awk '{print $1}')

for NIC in $NICS
do
    # 3) CONNECTOIN 이름
    CON=$(echo $(nmcli device show $NIC \
        | grep 'GENERAL.CONNECTION:' \
        | awk -F: '{print $2}'))

    # 4) MAC 주소
    MAC=$(echo $(nmcli device show $NIC \
        | grep '^GENERAL.HWADDR:' \
        | awk -F'HWADDR:' '{print $2}'))

    # 5) DHCP 사용 유무
    DHCP=$(echo $(nmcli connection show $CON \
        | grep ipv4 | grep 'ipv4.method' \
        | awk -F: '{print $2}'))

    # 6) IP 주소
    IP=$(echo $(nmcli device show $NIC \
        | grep 'IP4.ADDRESS' \
        | awk -F: '{print $2}'))

    # 7) GW 주소
    GW=$(echo $(nmcli device show $NIC \
        | grep 'IP4.GATEWAY:' \
        | awk -F: '{print $2}'))

    # 8) DNS 주소
    DNS=$(echo $(nmcli device show $NIC \
        | grep 'IP4.DNS' \
        | awk -F: '{print $2}'))

    cat << EOF

    이더넷 어뎁터: $NIC
        컨넥션 이름.................: $CON
        물리적 주소.................: $MAC
        DHCP 사용 ..................: $DHCP
        IPv4 주소 ..................: $IP
        기본 게이트웨이.............: $GW
        DNS 서버....................: $DNS

EOF
done
