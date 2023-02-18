#!/bin/bash 

#requires gospider,amass,nmap,assetfider,subfinder

read -p "domain: " domain
url="https://$domain"
mkdir recon
cd recon
printf "Starting enumeration on ${domain}"
nslookup $domain | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' > ip.txt
printf "Found:"
cat ip.txt
while read ip
do
     whois -r $ip >> whois.txt
     whois -h whois.cymru.com $ip >> whois.txt
done<ip.txt
amass enum -d $domain >amass.txt
printf "Getting subdomains"
subfinder -d $domain > temp.txt
assetfinder -subs-only $domain >> temp.txt
sort subs.txt | uniq > subs.txt
rm temp.txt 
cat subs.txt
#gobuster dns -d $domain -w /usr/share/wordlists/amass/subdomains-top1mil-5000.txt > subdomains.txt
printf "Spidering"
gospider -s $url > spider.txt
echo "Done"
echo "Initial port scan"
nmap -sC -sV -iL ip.txt -oN initial_nmap.txt
echo "Scan complete."

