=head1 NAME

Lingua::EN::NameGrammar 

=head1 DESCRIPTION

Grammar tree of personal name syntax for Lingua::EN::NameParse module. 

The grammar defined here is for use with the Parse::RecDescent module. 
Note that parsing is done depth first, meaning match the shortest string first.
To avoid premature matches, when one rule is a sub set of another longer rule, 
it must appear after the longer rule. See the Parse::RecDescent documentation
for more details.

=head1 COPYRIGHT

Copyright (c) 1999-2001 Kim Ryan. All rights reserved.
This program is free software; you can redistribute it 
and/or modify it under the terms of the Perl Artistic License
(see http://www.perl.com/perl/misc/Artistic.html).

=head1 AUTHOR

NameGrammar was written by Kim Ryan <kimaryan@ozemail.com.au> in 1999.


=cut
#------------------------------------------------------------------------------

package Lingua::EN::NameGrammar;


# Rules that define valid orderings of a names components

$rules = 
q{
   
full_name :

   # A (?) refers to an optional component, occurring 0 or more times.
   # Optional items are returned as an array, which for our case will
   # always consist of one element, when they exist. 

   title initials surname conjunction title initials surname non_matching(?)
   {
      # block of code to define actions upon successful completion of a
      # 'production' or rule

      # Two separate people
      $return =
      {
         # Parse::RecDescent lets you return a single scalar, which we use as
         # an anonymous hash reference
         title_1       => $item[1],
         initials_1    => $item[2],
         surname_1     => $item[3],
         conjunction_1 => $item[4],
         title_2       => $item[5],
         initials_2    => $item[6],
         surname_2     => $item[7],
         non_matching  => $item[8][0],
         number        => 2,
         type          => 'Mr_A_Smith_&_Ms_B_Jones'
      }
   }
   |

   title initials conjunction initials surname non_matching(?)
   {
      # Two related people, shared title, separate initials, 
      # shared surname. Example, father and son, sisters
      $return =
      {
         title_1       => $item[1],
         initials_1    => $item[2],
         conjunction_1 => $item[3],
         initials_2    => $item[4],
         surname_1     => $item[5],
         non_matching  => $item[6][0],
         number        => 2,
         type          => 'Mr_A_&_B_Smith'
      }
   }
   |

   title conjunction title initials conjunction initials surname non_matching(?)
   {
      # Two related people, own initials, shared surname

      $return =
      {
         title_1       => $item[1],
         conjunction_1 => $item[2],
         title_2       => $item[3],
         initials_1    => $item[4],
         conjunction_2 => $item[5],
         initials_2    => $item[6],
         surname_1     => $item[7],
         non_matching  => $item[8][0],
         number        => 2,
         type          => 'Mr_&_Ms_A_&_B_Smith'
      }
   }
   |

   title initials conjunction title initials surname non_matching(?)
   {
      # Two related people, own initials, shared surname
      $return =
      {
         title_1       => $item[1],
         initials_1    => $item[2],
         conjunction_1 => $item[3],
         title_2       => $item[4],
         initials_2    => $item[5],
         surname_1     => $item[6],
         non_matching  => $item[7][0],
         number        => 2,
         type          => 'Mr_A_&_Ms_B_Smith'
      }
   }
   |

   title conjunction title initials surname non_matching(?)
   {
      # Two related people, shared initials, shared surname
      $return =
      {
         title_1       => $item[1],
         conjunction_1 => $item[2],
         title_2       => $item[3],
         initials_1    => $item[4],
         surname_1     => $item[5],
         non_matching  => $item[6][0],
         type          => 'Mr_&_Ms_A_Smith'
      }
   }
   |

   title given_name middle_initial surname non_matching(?)
   {
      $return =
      {
         title_1       => $item[1],
         given_name_1  => $item[2],
         initials_1    => $item[3],
         surname_1     => $item[4],
         non_matching  => $item[5][0],
         number        => 1,
         type          => 'Mr_John_A_Smith'
      }
   }
   |
   
   title given_name surname non_matching(?)
   {
      $return =
      {
         title_1       => $item[1],
         given_name_1  => $item[2],
         surname_1     => $item[3],
         non_matching  => $item[4][0],
         number        => 1,
         type          => 'Mr_John_Smith'
      }
   }
   |
     
   title initials surname non_matching(?)
   {
      $return =
      {
         title_1       => $item[1],
         initials_1    => $item[2],
         surname_1     => $item[3],
         non_matching  => $item[4][0],
         number        => 1,
         type          => 'Mr_A_Smith'  
      }
   }
   |
   
   given_name given_name surname non_matching(?)
   {
      $return =
      {
         given_name_1  => $item[1],
         middle_name   => $item[2],
         surname_1     => $item[3],
         non_matching  => $item[4][0],
         number        => 1,
         type          => 'John_Adam_Smith'
      }
   }
   |
   
   given_name middle_initial surname non_matching(?)
   {
      $return =
      {
         given_name_1  => $item[1],
         initials_1    => $item[2],
         surname_1     => $item[3],
         non_matching  => $item[4][0],
         number        => 1,
         type          => 'John_A_Smith'
      }
   }
   |
   
   given_name surname non_matching(?)
   {
      $return =
      {
         given_name_1  => $item[1],
         surname_1     => $item[2],
         non_matching  => $item[3][0],
         number        => 1,
         type          => 'John_Smith'
      }
   }
   |
   
   initials surname non_matching(?)
   {
      $return =
      {
         initials_1    => $item[1],
         surname_1     => $item[2],
         non_matching  => $item[3][0],
         number        => 1,
         type          => 'A_Smith',
      }
   }
   |
    
   non_matching(?)
   {
      $return =
      {
         non_matching  => $item[1][0],
         number        => 0,
         type          => 'unknown'
      }
   }
};

#------------------------------------------------------------------------------
# Individual components that a name can be composed from. Components are 
# expressed as literals or Perl regular expressions.

$title = 
q{
   
   title :

   /Mrs\.? /i          |
   /M\/s\.? /i         |
   /Ms\.? /i           |
   /Miss\.? /i         |
   /Mme\.? /i          |   # Madame

   /Mr\.? /i           |
   /Messrs /i          |   # plural or Mr
   /Mister /i          |
   /Mast(\.|er)? /i    |    
   /Ms?gr\.? /i        |   # Monsignor

   /Sir /i             |
   /Lord /i            |
   /Lady /i            |
   /Madam(e)? /i       |
   /Dame /i            |

   # Medical
   /Dr\.? /i           |
   /Doctor /i          |
   /Sister /i          |
   /Matron /i          |
   
   # Legal
   /Judge /i           |   
   /Justice /i         |   

   # Police
   /Det\.? /i          |      
   /Insp\.? /i         |

   # Military
   /Brig(adier)? /i              |
   /Capt(\.|ain)? /i             |      
   /Cdr\.? /i                    |   # Commander, Commodore
   /Gen(\.|eral)? /i             | 
   /Field Marshall /i            |
   /Fl\.? Off\.? /i              | 
   /Flight Officer /i            |
   /Flt Lt /i                    | 
   /Flight Lieutenant /i         |
   /Pte\. /i                     | 
   /Private /i                   |
   /Sgt\.? /i                    |
   /Sargent /i                   |
   /(Air )?Commander /i          |
   /(Air )?Commodore /i          |
   /(Air )?Marshall /i           |
   /Lieutenant (Colonel )?/i     |
   /(Lt|Leut|Lieut)\.? /i        |
   /Colonel /i                   |
   /Lt\.? ((Col|Gen|Cdr)\. )?/   | 
   /Maj(\.|or)? (Gen(\.|eral)? )? /i | 

   # Religious
   /Rabbi /i                     |   
   /Brother /i                   |
   /Father /i                    |
   /Chaplain /i                  |
   /Pastor /i                    |
   /Bishop /i                    |
   /Mother (Superior )?/i        |
   /([Mt|V] )?Revd?\.? /i        |  
   /([Most|Very] )?Rever[e|a]nd /i |
   
   # Other
   /Prof(\.|essor)? /i |
   /Ald(\.|erman)? /i
   
};

$conjunction = q{ conjunction : /And |& /i };

# Used in the John_A_Smith name type. Although this duplicates 
# $initials_1, it is needed because the middle initial must always be
# one character long, regardless of the length of initials set by the
# user in the 'new' method. 
$middle_initial = q{ middle_initial: /[A-Z]\.? /i };

# Define given name combinations, specifying the minimum number of letters.
# The correct pair of rules is determined by the 'initials' key in the hash 
# passed to the 'new' method.

# John, Jo-Anne, D'Artagnan, O'Shaugnessy La'Keishia
$given_name_min_2 = 
q{ 
	given_name: /[A-Z]{2,}(\-[A-Z]{2,})? /i | /[A-Z]{1,}\'[A-Z]{2,} /i 
};
 
$given_name_min_3 = 
q{ 
	given_name: /[A-Z]{3,}(\-[A-Z]{2,})? /i | /[A-Z]{1,}\'[A-Z]{2,} /i
};
 
$given_name_min_4 = 
q{ 
	given_name: /[A-Z]{4,}(\-[A-Z]{2,})? /i | /[A-Z]{1,}\'[A-Z]{3,} /i
};

# Define initials combinations specifying the minimum and maximum letters.
# Order from most complex to simplest,	to avoid premature matching.

# 'A' 'A.'
$initials_1 = q{ initials: /[A-Z]\.? /i }; 

# 'A. B.' 'A.B.' 'AB' 'A B'
$initials_2 =  
q{ 
   initials:  /([A-Z]\. ){1,2}/i | /([A-Z]\.){1,2} /i | /([A-Z] ){1,2}/i | /([A-Z]){1,2} /i
};

# 'A. B. C. '  'A.B.C' 'ABC' 'A B C'  
$initials_3 = 
q{ 
   initials: /([A-Z]\. ){1,3}/i |  /([A-Z]\.){1,3} /i | /([A-Z] ){1,3}/i | /([A-Z]){1,3} /i
};                    

$full_surname = 

q{
   surname : sub_surname second_name(?)
   {
      if ( $item[1] and $item[2][0] )
      {
         $return = "$item[1]$item[2][0]"
      }
      else
      {
         $return = "$item[1]" 
      }
   }

   sub_surname : prefix(?) name
   {
      # To prevent warnings when compiling with the -w switch,
      # do not return uninitialized variables.
      if ( $item[1][0] )
      {
         $return = "$item[1][0]$item[2]";
      }
      else
      {
         $return = $item[2];
      }
   }

   second_name : '-' sub_surname
   {
      if ( $item[1] and $item[2] )
      {
         $return = "$item[1]$item[2]"
      }
   }

   # Patronymic, place name and other surname prefixes
   prefix:

      /[A|E]l /i         |   # Arabic, Greek, 
      /Ap /i             |   # Welsh
      /Ben /i            |   # Hebrew

      /Dell([a|e|'])? /i |   # ITALIAN
      /Del /i            |      
      /De (La |Los )?/i  |      
      /D[a|i|u] /i       |
      /L[a|e|o] /i       |      

      /[D|L|O]'/i        |   # Italian, Irish or French
      /St\.? /i          |   # abbreviation for Saint

      /Den /i            |   # DUTCH
      /Von (Der )?/i     |  
      /Van (De(n|r)? )?/i

	# Space needed for any following text        
   name: /[A-Z]{2,} ?/i
};

$non_matching = q{ non_matching: /.*/ };

#-------------------------------------------------------------------------------
# Assemble correct combination for grammar tree.

sub create
{
   my $name = shift;

   my $grammar = $rules . $title . $conjunction;
   
   $grammar .= $middle_initial;
   
   $name->{initials} > 3 and $name->{initials} = 3;
   $name->{initials} < 1 and $name->{initials} = 1;
   
   # Define limit of when a string is treated as an initial, or
   # a first name. For example, if initials are set to 2, MR TO SMITH
   # will have initials of T & O and no given name, but MR TOM SMITH will 
   # have no initials, and a given name of Tom.
   
   if ( $name->{initials} == 1 )
   {
      $grammar .= $given_name_min_2;
      $grammar .= $initials_1;
   }
   elsif ( $name->{initials} == 2 )
   {
      $grammar .= $given_name_min_3;
      $grammar .= $initials_2;
   }
   elsif ( $name->{initials} == 3 )
   {
      $grammar .= $given_name_min_4;
      $grammar .= $initials_3;
   }
   
   $grammar .= $full_surname;
   
   $grammar .= $non_matching;
   
   return($grammar);
}
#-------------------------------------------------------------------------------
1;