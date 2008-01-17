#
# Preprocess.pm
#
# (C) 2007, 2008 Francesco Salvestrini <salvestrini@users.sourceforge.net>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#

package Sitetool::Preprocess;

use 5.8.0;

use warnings;
use strict;
use diagnostics;

use Sitetool::Autoconfig;
use Sitetool::Base::Trace;
use Sitetool::Base::Debug;
use Sitetool::OS::File;

BEGIN {
    use Exporter ();
    our ($VERSION, @ISA, @EXPORT);
    
    @ISA    = qw(Exporter);
    @EXPORT = qw(&preprocess);
}

sub preprocess_helper ($$)
{
    my $file       = shift;
    my $string_ref = shift;

    assert(defined($file));
    assert(defined($string_ref));

    if (!file_ispresent($file)) {
	error("File \`" . $file . "' doesn't exists");
	return 0;
    }

    my $filehandle;
    debug("Opening filehandle for file \`" . $file . "'");
    if (!open($filehandle, "<", $file)) {
	error("Cannot open file \`" . $file . "' for reading");
	return 0;
    }
    
    my $line;
    my $string;

    $line   = 0;
    $string = "";
    while (<$filehandle>) {
	$line++;

	my $tmp;
	$tmp = $_;
	chomp($tmp);

	debug("  Got line \`" . $tmp . "'");
	if ($tmp =~ m/^[ \t]*$/) {
	    # Skip empty lines
	} elsif ($tmp =~ m/^[ \t]*\#.*$/) {
	    # Skip comments
	} elsif ($tmp =~ m/^[ \t]*include[ \t]*\"(.*)\"[ \t]*$/) {
	    # Handle file inclusion

	    assert(defined($1));

	    my $include_file;
	    $include_file = File::Spec->rel2abs($1);
		
	    debug("Including file \`" . $1 . "'");
	    if (!&preprocess_helper($include_file, \$string)) {
		error("Cannot include file \`" . $include_file . "'");
		return 0;
	    }
	} elsif ($tmp =~ m/^.*\\[ \t]*$/) {
	    # Handle multi-line as a single line
	    $tmp =~ s/\\[ \t]*$//;
	    $string = $string . $tmp;
	} else {
	    # Get the line as it is
	    $string = $string . $tmp . "\n";
	}
    }

    debug("Closing filehandle for file \`" . $file . "'");
    close($filehandle);

    ${$string_ref} = ${$string_ref} . $string;

    return 1;
}

sub preprocess ($$)
{
    my $input_filename = shift;
    my $string_ref     = shift;

    assert(defined($input_filename));
    assert(defined($string_ref));

    debug("Preprocessing file \`" . $input_filename . "' to string");

    ${$string_ref} = "";
    if (!preprocess_helper($input_filename, $string_ref)) {
	error("Cannot preprocess file \`" . $input_filename . "'");
	return 0;
    }
    assert(defined(${$string_ref}));

    debug("Preprocessing completed successfully");
    
    return 1;
}

1;
