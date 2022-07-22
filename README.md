# Perdido

Hi, I'm Perdido. I'm a seedbox, streaming server, and more! I'm really talented.

Here is a list of services I host:

* **For torrenting** I run [rTorrent](https://github.com/rakshasa/rtorrent) (backend) and [ruTorrent](https://github.com/Novik/ruTorrent) (frontend). ruTorrent uses PHP, so I also have that installed.
* **For auto-sorting downloads** I use my [sweeper](https://github.com/GregRos/sweeper), which is a custom python script. That script uses [filebot](https://www.filebot.net/) behind the scenes in some cases.
* **For video streaming,** I run [Jellyfin](https://github.com/jellyfin/jellyfin).
* **For file transfer,** I support SCP, SFTP, FTP (TLS only). I also host [filestash](https://github.com/mickael-kerjean/filestash) for web access.

To tie this all together I use [nginx](https://nginx.org/), acting as a reverse proxy. Neat, right?

By the way, ever since I moved in to my neighborhood and started torrenting, I've been getting all kinds of nasty callers. Just look at this page from my journal:

![image-20220722225226070](C:\Users\GregRosenbaum\AppData\Roaming\Typora\typora-user-images\image-20220722225226070.png)

I don't know any of these kiddies! They all just ring my SSH, say `root`, and then run away! A few of them even tried to convince me to use SHA1. How horrid.

More importantly, though - the racket! I could barely sleep with all these callers. At least, not until I installed [fail2ban](https://www.fail2ban.org/wiki/index.php/Main_Page). And it worked like a charm, just like the testimonials said it would. It really helps keeping the more rambunctious ones at bay. Let's see who's on my naughty list right now:

```json
[{'sshd': ['218.92.0.204']}, {'vsftpd': []}]
```

Oh, that's `218.92.0.204` from earlier! I hope they've learned their lesson.

I couldn't stop just with that, though. Sure, `fail2ban` protects by FTP and SSH, but I wanted to be sure my nginx is safe too. So I compiled [ModSecurity](https://github.com/SpiderLabs/ModSecurity) and even got some [rules](https://owasp.org/www-project-modsecurity-core-rule-set/) for it. I hooked that all up and got it purring like a kitten.

I also have [UFW](https://help.ubuntu.com/community/UFW). It creates a kind of force-field around my house and makes sure no one can talk to my internal services. Why, if that were to happen, my reputation would be ruined!

Whew. All that work made me work up quite a sweat, and I really wanted some recognition for my efforts, so I went and got an official [LetsEncrypt](https://letsencrypt.org/) certificate. From now on, if someone offers me some unencrypted traffic - I just say no.

I also managed to get an `IPSec/IKEv2` VPN to work as a separate network interface. That was a lot of work but I ended up not using it. My current landlord is a lot nicer than my previous one.

# A few other tricks

* I try to use symlinks a lot for configuration files. However, some config files can't be symlinks, so I copy instead.

# Structure

```bash
- config # text config files for different services
- data # binary files, encrypted files, etc
- installer # python installer code
- scripts # invoked by things after installation
- steps # bash scripts that install all the programs
```

# Installation

Requires Debian 11 and Python 3.9. All other requirements are installed by the script.

```bash
git clone git@github.com:GregRos/perdido.git /opt/perdido
cd /opt/perdido
./install install
```

Perdido includes a handy CLI for running some of the stages separately. For example:

```
./install run 3,50,docker,51- rtorrent
```

The above would only run the scripts:

* `03.docker.bash`
* `31.rtorrent.bash`
* `50.ftp.bash`
* Scripts with ID `51+`.

It will still run them in ascending order, not in the specified order.

Perdido is not containerized and expects to run on a VM or physical machine.

# Configuration

Some services still need to be configured manually after the installation:

1. Jellyfin
2. Filestash



