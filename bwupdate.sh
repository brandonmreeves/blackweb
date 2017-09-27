#!/bin/bash
### BEGIN INIT INFO
# Provides:	     blackweb
# Required-Start:    $local_fs $remote_fs $network $syslog $named
# Required-Stop:     $local_fs $remote_fs $network $syslog $named
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts blackweb update
# Description:       starts blackweb using start-stop-daemon
### END INIT INFO

# by:	maravento.com and novatoz.com

# Language spa-eng
cm1=("Este proceso puede tardar mucho tiempo. Sea paciente..." "This process can take a long time. Be patient...")
cm2=("Verifique su conexion a internet" "Check your internet connection")
test "${LANG:0:2}" == "es"
es=$?

clear
echo
echo "Blackweb Project"
echo "${cm1[${es}]}"

# DATE
date=`date +%d/%m/%Y" "%H:%M:%S`

# PATH
bw=~/blackweb
route=/etc/acl

# REGEXD
regexd='([a-zA-Z0-9][a-zA-Z0-9-]{1,61}\.){1,}(\.?[a-zA-Z]{2,}){1,}'

# DELETE OLD REPOSITORY
if [ -d $bw ]; then rm -rf $bw; fi
                                                                                                                                                                                   
# CREATE PATH
if [ ! -d $route ]; then mkdir -p $route; fi

# GIT CLONE BLACKWEB
echo
echo "Downloading Blackweb..."
git clone --depth=1 https://github.com/maravento/blackweb.git  >/dev/null 2>&1
echo "OK"

# CHECKING SUM
echo
echo "Checking Sum..."
cd $bw/bl
cat blackweb.tar.gz* | tar xzf -
a=$(md5sum blackweb.txt | awk '{print $1}')
b=$(cat blackweb.md5 | awk '{print $1}')
	if [ "$a" = "$b" ]
	then 
		echo "Sum Matches"
		cd ..
		sed -e '/^#/d' blackurls.txt | sort -u >> bl/bltmp.txt
		rm bl/blackweb.md5 bl/blackweb.tar.gz*
		echo "OK"
	else
		echo "Bad Sum. Abort"
		echo "${cm2[${es}]}"
		cd
		rm -rf $bw
		exit
fi

# DOWNLOADING BLACKURLS
echo
echo "Downloading Blacklist URLs..."

# FILES
function blurls() {
    wget -q -c --retry-connrefused -t 0 "$1" -O - | sort -u >> bl/bltmp.txt
}
	blurls 'http://pgl.yoyo.org/adservers/serverlist.php?hostformat=nohtml' && sleep 1
	blurls 'http://malwaredomains.lehigh.edu/files/justdomains' && sleep 1
	blurls 'https://easylist-downloads.adblockplus.org/malwaredomains_full.txt' && sleep 1
	blurls 'https://zeustracker.abuse.ch/blocklist.php?download=squiddomain' && sleep 1
	blurls 'http://winhelp2002.mvps.org/hosts.txt' && sleep 1
	blurls 'https://raw.githubusercontent.com/oleksiig/Squid-BlackList/master/denied_ext.conf' && sleep 1
	blurls 'http://www.joewein.net/dl/bl/dom-bl-base.txt' && sleep 1
	blurls 'http://www.joewein.net/dl/bl/dom-bl.txt' && sleep 1
	blurls 'http://www.malwaredomainlist.com/hostslist/hosts.txt' && sleep 1
	blurls 'http://adaway.org/hosts.txt' && sleep 1
	blurls 'https://openphish.com/feed.txt' && sleep 1
	blurls 'http://cybercrime-tracker.net/all.php' && sleep 1
	blurls 'https://ransomwaretracker.abuse.ch/downloads/RW_URLBL.txt' && sleep 1
	blurls 'https://ransomwaretracker.abuse.ch/downloads/RW_DOMBL.txt' && sleep 1
	blurls 'http://hosts-file.net/download/hosts.txt' && sleep 1
	blurls 'http://osint.bambenekconsulting.com/feeds/dga-feed.txt' && sleep 1
	blurls 'http://malc0de.com/bl/ZONES' && sleep 1
	blurls 'https://db.aa419.org/fakebankslist.php' && sleep 1
	blurls 'https://raw.githubusercontent.com/mitchellkrogza/nginx-ultimate-bad-bot-blocker/master/_generator_lists/bad-referrers.list' && sleep 1
	blurls 'https://raw.githubusercontent.com/mitchellkrogza/The-Big-List-of-Hacked-Malware-Web-Sites/master/.dev-tools/_strip_domains/domains.txt' && sleep 1
	blurls 'https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt' && sleep 1
	blurls 'http://www.taz.net.au/Mail/SpamDomains' && sleep 1
	blurls 'http://www.carl.net/spam/access.txt' && sleep 1
	blurls 'https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn-social/hosts' && sleep 1
    blurls 'https://hosts.ubuntu101.co.za/domains.list' && sleep 1
	#blurls 'http://someonewhocares.org/hosts/hosts' # replaced by StevenBlack Host
	#blurls 'https://raw.githubusercontent.com/azet12/KADhosts/master/KADhosts.txt' # replaced by StevenBlack Host
	#blurls 'https://raw.githubusercontent.com/mitchellkrogza/Badd-Boyz-Hosts/master/PULL_REQUESTS/domains.txt' # replaced by StevenBlack Host
	#blurls 'http://www.passwall.com/blacklist.txt' # SERVER DOWN

function malwaredomains() {
    wget -q -c --retry-connrefused -t 0 "$1" && unzip -p domains.zip >> bl/bltmp.txt
}
	malwaredomains 'http://www.malware-domains.com/files/domains.zip' && sleep 1

# DIR
function shalladsi() {
    wget -q -c --retry-connrefused -t 0 "$1" && for F in *.tar.gz; do R=$RANDOM ; mkdir bl/$R ; tar -C bl/$R -zxvf $F -i; done >/dev/null 2>&1
}
	shalladsi 'http://www.shallalist.de/Downloads/shallalist.tar.gz' && sleep 2
	shalladsi 'http://dsi.ut-capitole.fr/blacklists/download/blacklists.tar.gz' && sleep 2

function squidguard() {
    wget -q -c --retry-connrefused -t 0 "$1" && for F in *.tgz; do R=$RANDOM ; mkdir bl/$R ; tar -C bl/$R -zxvf $F -i; done >/dev/null 2>&1
}
	squidguard 'http://squidguard.mesd.k12.or.us/blacklists.tgz' && sleep 2

#function urlblacklist() {
    #wget -q -c --retry-connrefused -t 0 "$1" -O bigblacklist.tar.gz && for F in bigblacklist.tar.gz; do R=$RANDOM ; mkdir bl/$R ; tar -C bl/$R -zxvf $F -i; done >/dev/null 2>&1
#}
	#urlblacklist 'http://urlblacklist.com/cgi-bin/commercialdownload.pl?type=download&file=bigblacklist' # SERVER DOWN

echo "OK"

# DOWNLOADING WHITEURLS
echo
echo "Downloading Whitelist URLs..."

function remoteurl() {
    wget -q -c --retry-connrefused -t 0 "$1" -O - | sed -e '/^#/d' | sort -u >> whiteurls.txt
}
	remoteurl 'https://raw.githubusercontent.com/maravento/remoteip/master/remoteurls.txt' && sleep 1

function univ() {
    wget -q -c --retry-connrefused -t 0 "$1" -O - | egrep -oi "$regexd" | awk '{print "."$1}' | grep -Pvi '(.htm(l)?|.the|.php(il)?)$' | sort -u | sed 's:\(www[[:alnum:]]*\.\|WWW[[:alnum:]]*\.\|ftp\.\|\.\.\.\|/.*\)::g' >> whiteurls.txt
}
    univ 'https://raw.githubusercontent.com/Hipo/university-domains-list/master/world_universities_and_domains.json' && sleep 1

function centralwl() {
    wget -q -c --retry-connrefused -t 0 "$1" -O - | awk '{print "."$1}' | sort -u | sed 's:\(www[[:alnum:]]*\.\|WWW[[:alnum:]]*\.\|ftp\.\|\.\.\.\|/.*\)::g' >> whiteurls.txt
}
	centralwl 'https://raw.githubusercontent.com/mitchellkrogza/CENTRAL-REPO.Dead.Inactive.Whitelisted.Domains.For.Hosts.Projects/master/whitelist-domains.txt' && sleep 1

echo "OK"

# DOWNLOADING WHITETLDS
echo
echo "Downloading Whitelist TLDs..."

function iana() {
    wget -q -c --retry-connrefused -t 0 "$1" -O - | sed 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/' | sed -e '/^#/d' | sed 's/^/./' | sort -u >> whitetlds.txt
}
	iana 'https://data.iana.org/TLD/tlds-alpha-by-domain.txt' && sleep 1

function publicsuffix() {
    wget -q -c --retry-connrefused -t 0 "$1" -O - | grep -v "//" | grep -ve "^$" | sed 's:\(.*\):\.\1:g' | sort -u | grep -v -P "[^a-z0-9_.-]" >> whitetlds.txt
}
	publicsuffix 'https://publicsuffix.org/list/public_suffix_list.dat' && sleep 1

echo "OK"

# DOWNLOADING INVALID DOMAINS
echo
echo "Downloading Invalid Domains..."

function centralinvalid() {
    wget -q -c --retry-connrefused -t 0 "$1" -O - | awk '{print "."$1}' | sort -u | sed 's:\(www[[:alnum:]]*\.\|WWW[[:alnum:]]*\.\|ftp\.\|\.\.\.\|/.*\)::g' >> invalid.txt
}
	centralinvalid 'https://raw.githubusercontent.com/mitchellkrogza/CENTRAL-REPO.Dead.Inactive.Whitelisted.Domains.For.Hosts.Projects/master/dead-domains-ALL-combined.txt' && sleep 1

function centralfalse() {
    wget -q -c --retry-connrefused -t 0 "$1" -O - | awk '{print "."$1}' | sort -u | sed 's:\(www[[:alnum:]]*\.\|WWW[[:alnum:]]*\.\|ftp\.\|\.\.\.\|/.*\)::g' >> invalid.txt
}
	centralfalse 'https://raw.githubusercontent.com/mitchellkrogza/CENTRAL-REPO.Dead.Inactive.Whitelisted.Domains.For.Hosts.Projects/master/false-positives.txt' && sleep 1

echo "OK"

# CAPTURING DOMAINS
echo
echo "Capturing Domains..."
find bl -type f -execdir egrep -oi "$regexd" {} \; | awk '{print "."$1}' | sort -u | sed 's:\(www[[:alnum:]]*\.\|WWW[[:alnum:]]*\.\|ftp\.\|\.\.\.\|/.*\)::g' > bl.txt
echo "OK"

# DEBUGGING BLACKWEB
echo
echo "Debugging Blackweb..."
sed -e '/^#/d' whitetlds.txt | sort -u > tlds.txt
sed -e '/^#/d' {invalid,whiteurls}.txt | sort -u > urls.txt
chmod +x parse_domain.py
python parse_domain.py | sort -u > blackweb.txt

# COPY ACL TO PATH
cp -f blackweb.txt $route >/dev/null 2>&1
sed -e '/^#/d' blackdomains.txt >> $route/blackdomains.txt >/dev/null 2>&1 && sort -o $route/blackdomains.txt -u $route/blackdomains.txt >/dev/null 2>&1
sed -e '/^#/d' whitedomains.txt >> $route/whitedomains.txt >/dev/null 2>&1 && sort -o $route/whitedomains.txt -u $route/whitedomains.txt >/dev/null 2>&1

# LOG
echo "Blackweb for Squid: Done $date" >> /var/log/syslog

# END
cd
rm -rf $bw
echo "Done"
