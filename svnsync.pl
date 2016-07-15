#!/usr/bin/perl
#
# Checks out code from a subversion repository.
# This script is called from the svnsync-shell script.
# ls339@njit.edu

use IO::File;
use strict;

my $svnurl = "_SVNURL_";
my $workingdir = "_WORKDIR_";
my $errorlog = "/tmp/_SITENAME_-svnsync.error";
my $svnuser = "_SVNUSER_";
my $svnpass = "_SVNPASS_";
my $timestamp = localtime time;

print "############- $timestamp -############\n";
system("/usr/bin/svn info $workingdir");
system("/usr/bin/svn --username=$svnuser --password=$svnpass co $svnurl $workingdir");
my $checkoutstat = $?;
print "######################################################\n\n";

# Error trap for monitoring checks.
if ( $checkoutstat != 0 ) {
	print "Subversion checkout from $svnurl failed!\n";
	my $file = IO::File->new("$errorlog",">>") or die $!;
	print $file "$timestamp : Subversion checkout from $svnurl failed!\n"; 
	print $file "$timestamp : Error code : $checkoutstat \n";
	$file->close();
}
