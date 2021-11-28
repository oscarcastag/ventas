package Lingua::EN::NameCase ;    # Documented at the __END__.

# $Id: NameCase.pm,v 1.2 2000/11/22 19:03:48 mark Exp mark $

require 5.004 ;

use strict ;
use locale ;

use Carp ;

use vars qw( $VERSION @ISA @EXPORT @EXPORT_OK ) ;

$VERSION = '1.11' ;

use Exporter() ;

@ISA        = qw( Exporter ) ;

@EXPORT     = qw( nc ) ;
@EXPORT_OK  = qw( NameCase nc ) ;

#############################
sub NameCase {

    croak "Usage: \$SCALAR|\@ARRAY = NameCase [\\]\$SCALAR|\@ARRAY"
        if ref $_[0] and ( ref $_[0] ne 'ARRAY' and ref $_[0] ne 'SCALAR' ) ;
        
    local( $_ ) ;

    if( wantarray and ( scalar @_ > 1 or ref $_[0] eq 'ARRAY' ) ) {
        # We have received an array or array reference in a list context
        # so we will return an array.
        map { nc( $_ ) } @{ ref( $_[0] ) ? $_[0] : \@_ } ;
    } 
    elsif( ref $_[0] eq 'ARRAY' ) {
        # We have received an array reference in a scalar or void context
        # so we will work on the array in-place.
        foreach ( @{ $_[0] } ) { 
            $_ = nc( $_ ) ;
        }
    }
    elsif( ref $_[0] eq 'SCALAR' ) {
        # We don't work on scalar references in-place; we take the value 
        # and return a name-cased copy.
        nc( ${ $_[0] } ) ;
    }
    elsif( scalar @_ == 1 and not ref $_[0] ) {
        # We've received a scalar: we return a name-cased copy.
        nc( $_[0] ) ;
    }
    else {
        croak "NameCase only accepts a single scalar, array or array ref" ;
    }
}

#############################
sub nc {

    croak "Usage: nc [[\\]\$SCALAR]"
        if scalar @_ > 1 or ( ref $_[0] and ref $_[0] ne 'SCALAR' ) ;
        
    local( $_ ) = @_ if @_ ;
    $_ = ${$_} if ref( $_ ) ;           # Replace reference with value.

    $_ = lc ;                           # Lowercase the lot.
	s{ \b (\w)   }{\u$1}gox ;           # Uppercase first letter of every word.
    s{ (\'\w) \b }{\L$1}gox ;           # Lowercase 's.

    # Name case Mcs and Macs - taken straight from NameParse.pm incl. comments.
    # Exclude names with 1-2 letters after prefix like Mack, Macky, Mace
    # Exclude names ending in a,c,i,o, or j are typically Polish or Italian

    if ( /\bMac[A-Za-z]{2,}[^aciozj]\b/o or /\bMc/o ) {
        s/\b(Ma?c)([A-Za-z]+)/$1\u$2/go ;

        # Now correct for "Mac" exceptions
        s/\bMacHin/Machin/go ;
        s/\bMacHlin/Machlin/go ;
        s/\bMacHar/Machar/go ;
        s/\bMacKle/Mackle/go ;
        s/\bMacKlin/Macklin/go ;
        s/\bMacKie/Mackie/go ;
        s/\bMacQuarie/Macquarie/go ;
        s/\bMacHado/Machado/go ;        # Portuguese
        s/\bMacEvicius/Macevicius/go ;  # Lithuanian
        s/\bMacIulis/Maciulis/go ;  
        s/\bMacIas/Macias/go ;  

    }
    s/Macmurdo/MacMurdo/go ;
 
    # Fixes for "son (daughter) of" etc. in various languages.
    s{ \b ([AE])l   \b }{\l$1l}gox ;    # al and el Arabic/Greek.
    s{ \b Ap        \b }{ap}gox ;       # ap Welsh.
    s{ \b Dell([ae])\b }{dell$1}gox ;   # della delle Italian.
    s{ \b D([aeiu]) \b }{d$1}gox ;      # da, de, di Italian; du French.
    s{ \b De([lr])  \b }{de$1}gox ;     # del Italian; der Dutch/Flemish.
    s{ \b L([aeo])  \b }{l$1}gox ;      # lo Italian; la, le French.
    s{ \b V([ao])n  \b }{v$1n}gox ;     # van German; von Dutch/Flemish.

    # Fixes for roman numeral names, e.g. Henry VIII, up to 89, LXXXIX
    s{ \b ( (?: [Xx]{1,3} | [Xx][Ll]   | [Ll][Xx]{0,3} )?
            (?: [Ii]{1,3} | [Ii][VvXx] | [Vv][Ii]{0,3} )? ) \b }{\U$1}gox ;

    $_ ;
}

1 ;

__END__

=head1 NAME

NameCase - Perl module to fix the case of people's names.

=head1 SYNOPSIS

    # Working with scalars; complementing lc and uc.

    use Lingua::EN::NameCase qw( nc ) ;

    $FixedCasedName  = nc( $OriginalName ) ;

    $FixedCasedName  = nc( \$OriginalName ) ;

    # Working with arrays or array references.

    use Lingua::EN::NameCase 'NameCase' ;

    $FixedCasedName  = NameCase( $OriginalName ) ;
    @FixedCasedNames = NameCase( @OriginalNames ) ;

    $FixedCasedName  = NameCase( \$OriginalName ) ;
    @FixedCasedNames = NameCase( \@OriginalNames ) ;

    NameCase( \@OriginalNames ) ; # In-place.

    # NameCase will not change a scalar in-place, i.e.
    NameCase( \$OriginalName ) ; # WRONG: null operation.

=head1 DESCRIPTION

Forenames and surnames are often stored either wholly in UPPERCASE
or wholly in lowercase. This module allows you to convert names into
the correct case where possible.

Although forenames and surnames are normally stored separately if they
do appear in a single string, whitespace separated, NameCase and nc deal
correctly with them.

NameCase currently correctly name cases names which include any of the
following:
    Mc, Mac, al, el, ap, da, de, delle, della, di, du, del, der, 
    la, le, lo, van and von.

It correctly deals with names which contain apostrophies and hyphens too.

=head2 EXAMPLE FIXES

    Original            Name Case
    --------            ---------
    KEITH               Keith
    LEIGH-WILLIAMS      Leigh-Williams
    MCCARTHY            McCarthy
    O'CALLAGHAN         O'Callaghan
    ST. JOHN            St. John

plus "son (daughter) of" etc. in various languages, e.g.:

    VON STREIT          von Streit
    VAN DYKE            van Dyke
    AP LLWYD DAFYDD     ap Llwyd Dafydd
etc.

plus names with roman numerals (up to 89, LXXXIX), e.g.:

    henry viii          Henry VIII
    louis xiv           Louis XIV

=head1 BUGS

The module covers the rules that I know of. There are probably a lot
more rules, exceptions etc. for "Western"-style languages which could be
incorporated.

We don't fix "ben" - for hebrew names this means son of, but it can
mean "Ben" as a name in itself or as a form of "Benjamin". However we
do fix "al" - for arabic names this means son of, even though it can also
mean "Al" as a name in itself.

There are probably lots of exceptions and problems - but as a general
data 'cleaner' it may be all you need.

Use Kim Ryan's NameParse.pm for any really sophisticated name parsing.

=head1 CHANGES

1998/04/20  First release.

1998/06/25  First public release.

1999/01/18  Second public release.

1999/02/08  Added Mac with Mack as an exception, thanks to Kim Ryan for this.

1999/05/05  Copied Kim Ryan's Mc/Mac solution from his NameParse.pm and 
            replaced my Mc/Mac solution with his.

1999/05/08  nc can now use $_ as its default argument 
            e.g. "$ans = nc ;" and "nc ;", both of which set $_, with the
            first one setting $ans also.

1999/07/30  Modified for CPAN and automatic testing. Stopped using $_ as the
            default argument.

1999/08/08  Changed licence to LGPL.

1999/09/07  Minor change to packaging for CPAN.

1999/09/09  Renamed package Lingua::EN::NameCase.pm as per John Porter's
            (CPAN) suggestion.

1999/11/13  Added code for names with roman numerals, thanks to David Lynn
            Rice for this suggestion. (If you need to go beyond LXXXIX let me
            know.)

2000/11/22  Added use locale at the suggestion of Eric Kolve. It should have
	    been there in the first place.

=head1 AUTHOR

Mark Summerfield. I can be contacted as <summer@perlpress.com> -
please include the word 'namecase' in the subject line.

Thanks to Kim Ryan <kimaryan@ozemail.com.au> for his Mc/Mac solution.

=head1 COPYRIGHT

Copyright (c) Mark Summerfield 1998-2000. All Rights Reserved.

This module may be used/distributed/modified under the LGPL. 

=cut

