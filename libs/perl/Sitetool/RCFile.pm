#
# RCFile.pm
#
# Copyright (C) 2007, 2008 Francesco Salvestrini
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

package Sitetool::RCFile;

use 5.8.0;

use warnings;
use strict;
use diagnostics;

use Sitetool::Autoconfig;
use Sitetool::Base::Debug;
use Sitetool::OS::File;

sub new ($$)
{
    my $class    = shift;
    my $filename = shift;

    assert(defined($class));
    assert(defined($filename));

    my $self = { };

    $self->{FILENAME} = $filename;
    $self->{HOSTS}    = { };

    bless $self, $class;

    return $self;
}

sub correct ()
{
    my $self = shift;

    assert(defined($self));

    return 0;
}

sub read ($)
{
    my $self = shift;

    assert(defined($self));

    my $filename;

    $filename = $self->{FILENAME};
    assert(defined($filename));

    if (!file_is_present($filename)) {
	error("File \`" . $filename . "' is not present");
	return 0;
    }

    my $filehandle;

    if (!open($filehandle, "<", $filename)) {
	error("Cannot open \`$filename' for input");
	return 0;
    }

    my $string;
    my $lineno;
    my $host;
    my $login;

    $host   = undef;
    $login  = undef;
    $lineno = 0;
    while (<$filehandle>) {
	$string = $_;
	if ($string =~ /[ \t]*\#.*$/) {
	    # Skip comments
	} elsif ($string =~ /[ \t]+/) {
	    # Skip empty lines
#	} elsif ($string =~ /[ \t]*host[ \t]+(.*)/) {
#
#	    #
#	    # Got a host keyword
#	    #
#
#	    $host = $1;
#
#	    assert(defined($host));
#
#	    $self->{HOSTS}->{$host} = { };
#	} elsif ($string =~ /[ \t]*login[ \t]+(.*)/) {
#
#	    #
#	    # Got login keyword
#	    #
#
#	    $login = $1;
#
#	    assert(defined($login));
#	    
#	    if (!defined($host)) {
#		error("Wrong formatted input file \`" . $filename . "'");
#		return 0;
#	    }
#
#	    $self->{HOSTS}->{$host}->{LOGIN}->$login = { };
#
#	} elsif ($string =~ /[ \t]*password[ \t]+(.*)/) {
#
#	    #
#	    # Got password keyword
#	    #
#
#	    my $password;
#	    $password = $1;
#
#	    assert(defined($password));
#	    
#	    if (!defined($host)) {
#		error("Wrong formatted input file \`" . $filename . "'");
#		return 0;
#	    }
#
#	    $self->{HOSTS}->{$host}->{LOGIN}->{$login} = $password;
#
	} else {
	    error("Unknown input line " . $lineno . " in file " .
		  "\`" . $filename . "'");
	    return 0;
	}

	$lineno++;
    }

    close($filehandle);

    if (!$self->correct()) {
	error("File \`" . $filename . "' has an incorrect format");
	return 0;
    }

    return 1;
}

sub write ($)
{
    my $self = shift;

    assert(defined($self));

    if (!$self->correct()) {
	error("RC Data contains inccorrect data");
	return 0;
    }

    my $filename;

    $filename = $self->{FILENAME};
    assert(defined($filename));

    my $filehandle;

    if (!open($filehandle, "<", $filename)) {
	error("Cannot open \`$filename' for input");
	return 0;
    }

#    for my $host (keys($self->{HOSTS})) {
#	print $filehandle "host     " . $host . "\n";
#	print $filehandle "login    " . $self->{HOSTS}->{$host}->{LOGIN} . "\n";
#	print $filehandle "password " . $self->{HOSTS}->{$host}->{PASSWORD} . "\n";
#    }

    close($filehandle);

    return 1;
}

1;
