# Lingua::EN::Syllable : utility function for counting syllables in words
package Lingua::EN::Syllable;

# note that this is not infallible.  it does fail for some percentage of 
# words (10% seems a good guess)...  so it's useful for approximation, but
# don't use this for running your nuclear reactor...

require Exporter;
@ISA = qw/ Exporter /;
@EXPORT = qw/ syllable /;
@EXPORT_OK = qw/ @AddSyl @SubSyl /;
use vars qw/ $VERSION $REVISION @AddSyl @SubSyl /;
use strict;

$VERSION = '0.251';
$REVISION = '$Id: Syllable.pm,v 1.7 1998/09/11 15:06:18 gdf Exp $ ';

# basic algortithm:
# each vowel-group indicates a syllable, except for:
#  final (silent) e
#  'ia' ind two syl 

# @AddSyl and @SubSyl list regexps to massage the basic count.
# Each match from @AddSyl adds 1 to the basic count, each @SubSyl match -1
# Keep in mind that when the regexps are checked, any final 'e' will have
# been removed, and all '\'' will have been removed.

@SubSyl = (
	   'cial',
	   'tia',
	   'cius',
	   'cious',
	   'giu',              # belgium!
	   'ion',
	   'iou',
	   'sia$',
	   '.ely$',             # absolutely! (but not ely!)
	  );
@AddSyl = ( 
	   'ia',
	   'riet',
	   'dien',
	   'iu',
	   'io',
	   'ii',
	   '[aeiouym]bl$',     # -Vble, plus -mble
	   '[aeiou]{3}',       # agreeable
	   '^mc',
	   'ism$',             # -isms
	   '([^aeiouy])\1l$',  # middle twiddle battle bottle, etc.
	   '[^l]lien',         # alien, salient [1]
           '^coa[dglx].',      # [2]
	   '[^gq]ua[^auieo]',  # i think this fixes more than it breaks
 	   'dnt$',           # couldn't
	  );

# (comments refer to titan's /usr/dict/words)
# [1] alien, salient, but not lien or ebbullient...
#     (those are the only 2 exceptions i found, there may be others)
# [2] exception for 7 words:
#     coadjutor coagulable coagulate coalesce coalescent coalition coaxial

#----------------------------------------
sub syllable {
    my $word = shift;	   
    my(@scrugg,$syl);

    $word =~ tr/A-Z/a-z/;
    $word =~ s/\'//g; # fold contractions.  not very effective.
    $word =~ s/e$//;
    @scrugg = split(/[^aeiouy]+/, $word); # '-' should perhaps be added?
    shift(@scrugg) unless ($scrugg[0]);
    $syl = 0;
    # special cases
    foreach (@SubSyl) {
      $syl-- if $word=~/$_/;
    }
    foreach (@AddSyl) {
      $syl++ if $word=~/$_/;
    }
    $syl++ if length($word)==1;	# 'x'
    # count vowel groupings
    $syl += scalar(@scrugg);
    $syl=1 if $syl==0; # got no vowels? ("the", "crwth")
    return $syl;
}
# syllable


1;
__END__

=head1 NAME

Lingua::EN::Syllable - Routine for estimating syllable count in words.

=head1 SYNOPSIS

  use Lingua::EN::Syllable;

  $count = syllable('supercalifragilisticexpialidocious'); # 14

=head1 DESCRIPTION

Lingua::EN::Syllable::syllable() estimates the number of syllables in 
the word passed to it.

Note that it isn't entirely accurate...  it fails (by one syllable) for 
about 10-15% of my /usr/dict/words.  The only way to get a 100% accurate
count is to do a dictionary lookup, so this is a small and fast alternative
where more-or-less accurate results will suffice, such as estimating the 
reading level of a document.

I welcome pointers to more accurate algorithms, since this one is 
pretty quick-and-dirty.  This was designed for English (well, American
at least) words, but sometimes guesses well for other languages.

=head1 KNOWN LIMITATIONS

Accuracy for words with non-alpha characters is somewhat undefined. 
In general, punctuation characters, et al, should be trimmed off before
handing the word to syllable(), and hyphenated compounds should be broken 
into their separate parts.

Syllables for all-digit words (eg, "1998";  some call them "numbers") are 
often counted as the number of digits.  A cooler solution would be converting
"1998" to "nineteen eighty eight" (or "one thousand nine hundred eighty 
eight", or...), but that is left as an exercise for the reader.

Contractions are not well supported.

Compound words (like "lifeboat"), where the first word ends in a silent 'e'
are counted with an extra syllable.

=head1 COPYRIGHT

Distributed under the same terms as Perl.
Contact the author with any questions.

=head1 AUTHOR

Greg Fast (gdf@imsa.edu)

=cut
