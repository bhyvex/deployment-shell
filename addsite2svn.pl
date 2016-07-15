#!/usr/bin/perl
#
# Adds web-site content to subversion repository.
# ls339@njit.edu

use strict;

my $svnurl = "http://_CONFIGURE_URL_";
my $svnuser = "_CONFIGURE_USER_";
my $svnpass = "_CONFIGURE_PASSWORD_";

# Ask for directory we want to import.
print "What is the full path of directory you want to import into subversion? \n";
print "(Example : /sites/mysite/sites)\n";
chomp(my $workdir = <>);
# remove trailing slash if any.
$workdir = $1 if($workdir=~/(.*)\/$/);
	if ( !-d $workdir ){
		print "Directory $workdir does not exist \n";
		exit 1;
	}
# Ask for a site name.
print "Provide a short descriptive name for the site : (Example: regaine)\n";
chomp(my $sitename = <>);

# Ticket number or short note.
print "Provide a ticket number or a short message :\n";
chomp(my $message = <>);

# Create temporary subversion layout.
if ( -d "/tmp/$sitename" ){
	system("rm -rf /tmp/$sitename");
}
system("mkdir -p /tmp/$sitename/trunk /tmp/$sitename/tags /tmp/$sitename/branches");

# Copy files to new layout.
system("rsync -avz $workdir /tmp/$sitename/trunk");

# Import into subversion
system("svn --username=$svnuser --password=$svnpass import /tmp/$sitename $svnurl/$sitename -m \"Automated Import : $message\"");

# Replace $workdir with a svn copy.
print "Backing up $workdir .\n";
system("mv $workdir ${workdir}_backup");
system("mkdir $workdir");
system("svn co --username=$svnuser --password=$svnpass $svnurl/$sitename/trunk/sites/ $workdir/");
system("chown -R svnsync:users $workdir");
system("chmod -R 775 $workdir");
