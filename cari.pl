#!/usr/bin/perl
#eval 'exec perl -S $0 "$@"' if 0;

use Getopt::Std;
use vars qw/%opt @file_find @dir_find/;

&main;

sub main{
    Getopt::Std::getopts('hrd:',\%opt);
    my $str = $ARGV[0];
    $str =~ s/^s+|s+$//ig;

    return &help if !($str) || ($opt{h} || $str eq '');

    system('clear');
    my $dir='.';
    @file_find = ();
    @dir_find = ();

    if($opt{d}){
        $dir = $opt{d};
        $dir =~ s/\\/\//g;
        $dir =~ s/\/$//;
        return print "Can't open directory: $dir" if !(-d $dir);
    }
    

    print "\nSearch String REGEX: \"$str\" found at:\n",("-" x 50),"\n";
    $/=undef; 
    &cari($dir,$str);
    print "\n\n";
}

sub cari{
    my ($dir,$str) = (shift,shift);

    return print "Can't open directory: $dir" if !(opendir (DIR,$dir));

    my @file = sort(readdir(DIR));
    close(DIR);
    
    my $f_org, $f;

    foreach $f (@file){
        $f = "$dir/$f";

        next if($f=~ /\.$|\/\/\.\.$/);

        if (-d $f){
            $opt{'r'} && &cari($f,$str) || next;
        }

        next if !(-T $f);

        open(FILE, $f);
            while(<FILE>){
                if ($_ =~ /$str/is){
                    $f =~ s/^\.\///;
                    print $f,"\n";
                }
            }
       close(FILE)
    }
}



sub help{
    print qq~\
Usage:
 cari [-h]
 cari [-d "/dir/subdir"] [-r] "regex_string"

 "regex_string"    : wanted string, must be given in regex
 -h                : Help - This list
 -d ""/dir/subdir" : fing to specific direktory,
                     the default is PWD or "."
 -r                : recursively find the file

 example:

  *find in "." anyfile that have string "nama"

      \$ cari "nama"

~;
}
