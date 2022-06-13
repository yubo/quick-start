echo "geoip_demo:1|g|#env:prod,city:beijing,instance:1.1.1.1.80,latitude:32.321941,longitude:118.297783" | nc -w 1 -u localhost 8125
echo "geoip_demo:1|g|#env:prod,city:Karlstad,instance:89.160.20.128,latitude:59.3974,longitude:13.5055" | nc -w 1 -u localhost 8125
