# /etc/puppet/manifests/site.pp
#

if versioncmp($::puppetversion,'3.6.1') >= 0 {

  $allow_virtual_packages = hiera('allow_virtual_packages',false)

  Package {
    allow_virtual => $allow_virtual_packages,
  }
}

$nagios_baseservices_template = 'monitoring/nagios/baseservices.erb'

if ( $hostname == 'devint1' ) {
  $cluster = 'devint1'
} elsif ($hostname == 'devint2' ) {
  $cluster = 'devint2'
} elsif ($hostname == 'devint3' ) {
  $cluster = 'devint3'
} elsif ($hostname == 'devint4' ) {
  $cluster = 'devint4'
} elsif ( $cluster_type == 'build-test' ) {
  $cluster = 'buildtest'
} elsif ( $hostname =~ /qa1|qa-search01|qa-msg-q01/ ) {
  $cluster = 'qa1'
} elsif ( $hostname =~ /qa2|qa-search02|qa-msg-q02/ ) {
  $cluster = 'qa2'
} elsif ( $hostname =~ /qa3vm|apiqa3vm/ ) {
  $cluster = 'qa3vm'
} elsif ( $hostname =~ /qa3$|qa-search03|qa-msg-q03/ ) {
  $cluster = 'qa3'
} elsif ( $hostname =~ /qa4|qa-search04|qa-msg-q04/ ) {
  $cluster = 'qa4'
} elsif ( $hostname =~ /dpuppet|dvm|qamonitor/ ) {
  $cluster = 'dev'
} elsif ( $hostname =~ /puppet-slave-r10k/ ) {
  $cluster = 'test'
} else {
  $cluster = 'c'
}

# The filebucket option allows for file backups to the server
filebucket { main: server => 'puppet'}

# don't distribute version control metadata
File { ignore => ['\.svn', '\.git', 'CVS' ] }

# Set global defaults - including backing up all files to the main filebucket and adds a global path
File { backup => main }
Exec { path   => "/usr/bin:/usr/sbin/:/bin:/sbin" }

# We don't put anything in classes
# import "classes/*"

# Load up site specific zones
#import "zones"

# run stages
stage { [pre, post]: }
Stage[pre] -> Stage[main] -> Stage[post]
#
#include stdlib
#include concat::setup
# Load up nodes
#import 'nodes'
# Load classes from hiera
hiera_include('classes')
# Load resources from hiera
hiera_resources('resources')
