imap_blinker
============

`imap_blinker` blinks out unread messages counts for multiple email accounts in different colours, using a [blink(1)](http://thingm.com/products/blink-1.html)!

Requires 
--------

* Ruby 1.9
* `blink1-tool`. Grab it from [github](https://github.com/todbot/blink1).
* A config file (see below)

Usage
-----

Simply run: `imap_blinker` from the command line, or a cronjob or whatever.

Config
------

You'll need a YMAL config file in you home directory, it should be called `.imap_blinker.rc`.
Mine looks something like:

    work:
	    server: mail.mywork.com
	    port: 993
	    ssl: true
	    verify: false
	    mailbox: INBOX
	    username: my_work_username
	    password: my_secret_password
	    colour: '255,0,0'
	    enabled: true
	  gmail:
	    server: imap.gmail.com
	    port: 993
	    ssl: true
	    mailbox: INBOX
	    username: matt.p.foster@gmail.com
	    password: my_application_specific_password
	    colour: '0,255,0'
	    enabled: true
      
`server`, `mailbox`, `username`, `password` and `enabled` are required, and the other parameters are optional.
			
In order to keep things fairly simple, I designed the config to allow specifying most IMAP parameters but only the colours used by the blink(1)

Debugging
---------

There's currently very little in the way of error checking. If you need to debug anything, set the `BLINK_DEBUG` environment variable, which will cause IMAP debugging to be enabled, and unstopper blink1-tool's stdout and stderr streams. e.g.:

    BLINK_DEBUG=yes ./imap_blinker.rb  

