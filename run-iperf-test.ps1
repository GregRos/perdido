Set-PSDebug -Trace 1
iperf3 -c perdido.bond -p 7871 `
    --username gr `
    --rsa-public-key-path ./perdido.iperf.public.pem `
    --reverse `
    --time 36000 `
    --pacing-timer 300M `
    --bitrate 100M `
    --interval 60 `
    --format M