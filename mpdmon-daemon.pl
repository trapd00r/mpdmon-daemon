#!/usr/bin/perl
use strict;
#mpdmon-daemon
# Copyright (C) Magnus Woldrich 2010
# This version of mpdmon daemonizes itself, and executes arbitary
# commands on song change. I use the stumpish application for notifying 
# me (part of stumpwm, contrib/).

use Proc::Daemon;
use Audio::MPD;

my $mpd = Audio::MPD->new;
my $cmd = "stumpish echo "; #change this to whatever you want
sub monitor {
  my $np = "";
  print "Daemonizing...\n";
  Proc::Daemon::Init;
  while(1) {
    my $current = $mpd->current;
    my $output = sprintf("%s (%s) %s", $mpd->current->artist,
                 $mpd->current->album, $mpd->current->title);

    if("$np" ne "$current") {
      $np = $current;
      system("$cmd \"$output\"");
    }
    sleep 2;
  }
}

&monitor;
