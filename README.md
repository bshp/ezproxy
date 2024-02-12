#### OCLC EzProxy    
    
[License Agreement](https://help.oclc.org/Library_Management/EZproxy/Install_and_update_EZproxy/Install_and_update_self-hosted_EZproxy)
    
This build does not define a static VOLUME, EzProxy data is stored in /opt/ezproxy and you will need to map a volume to this location for persistance, e.g    
````
-v ezproxy_data:/opt/ezproxy
````
    
#### Base OS:    
Ubuntu Server LTS
    
#### Packages:    
Updated weekly from the official upstream Ubuntu LTS image
````
ca-certificates 
curl 
gnupg 
jq 
openssl 
tzdata 
unzip 
wget 
zip 
````
    
#### External Packages
    
EzProxy: https://help.oclc.org/Library_Management/EZproxy
    
#### Environment Variables:    
````
WSKEY = set this to your OCLC WS Key
````
see [Ocie Environment](https://github.com/bshp/ocie/blob/main/Environment.md) for more unrelated to ezproxy
    
#### Ports
see [EzProxy Ports Ingress](https://help.oclc.org/Library_Management/EZproxy/Get_started/How_many_ports_does_EZproxy_use)
    
#### Direct:  
````
docker run \
    --entrypoint /usr/sbin/ociectl \
    -h your_name.example.com
    -e WSKEY="your oclc key"
    -v ezproxy_data:/opt/ezproxy \
    -p 2048:2048 \
    -d bshp/ezproxy:latest \
    --run
````
#### Custom:  
Add at end of your entrypoint script either of:  
````
/usr/sbin/ociectl --run;
````
To bypass/disable Ocie, you will need to complete the initial setup 
````
# Generates initial config
/usr/local/ezproxy/ezproxy -d /opt/ezproxy -m;
# Installs license key
/usr/local/ezproxy/ezproxy -k "your_key";
# Run EzProxy
/usr/local/ezproxy/ezproxy -d /opt/ezproxy;
````
    
#### Build:  
OCIE_VERSION = Uses same Ubuntu version semantics, e.g 22.04, 24.04    
````
docker build . --pull --build-arg OCIE_VERSION=22.04 --tag YOUR_TAG
````
    
