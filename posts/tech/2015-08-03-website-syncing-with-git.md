---
title:  "Syncing websites with git"
categories: tech
tagline: "Documentation on running jglauche.de on my own server"
date: 2015-08-03 21:50:00
---

I have been in the tech industry for too long and if I have learned one thing, it is: ***Documentation is everything.***



I have put this blog on [github]{:target="_blank"}, but I've decided that I want it to run on my own server. I'm using [ruhoh] as blog engine. 

My traditional workflow when publishing local work would be this: 

- Connect to server via ssh or ftp
- choose correct directory
- create a new "revision" 
- ssh into the machine
- ln -s the app to the current revision
- test

With the blog engine I'm using and static content, I can pretty much trust that what I see in my development version will be what I will see at my production version (the one on my server). I don't have to worry about migrating databases too. 

To get started, I copied my whole directory to the server and set up my [nginx] to serve static pages. But I don't want to do this every time I do a commit and make it simpler. So my projected workflow looks like this:

- Git commit / push into master for any releases
- Server pulls automatically via cron job
- Server runs "ruhoh compile" after git pull

## What can go wrong?

So I want to automate this, so this means i need to think about what happens if... scenarios. But there arn't that many steps.

- Git pull on the server can fail. But if it does, it has no consequences apart from that the site doesn't get updated
- There is the possibility of a conflict. At this point I am noticing that I accidently put files in compiled/ into git as well, which might cause such conflct.
- ruhoh compile may fail, for example if filenames in posts/ do not have a properly formatted date. I should test it offline before pushing it.


## How I set it up

So, as I said before, I have copied the contents of jglauche.de onto my server to set it up. I did so before I uploaded it to git. It's located in

/home/jglauche/jglauche.de

So, first thing I need to check is if git pull works.


~~~~~~~~
jglauche@ext01:~/jglauche.de$ git pull
Permission denied (publickey).
fatal: The remote end hung up unexpectedly
~~~~~~~~

Of course. Github does not have a public key from my server. So, let's check if there's any
~~~~~~~~
$cd /home/jglauche/.ssh
$ls
authorized_keys known_hosts
~~~~~~~~

Nope. I need to generate one with

~~~~~~~~
$ssh-keygen
~~~~~~~~

So, this creates two files, by default at **id_rsa** and **id_rsa.pub**. First one is the private key, latter is the public key. We need to copy it from the console:

~~~~~~~~
jglauche@ext01:~/.ssh$ cat id_rsa.pub 
~~~~~~~~

You can add keys on github under Settings -> SSH keys. After doing so, I should be able to pull:

~~~~~~~~
jglauche@ext01:~/jglauche.de$ git pull
Already up-to-date.
~~~~~~~~

Yes, that works!

Next step would be to check if ruhoh is installed and if it runs correctly.

~~~~~~~~
jglauche@ext01:~/jglauche.de$ bundle exec ruhoh compile
~~~~~~~~

Yes, works too! I made a small [script]{:target="_blank"} which I will put in my crontab via

~~~~~~~~
jglauche@ext01:~/jglauche.de$ crontab -e

*/20 * * * * /home/jglauche/jglauche.de/update_site.sh
~~~~~~~~

So for now I will have it try to update every 20 minutes. 

## Notes

- The shell script is stupid and will re-compile the site every time, even if there was no change. I am currently fine with that, but I might change that behaviour at a later time.
- I still have the compiled directory inside the github, I should remove that at a later time.










[github]: https://github.com/Joaz/jglauche.de
[ruhoh]: http://ruhoh.com/
[nginx]: http://nginx.org/
[script]: https://github.com/Joaz/jglauche.de/blob/master/update_site.sh


