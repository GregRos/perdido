echo GETTING IPERF PUBLIC KEY VIA SSH

ssh gr@perdido.bond "cat /etc/iperf/rsa/public.pem" > ./perdido.iperf.public.pem

echo WROTE TO ./perdido.iperf.public.pem
