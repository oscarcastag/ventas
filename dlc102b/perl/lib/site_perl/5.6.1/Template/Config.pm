#============================================================= -*-perl-*-
#
# Template::Config
#
# DESCRIPTION
#   Template Toolkit configuration module.
#
# AUTHOR
#   Andy Wardley   <abw@kfs.org>
#
# COPYRIGHT
#   Copyright (C) 1996-2000 Andy Wardley.  All Rights Reserved.
#   Copyright (C) 1998-2000 Canon Research Centre Europe Ltd.
#
#   This module is free software; you can redistribute it and/or
#   modify it under the same terms as Perl itself.
#
#------------------------------------------------------------------------
#
#   $Id: Config.pm,v 2.1 2000/12/01 15:29:34 abw Exp $
#
#========================================================================
 
package Template::Config;

require 5.004;

use strict;
use base qw( Template::Base );
use vars qw( $VERSION $DEBUG $ERROR $AUTOLOAD 
	     $PARSER $PROVIDER $PLUGINS $FILTERS $ITERATOR 
	     $STASH $SERVICE $CONTEXT );

$VERSION  = sprintf("%d.%02d", q$Revision: 2.1 $ =~ /(\d+)\.(\d+)/);
$DEBUG    = 0 unless defined $DEBUG;
$ERROR    = '';

$CONTEXT  = 'Template::Context';
$FILTERS  = 'Template::Filters';
$ITERATOR = 'Template::Iterator';
$PARSER   = 'Template::Parser';
$PLUGINS  = 'Template::Plugins';
$PROVIDER = 'Template::Provider';
$SERVICE  = 'Template::Service';
$STASH    = 'Template::Stash';

#========================================================================
#                       --- CLASS METHODS ---
#========================================================================

#------------------------------------------------------------------------
# load($module)
#
# Load a module via require().  Any occurences of '::' in the module name
# are be converted to '/' and '.pm' is appended.  Returns 1 on success
# or undef on error.  Use $class->error() to examine the error string.
#------------------------------------------------------------------------

sub load {
    my ($class, $module) = @_;
    $module =~ s[::][/]g;
    $module .= '.pm';
#    print STDERR "loading $module\n"
#	if $DEBUG;
    eval {
	require $module;
    };
    return $@ ? $class->error("failed to load $module: $@") : 1;
}


#------------------------------------------------------------------------
# parser(\%params)
#
# Instantiate a new parser object of the class whose name is denoted by
# the package variable $PARSER (default: Template::Parser).  Returns
# a reference to a newly instantiated parser object or undef on error.
# The class error() method can be called without arguments to examine
# the error message generated by this failure.
#------------------------------------------------------------------------

sub parser {
    my $class  = shift;
    my $params = defined $_[0] && UNIVERSAL::isa($_[0], 'HASH') 
	       ? shift : { @_ };

    return undef unless $class->load($PARSER);
    return $PARSER->new($params) 
	|| $class->error("failed to create parser: ", $PARSER->error);
}


#------------------------------------------------------------------------
# provider(\%params)
#
# Instantiate a new template provider object (default: Template::Provider).
# Returns an object reference or undef on error, as above.
#------------------------------------------------------------------------

sub provider {
    my $class  = shift;
    my $params = defined $_[0] && UNIVERSAL::isa($_[0], 'HASH') 
	       ? shift : { @_ };

    return undef unless $class->load($PROVIDER);
    return $PROVIDER->new($params) 
	|| $class->error("failed to create template provider: ",
			 $PROVIDER->error);
}


#------------------------------------------------------------------------
# plugins(\%params)
#
# Instantiate a new plugins provider object (default: Template::Plugins).
# Returns an object reference or undef on error, as above.
#------------------------------------------------------------------------

sub plugins {
    my $class  = shift;
    my $params = defined $_[0] && UNIVERSAL::isa($_[0], 'HASH') 
	       ? shift : { @_ };

    return undef unless $class->load($PLUGINS);
    return $PLUGINS->new($params)
	|| $class->error("failed to create plugin provider: ",
			 $PLUGINS->error);
}


#------------------------------------------------------------------------
# filters(\%params)
#
# Instantiate a new filters provider object (default: Template::Filters).
# Returns an object reference or undef on error, as above.
#------------------------------------------------------------------------

sub filters {
    my $class  = shift;
    my $params = defined $_[0] && UNIVERSAL::isa($_[0], 'HASH') 
	       ? shift : { @_ };

    return undef unless $class->load($FILTERS);
    return $FILTERS->new($params)
	|| $class->error("failed to create filter provider: ",
			 $FILTERS->error);
}


#------------------------------------------------------------------------
# iterator(\@list)
#
# Instantiate a new Template::Iterator object (default: Template::Iterator).
# Returns an object reference or undef on error, as above.
#------------------------------------------------------------------------

sub iterator {
    my $class = shift;
    my $list  = shift;

    return undef unless $class->load($ITERATOR);
    return $ITERATOR->new($list, @_)
	|| $class->error("failed to create iterator: ", $ITERATOR->error);
}


#------------------------------------------------------------------------
# stash(\%vars)
#
# Instantiate a new template variable stash object (default: 
# Template::Stash). Returns object or undef, as above.
#------------------------------------------------------------------------

sub stash {
    my $class  = shift;
    my $params = defined $_[0] && UNIVERSAL::isa($_[0], 'HASH') 
	       ? shift : { @_ };

    return undef unless $class->load($STASH);
    return $STASH->new($params) 
	|| $class->error("failed to create stash: ", $STASH->error);
}


#------------------------------------------------------------------------
# context(\%params)
#
# Instantiate a new template context object (default: Template::Context). 
# Returns object or undef, as above.
#------------------------------------------------------------------------

sub context {
    my $class  = shift;
    my $params = defined $_[0] && UNIVERSAL::isa($_[0], 'HASH') 
	       ? shift : { @_ };

    return undef unless $class->load($CONTEXT);
    return $CONTEXT->new($params) 
	|| $class->error("failed to create context: ", $CONTEXT->error);
}

#------------------------------------------------------------------------
# service(\%params)
#
# Instantiate a new template context object (default: Template::Service). 
# Returns object or undef, as above.
#------------------------------------------------------------------------

sub service {
    my $class  = shift;
    my $params = defined $_[0] && UNIVERSAL::isa($_[0], 'HASH') 
	       ? shift : { @_ };

    return undef unless $class->load($SERVICE);
    return $SERVICE->new($params) 
	|| $class->error("failed to create context: ", $SERVICE->error);
}


#========================================================================
# This should probably be moved somewhere else in the long term, but for
# now it ensures that Template::TieString is available even if the 
# Template::Directive module hasn't been loaded, as is the case when 
# using compiled templates and Template::Parser hasn't yet been loaded
# on demand.
#========================================================================

#------------------------------------------------------------------------
# simple package for tying $output variable to STDOUT, used by perl()
#------------------------------------------------------------------------

package Template::TieString;

sub TIEHANDLE {
    my ($class, $textref) = @_;
    bless $textref, $class;
}
sub PRINT {
    my $self = shift;
    $$self .= join('', @_);
}



1;
