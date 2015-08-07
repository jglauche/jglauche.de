---
title:  "Sorting problems with ruhoh"
categories: tech
tagline: ""
date: 2015-08-07 21:35:00
---

So, today I learned that Ruhoh orders posts in alphabetical order. And according to the documentation, it is a [simple thing]{:target="_blank"} to change that behaviour. I have added this to the config.yml for the collection "posts":

~~~~~~~~
"posts":
		"sort" : ["date", "desc"]
~~~~~~~~

But nope. Does still order alphabetical. 

### The solution

I had disabled local file backups in gedit at some point, because it would also show posts with *.md~* ending. What I didn't notice was, that I had a backup of the config.yml and ruhoh is parsing the *config.yml~* file too! 

The fix:

~~~~~~~~
rm config.yml~
~~~~~~~~

*facepalm*


[simple thing]: http://ruhoh.com/docs/2/pages/#toc_53
