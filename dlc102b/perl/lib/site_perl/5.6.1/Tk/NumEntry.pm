# $Id: NumEntry.pm,v 2.2 2000/10/22 17:58:05 eserte Exp $

package Tk::NumEntry;

use Tk ();
use Tk::Frame;
use Tk::Derived;
use strict;

use vars qw(@ISA $VERSION);
@ISA = qw(Tk::Derived Tk::Frame);
$VERSION = sprintf("%d.%02d", q$Revision: 2.2 $ =~ /(\d+)\.(\d+)/);

Construct Tk::Widget 'NumEntry';

{ my $foo = $Tk::FireButton::INCBITMAP;
     $foo = $Tk::FireButton::DECBITMAP; # peacify -w
}

sub Populate {
    my($f,$args) = @_;

    require Tk::FireButton;
    require Tk::NumEntryPlain;

    my $orient = delete $args->{-orient} || "vertical";

    my $e = $f->Component( $f->NumEntryPlainWidget => 'entry',
        -borderwidth        => 0,
        -highlightthickness => 0,
    );

    my $binc = $f->Component( $f->IncFireButtonWidget() => 'inc',
	-command	    => sub { $e->incdec($e->cget(-increment)) },
	-takefocus	    => 0,
	-highlightthickness => 0,
	-anchor             => 'center',
    );
    $binc->configure(-bitmap => ($orient =~ /^vert/
				 ? $binc->INCBITMAP
				 : $binc->HORIZINCBITMAP
				)
		    );

    my $bdec = $f->Component( $f->DecFireButtonWidget() => 'dec',
	-command	    => sub { $e->incdec(- $e->cget(-increment)) },
	-takefocus	    => 0,
	-highlightthickness => 0,
	-anchor             => 'center',
    );
    $bdec->configure(-bitmap => ($orient =~ /^vert/
				 ? $bdec->DECBITMAP
				 : $bdec->HORIZDECBITMAP
				)
		    );

    $f->gridColumnconfigure(0, -weight => 1);
    $f->gridColumnconfigure(1, -weight => 0);

    $f->gridRowconfigure(0, -weight => 1);
    $f->gridRowconfigure(1, -weight => 1);

    if ($orient eq 'vertical') {
	$binc->grid(-row => 0, -column => 1, -sticky => 'news');
	$bdec->grid(-row => 1, -column => 1, -sticky => 'news');
    } else {
	$binc->grid(-row => 0, -column => 2, -sticky => 'news');
	$bdec->grid(-row => 0, -column => 1, -sticky => 'news');
    }

    $e->grid(-row => 0, -column => 0, -rowspan => 2, -sticky => 'news');

    $f->ConfigSpecs(
	-borderwidth => ['SELF'     => "borderWidth", "BorderWidth", 2	     ],
	-relief      => ['SELF'     => "relief",      "Relief",	    "sunken"  ],
	-background  => ['CHILDREN' => "background",  "Background", Tk::NORMAL_BG ],
	-foreground  => ['CHILDREN' => "background",  "Background", Tk::BLACK ],
	-buttons     => ['METHOD'   => undef,	    undef,	   1	     ],
	-state       => ['CHILDREN' => "state", 	    "State", 	   "normal"  ],
	-repeatdelay => [[$binc,$bdec]
				  => "repeatDelay", "RepeatDelay", 300	     ],
	-repeatinterval
		     => [[$binc,$bdec]
				  => "repeatInterval",
						    "RepeatInterval",
								   100	     ],
	-highlightthickness
                     => [SELF     => "highlightThickness",
						    "HighlightThickness",
								   2	     ],
	DEFAULT      => [$e],
    );

    $f->Delegates(DEFAULT => $e);

    $f;
}

sub NumEntryPlainWidget { "NumEntryPlain"         }
sub FireButtonWidget    { "FireButton"            }
sub IncFireButtonWidget { shift->FireButtonWidget }
sub DecFireButtonWidget { shift->FireButtonWidget }

sub buttons {
    my $f = shift;
    my $var = \$f->{Configure}{'-buttons'};
    my $old = $$var;

    if(@_) {
	my $val = shift;
	$$var = $val ? 1 : 0;
	my $e = $f->Subwidget('entry');
	my %info = $e->gridInfo; $info{'-sticky'} = 'news';
	delete $info{' -sticky'};
	$e->grid(%info, -columnspan => $val ? 1 : 2);
	$e->raise;
    }

    $old;
}

1;

__END__

=head1 NAME

Tk::NumEntry - A numeric Entry widget with inc. & dec. Buttons

=head1 SYNOPSIS

S<    >B<use Tk::NumEntry;>

S<    >I<$parent>-E<gt>B<NumEntry>(?I<-option>=E<gt>I<value>, ...?);

=head1 DESCRIPTION

B<Tk::NumEntry> defines a widget for entering integer numbers. The widget
also contains buttons for increment and decrement.

B<Tk::NumEntry> supports all the options and methods that the plain 
NumEntry widget provides (see L<Tk::NumEntryPlain>), plus the
following options

=head1 STANDARD OPTIONS

Besides the standard options of the L<Entry|Tk::Entry> widget
NumEntry supports:

B<-orient> B<-repeatdelay> B<-repeatinterval>

The B<-orient> option specifies the packing order of the increment and
decrement buttons.

=head1 WIDGET-SPECIFIC OPTIONS

=over 4

=item Name:             B<buttons>

=item Class:            B<Buttons>

=item Switch:           B<-buttons>

=item Fallback:		B<1>

Boolean that defines if the inc and dec buttons are visible.

=back

=head1 WIDGET METHODS

Subclasses of NumEntry may override the following methods to use
different widgets for the composition of the NumEntry. These are:
NumEntryPlainWidget, FireButtonWidget, IncFireButtonWidget and
DecFireButtonWidget. FireButtonWidget is used if IncFireButtonWidget
or DecFireButtonWidget are not defined.

=head1 AUTHOR

Graham Barr <F<gbarr@pobox.com>>

Current maintainer is Slaven Rezic <F<eserte@cs.tu-berlin.de>>.

=head1 ACKNOWLEDGEMENTS

I would to thank  Achim Bohnet <F<ach@mpe.mpg.de>>
for all the feedback and testing. And for the splitting of the original
Tk::NumEntry into Tk::FireButton, Tk::NumEntryPlain and Tk::NumEntry

=head1 COPYRIGHT

Copyright (c) 1997-1998 Graham Barr. All rights reserved.
This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

Except the typo's, they blong to Achim :-)

=cut
