#! /usr/bin/env ruby
#
# imap_blinker - blink unread messages counts for multiple accounts, with DIFFERENT COLOURS!
#
# Matt Foster <mpf@hackerific.net>
#


require 'net/imap'
require 'yaml'

# We rely on the blink(1) command line tool to control the dongle
def build_command(settings, count=1)
  [ 'blink1-tool', 
    # colour or color should keep those Americans happy :)
    "--rgb #{settings['colour'] || settings['color']}",
    "--blink #{count}",
    # Stay silent
    ENV['BLINK_DEBUG'] ? '' : "2>&1 > /dev/null"
  ].join(' ')
end

# Load a yaml config, then iterate through each section of config
config = YAML.load_file(File.expand_path('~/.imap_blinker.rc'))

# Each section contains settings for a single account...
config.each do |profile, settings|

  # ...and can be disabled by setting enabled: false
  next unless settings['enabled']

  imap = Net::IMAP.new(
    settings['server'], 
    # Port 143 for IMAP, 993 for IMAPS
    settings.fetch('port', 143),
    # toggle TLS
    settings.fetch('ssl', false),
    # ca cert path or file
    settings.fetch('certs', nil), 
    # toggle SSL verification
    settings.fetch('verify', true)
  )

  # Enable debugging if that's what we want
  Net::IMAP::debug = true if ENV['BLINK_DEBUG']

  imap.login(settings['username'], settings['password'])
 
  # Get unread messages count for the specified mailbox
  # We could count MESSAGES or RECENT too (lots of blinking!)
  status = imap.status(settings['mailbox'], [ 'UNSEEN' ])

  # and finally blink out the number of messages
  if status['UNSEEN'] > 0
    cmd = build_command(settings, status['UNSEEN'])
    # Print the command we're about to run, if debugging
    $stderr.puts cmd if ENV['BLINK_DEBUG']
    system(cmd)
  end
end


