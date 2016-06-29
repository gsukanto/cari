#!/usr/bin/perl
#eval 'exec perl -S $0 "$@"' if 0;

use Getopt::Std;
use vars qw/%opt @file_find @dir_find/;

&mulai;
#---------------------------------
sub mulai{
        Getopt::Std::getopts('hrd:',\%opt);
        my $str = $ARGV[0];
        $str =~ s/^s+|s+$//ig;

        unless($str) {
                &help;
                return;
        }

        system('clear');

        if($opt{h} || $str eq ''){
                &help;
                return;
        }

   my $dir='.';
        if($opt{d}){
                $dir = $opt{d};
                $dir =~ s/\\/\//g;
                $dir =~ s/\/$//;
                unless(-d $dir){
                        print "Can't open directory: $dir";
                        return;
                }
        }
        @file_find = ();
        @dir_find = ();

        print "\nSearch String REGEX: \"$str\" found at:\n",("-" x 50),"\n";

                $/=undef; &cari($dir,$str);

        print "\n\n";
}

#---------------------------------

sub cari{
        my ($dir,$str) = (shift,shift);

        unless(opendir (DIR,$dir)){
                print "\n\ncan't open directory: $dir\n\n";
                return;
        }

        my @file = sort(readdir(DIR));
        close(DIR);
        my $f_org,$f;
        foreach $f (@file){
                $f = "$dir/$f";

                next if($f=~ /\.$|\/\/\.\.$/);

                if (-d $f){
                        $opt{'r'} && &cari($f,$str) || next;
                }

                next unless (-T $f);

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


#---------------------------------

sub help{

                print qq~\
Usage:
 cari [-h]
 cari [-d "/dir/subdir"] [-r] "regex_string"

 "regex_string"    : string yang ingin dicari dalam bentuk regular expression
 -h                : Help - This list
 -d ""/dir/subdir" : cari pada spesifik direktori,
                     bila tidak ada maka direktory diasumsikan PWD atau "."
 -r                : cari file secara recursive

 contoh:

  *cari pada "." file yang mengandung kata "nama"

      \$ cari "nama"

~;

}
