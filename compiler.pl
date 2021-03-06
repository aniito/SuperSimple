use Getopt::Long qw(GetOptions);  
use List::Util 'first';
$|=1;
my $c;  
my $e;
GetOptions('c=s' => \$c, 'e' => \$e) || print "Usage: $0 <file.sssc> -c for compiling \r\n\t| -e for execute after compiling\n";


sub typeof($word){
    return substr($word, 0, 3);
};

sub getstr($word){
        if (&typeof($word=$word) eq "str"){
            return substr($word, 6, -1);
        }else{
            push @error, "Error: Trying to get the string of a word that isn't a string | ABORTING...";
        }
};

sub getint($word){
    if (&typeof($word=$word) eq "int"){
            return substr($word, 5);
        }else{
            push @error, "Error: Trying to get the integer of a word that isn't a integer | ABORTING...";
        }

}

sub gen(@acode){
    @acode=@acode;
    my $final= "";
    my $start= "/*Generated by Perl version of SuperSimple Compiler*/\r\n\r\nint main(int argc, char** argv)\r\n{\r\n";
    my $end= "}\r\n";
    my $output="";
    my @includes;
    my $layer=1;
    my $nword = @acode; # issou le nword = numbers words
    my $i = 0;
    while ($i lt $nword){
            if (@acode[$i] eq "PRINT"){
                    $i=$i+1;
                    if (first {$_ eq 'stdio.h'} @includes){
                        #pass;
                    }else{
                        push @includes, "stdio.h";
                    }
                    if (&typeof($word=@acode[$i]) eq "str"){
                        $LMF = $layer x "\\t";
                        $output .= $LMF . "printf(\"\%s\", \"" . &getstr($word=@acode[$i]) . "\\r\\n\");\r\n";
                    }
                    
            }
            elsif (@acode[$i] eq "RETURN"){
                $i+=1;
                    if(first {$_ eq 'stdio.h'} @includes){
                        #rien
                    }else{
                        push @includes, "stdio.h";

                    }
                    if (&typeof($word=@acode[$i]) eq "int"){
                        $output .= $layer*"\t" . "return " . &getint($word=@acode[$i]) . ";\r\n";
                    }
            }
            $i+=1;
            }
            foreach ( @includes ){
                $final.= "#include <$_>\r\n";    
            }
            $final .= "\r\n";
            $final .= $start;
            $final .= $output;
            $final .= $end;
            return $final;
    
    
    


};

sub parlex($kod){
    $kod=$kod;
    $tok = "";
	$rstr = 0;
	$wstr = "";
	my @toks;
    @kod= split //, $kod;
    foreach $kodium (@kod) {
        $tok .= $kodium;
		if ($tok eq " " || $tok eq "\n" || $tok eq "\t" || $tok eq "\r"){
            $tok="";
        }elsif(lc($tok) eq "print"){
            push @toks, "PRINT";
            $tok= "";
        }
		elsif( lc($tok) eq "return"){
			push @toks, "RETURN";
			$tok = "";
        }
		elsif($tok eq "\""){
            if ($rstr eq 0){
				$rstr = 1;
                }elsif ($rstr eq 1){
                $abatartufum = "str::\"$wstr\"";
                push @toks, $abatartufum;
				$wstr = "";
				$rstr = 0;
				$tok = "";
                }
            }
		elsif($rstr eq 1){
            $wstr .= $kodium;
			$tok = "";
            }
		else{
                if ($tok =~ /\d+/){
                        my $abatartufum1 = "int::$tok";
                        push @toks, $abatartufum1;
                        }
            }
    }
	return @toks;

}
sub main(){
    print("Trying to open the file provided...");
    open (HANDLER, "<", $ARGV[0]);
    print("\nLexing and Parsing...");
    my @file;
    while( <HANDLER> ){
    push @file, "$_";
    }
    my $faile= "";
    foreach (@file){
        $faile .= $_;  
    }
    @parsed=&parlex($kod=$faile);
    print("\nGenerating...");
    $out=&gen(@acode=@parsed);
    print("\nTrying to open the output file...");
    open(HANDL, ">", $c);
    print("\n(Over)writing the output file...\n");
    print HANDL $out;
    close HANDL;
}
$sssc=$ARGV[0];
if(substr($sssc, length($sssc)-5, 5) eq ".sssc"){
            if(-e $sssc){
                    if(!$c){
                        print("Error : -c output file not found");
                    }
                    elsif(substr($c, length($c)-1, 1) ne "c"){
                        print("Error : -c option is not a .c file ! try: $c.c");
                    }
                    else{
                        &main;
                        if($e){
                            $outpute= substr($c, 0, -2);
                            system("gcc $c -o $outpute");
                            print("Generated Compiled C file : $outpute \n");
                        }
                        
                    }
            
            }else{
                print("\nCan't open SuperSimple script \"$sssc\": Aucun fichier ou dossier de ce type \n\n");
            }


    }else{
        print "the compiler can compile only files in .sssc ! Try with a .sssc file ! ";
    }


