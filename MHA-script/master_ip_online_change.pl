#!/usr/bin/env perl
use strict;
use warnings FATAL =>'all';

use Getopt::Long;

my $vip = '10.96.28.128/32';  # Virtual IP
my $key = "1";
my $ssh_start_vip = "/sbin/ifconfig bond0:$key $vip";
my $ssh_stop_vip = "/sbin/ifconfig bond0:$key down";
my $exit_code = 0;

my (
  $command,              $orig_master_is_new_slave, $orig_master_host,
  $orig_master_ip,       $orig_master_port,         $orig_master_user,
  $orig_master_password, $orig_master_ssh_user,     $new_master_host,
  $new_master_ip,        $new_master_port,          $new_master_user,
  $new_master_password,  $new_master_ssh_user,
);
GetOptions(
  'command=s'                => \$command,
  'orig_master_is_new_slave' => \$orig_master_is_new_slave,
  'orig_master_host=s'       => \$orig_master_host,
  'orig_master_ip=s'         => \$orig_master_ip,
  'orig_master_port=i'       => \$orig_master_port,
  'orig_master_user=s'       => \$orig_master_user,
  'orig_master_password=s'   => \$orig_master_password,
  'orig_master_ssh_user=s'   => \$orig_master_ssh_user,
  'new_master_host=s'        => \$new_master_host,
  'new_master_ip=s'          => \$new_master_ip,
  'new_master_port=i'        => \$new_master_port,
  'new_master_user=s'        => \$new_master_user,
  'new_master_password=s'    => \$new_master_password,
  'new_master_ssh_user=s'    => \$new_master_ssh_user,
);


exit &main();

sub main {

#print "\n\nIN SCRIPT TEST====$ssh_stop_vip==$ssh_start_vip===\n\n";

if ( $command eq "stop" || $command eq "stopssh" ) {

        # $orig_master_host, $orig_master_ip, $orig_master_port are passed.
        # If you manage master ip address at global catalog database,
        # invalidate orig_master_ip here.
        my $exit_code = 1;
        eval {
            print "\n\n\n***************************************************************\n";
            print "Disabling the VIP - $vip on old master: $orig_master_host\n";
            print "***************************************************************\n\n\n\n";
&stop_vip();
            $exit_code = 0;
        };
        if ($@) {
            warn "Got Error: $@\n";
            exit $exit_code;
        }
        exit $exit_code;
}
elsif ( $command eq "start" ) {

        # all arguments are passed.
        # If you manage master ip address at global catalog database,
        # activate new_master_ip here.
        # You can also grant write access (create user, set read_only=0, etc) here.
my $exit_code = 10;
        eval {
            print "\n\n\n***************************************************************\n";
            print "Enabling the VIP - $vip on new master: $new_master_host \n";
            print "***************************************************************\n\n\n\n";
&start_vip();
            $exit_code = 0;
        };
        if ($@) {
            warn $@;
            exit $exit_code;
        }
        exit $exit_code;
}
elsif ( $command eq "status" ) {
        print "Checking the Status of the script.. OK \n";
        `ssh $orig_master_ssh_user\@$orig_master_host \" $ssh_start_vip \"`;
        exit 0;
}
else {
&usage();
        exit 1;
}
}

# A simple system call that enable the VIP on the new master
sub start_vip() {
`ssh $new_master_ssh_user\@$new_master_host \" $ssh_start_vip \"`;
}
# A simple system call that disable the VIP on the old_master
sub stop_vip() {
`ssh $orig_master_ssh_user\@$orig_master_host \" $ssh_stop_vip \"`;
}

sub usage {
print
"Usage: master_ip_failover –command=start|stop|stopssh|status –orig_master_host=host –orig_master_ip=ip –orig_master_port=po
rt –new_master_host=host –new_master_ip=ip –new_master_port=port\n";
}