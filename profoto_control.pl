#!/usr/bin/perl

use Profoto;
#use Data::Dumper;
#use IPC::Run qw( start );

my $profoto = Profoto->new();

while (1) {
	print "READ ", $profoto->enableHead(A), "\n";
	print "READ ", $profoto->enableHead(B), "\n";
	sleep 1;

	for (my $var = 30; $var < 101; $var++) {
		my $val = sprintf '%.1f', ($var/10);
		print "READ ", $profoto->setHeadValue(A, $val), "\n";
		print "READ ", $profoto->setHeadValue(C, $val), "\n";
	}


	print "READ ", $profoto->setHeadValue(A, 4.0), "\n";
	print "READ ", $profoto->setHeadValue(B, 5.0), "\n";
	
	print "READ ", $profoto->enableHead(A), "\n";
	print "READ ", $profoto->disableHead(B), "\n";
	sleep 1;
	print "READ ", $profoto->flash, "\n";
	
	print "READ ", $profoto->disableHead(A), "\n";
	print "READ ", $profoto->enableHead(B), "\n";
	sleep 1;
	print "READ ", $profoto->flash, "\n";
}

# 
# FF 26 0D 	23 22 3E 0D 	FF 20 0D 	FF 23 0D
# FF 26 0D 	23 22 3F 0D 	FF 20 0D 	FF 23 0D
# FF 26 0D 	23 22 40 0D 	FF 20 0D 	FF 23 0D
# FF 26 0D 	23 22 41 0D 	FF 20 0D 	FF 23 0D
# FF 26 0D 	23 22 42 0D 	FF 20 0D 	FF 23 0D
# FF 26 0D 	23 22 43 0D 	FF 20 0D 	FF 23 0D
# FF 26 0D 	23 22 44 0D 	FF 20 0D 	FF 23 0D
# FF 26 0D 	23 22 45 0D 	FF 20 0D 	FF 23 0D
# FF 26 0D 	23 22 46 0D 	FF 20 0D 	FF 23 0D
# FF 26 0D 	23 22 47 0D 	FF 20 0D 	FF 23 0D
# FF 26 0D 	23 22 48 0D 	FF 20 0D 	FF 23 0D 
# 
# 			23 25 = D
# ACK?		23 24 = C		Ready2recv?	BEEP
# 			23 23 = B
# 			23 22 = A


