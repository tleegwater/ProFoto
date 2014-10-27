#!/usr/bin/perl

package Profoto;

use strict;
use warnings;

use Device::SerialPort;
use Data::Dumper;

our $VERSION = '0.1';

sub new {
  my $class = shift;
  my $dev = `ls /dev/tty.usb*|head -1`;
  chomp($dev);
  my $serial = Device::SerialPort->new($dev) || die "$!";

  $serial->databits(8);
  $serial->baudrate(115200);
  $serial->parity("none");
  $serial->stopbits(1);

  my $self = {};
  $self->{serial} = $serial;
  print "Connected to Profoto", "\n";
  bless($self, $class);
  return($self);
}


sub enableHead {
  my $self = shift;

  my $head = shift;

  my %map = (
        A => '22',
        B => '25',
        C => '28',
        D => '2B',
  );

  print "Enabling head: $head\n";

  my @cmd = (0x20, hex($map{$head}), 0x0D);
  my $cmdString = '';
  foreach (@cmd) {
        $cmdString .= chr $_;
  }

  print "Sending: ".unpack 'H*', $cmdString;
  print "\n";
  $self->{serial}->write($cmdString);
 
  select(undef, undef, undef, 0.05); 
  return unpack 'H*', $self->{serial}->read(255); 
}


sub disableHead {
  my $self = shift;
  my $head = shift;

  my %map = (
        A => '21',
        B => '24',
        C => '27',
        D => '2A',
  );

  print "Disabling head: $head\n";

  my @cmd = (0x20, hex($map{$head}), 0x0D);
  my $cmdString = '';
  foreach (@cmd) {
        $cmdString .= chr $_;
  }

  print "Sending: ".unpack 'H*', $cmdString;
  print "\n";
  $self->{serial}->write($cmdString);
 
  select(undef, undef, undef, 0.05); 
  return unpack 'H*', $self->{serial}->read(255); 
}

sub setHeadValue {
  my $self = shift;
  my $head = shift;
  my $headValue = shift;

  my %map = (
        A => '22',
        B => '23',
        C => '24',
        D => '25',
  );

  my $cmdValue = sprintf("%02X", int(($headValue *10)+32)); 

  print "Setting head ".$head." to ".$headValue."\n";

  my @cmd = (0x23, hex($map{$head}), hex($cmdValue), 0x0D);
  my $cmdString = '';
  foreach (@cmd) {
        $cmdString .= chr $_;
  }

  print "Sending: ".unpack 'H*', $cmdString;
  print "\n";
  $self->{serial}->write($cmdString);
 
  select(undef, undef, undef, 0.05); 
  return unpack 'H*', $self->{serial}->read(255); 
}

sub flash {
  my $self = shift;
  print "Flash!\n";
  my @cmd = (0x22, 0x28, 0x0D);
  my $cmdString = '';
  foreach (@cmd) {
        $cmdString .= chr $_;
  }

  print "Sending: ".unpack 'H*', $cmdString;
  print "\n";
  $self->{serial}->write($cmdString);
  select(undef, undef, undef, 0.05); 
  return unpack 'H*', $self->{serial}->read(255); 
}

