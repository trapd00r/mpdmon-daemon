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
# arbitary command to run on song change
my $cmd = "stumpish echo "; #stumpwm specific
# for xosd
my $xosd_font = '-*-profont-*-*-*-*-15-*-*-*-*-*-*-*';
#my $cmd = "osd_cat -f $xosd_font -A right -p bottom -c \"#a8ff00\" -s 3";

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
      system("$cmd \"$output\""); # for stumpish
      #system("printf \"$output\"|$cmd"); # for xosd
    }
    sleep 2;
  }
}

&monitor;
