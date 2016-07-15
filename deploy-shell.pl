#!/usr/bin/perl
#
# Custom login shell for deployment of web-site content.
# ls339@njit.edu

use Term::Menu;
use strict;

my $exit = 0;
while ($exit == 0) {

# Target web server host.
my $deploy_web_host = "_WEBHOST_";

# System user on the target web server host.
my $deploy_web_user = "_WEBUSER_";

# Target application server host.
my $deploy_app_host = "_APPHOST_";

# System user on the target application server host.
my $deploy_app_user = "_APPUSER_";

# Web server SVN sync script
my $web_svnsync = "_WEBSVNSYNC_";

# Application server SVN sync script
my $app_svnsync = "_APPSVNSYNC_";

# Web server control script location on target web server host.
my $httpdctl = "_HTTPDCTL_";

# Web site name.
my $site = "_SITE_";

# Application server control script location on target application server host.
my $jbossctl = "_JBOSSCTL_";

my $prompt = new Term::Menu;

my $answer = $prompt->menu(
        deploy_web  =>      ["Deploy $site code to $deploy_web_host", '1'],
        restart_web =>       ["Restart $site web servers on $deploy_web_host", '2'],
        deploy_app  =>      ["Deploy jboss content to $deploy_app_host", '3'],
        restart_app =>        ["Restart jboss servers on $deploy_app_host", '4'],
        exit_shell =>           ["Exit", '5']
);


if ( $answer eq "deploy_web" ) {
        print "\n";
        system("ssh $deploy_web_user\@$deploy_web_host -C $web_svnsync");
	print "\n";
}
elsif ( $answer eq "deploy_app" ) {
        print "\n";
	system("ssh $deploy_app_user\@$deploy_app_host -C $app_svnsync");
	#print "This function is disabled!";
	print "\n";
}
elsif ( $answer eq "restart_web" ) {
        print "\n";
	print "Restarting $deploy_web_host web servers . . .";
	system("ssh $deploy_web_user\@$deploy_web_host -C \"sudo -u root $httpdctl restart\"");
	print "\n";
}
elsif ( $answer eq "restart_app" ) {
        print "\n";
	system("ssh $deploy_app_user\@$deploy_app_host -C \"sudo -u root $jbossctl restart\"");
        #print "This function is disabled!";
        print "\n";
}

if ( $answer eq "exit_shell" ) {
        $exit = 1;
}

}
print "bye";
print "\n";
exit 0;

