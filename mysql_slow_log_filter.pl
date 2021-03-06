#!/usr/bin/perl 

#
# This perl script parses a MySQL slow_queries log file
# ignoring all queries less than $min_time and prints
# out how many times a query was greater than $min_time
# with the seconds it took each time to run.
#
# Usage: msql_slow_log_filter -T timesec -R numrows < logfile
#

use Getopt::Std;


getopt ('TR');

$min_time       = $opt_T;	# Skip queries less than $min_time
$max_display    = 0;	# Truncate display if more than $max_display occurances of a query
$max_rows	= $opt_R;    #Skip queries less than $max_rows
 
print "\n Starting... \n";

$query_string   = '';
$time           = 0;
$new_sql        = 0;


##############################################
# Loop Through The Logfile
##############################################

while (<>) {

	# Skip Bogus Lines
	next if ( m|/.*mysqld, Version:.+ started with:| );
	next if ( m|Tcp port: \d+  Unix socket: .*mysql.sock| );
	next if ( m|Time\s+Id\s+Command\s+Argument| );
	next if ( m|User@Host:| );

	# # Query_time: 790  Lock_time: 0  Rows_sent: 3400617  Rows_examined: 3400617
	if ( /Query_time:\s+(.*)\s+Lock_time:\s+(.*)\s+Rows_examined:\s+(.*)/ ) {
	# if ( /Query_time:\s+(\d+)\s+Lock_time:\s+(\d+).*Rows_examined:\s+(\d+)/ ) {
		$time    = $1;
		$rows	 = $3;
		if ( ( defined ($min_time) &&  $time >= $min_time) || ( defined ($max_rows) && $rows >= $max_rows ) ) {
			$passed_test = 1;
			print $_;
		} else {
			$passed_test = 0;
		}
		next;

	}

	print $_ if ($passed_test);
	next;
}


exit(0);
