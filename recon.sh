#!/bin/bash 

#requires hakrawler, gospider

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
printf "Getting subdomains"
gobuster dns -d $domain -w /usr/share/wordlists/amass/subdomains-top1mil-5000.txt > subdomains.txt
printf "Spidering"
gospider -s $url > spider.txt
printf "Hakrawler"
echo $domain | hakrawler > hakrawler.txt
printf "Initial port scan"
nmap -sC -sV -iL ip.txt -oN initial_nmap.txt
