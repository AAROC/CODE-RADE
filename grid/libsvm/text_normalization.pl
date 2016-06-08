#!/usr/bin/perl -w
# © Oluwapelumi Giwa, 2012.
# mailto:oluwapelumi.giwa@doubleag.com
use strict;
use File::Basename;
use POSIX;
use utf8;
use open ':encoding(utf8)';
binmode STDOUT, ':encoding(utf8)';
my %hash_lang = ( 'afr' => '1',
						'ss' => '2',
						'zul' => '3',
						'eng' => '4'
			);
			
my @sentence = ();
my %feature_vectors = ();
my %sample_array = ();
			
my $ngram_phrase = "";
my $label = "";

##### Global parameter variables #####
my $set_extract_tokens = $ARGV[4];
my $fname = $ARGV[0];
my $ngram = $ARGV[1];
my $set_text_normalization = $ARGV[5];
my $file_containing_tokens = $ARGV[2];

### Necessary to create the tokens and save to file #######
if($set_extract_tokens == 1) {
	
	if($fname) { 
		my $filename = $fname;
		open FH, "<:encoding(UTF-8)", $filename or die "Unknown File name $filename . $!";
		
		while(<FH>) {
			chomp;
			my $line = $_;
			my @test_fields = split(//, $line);
			
			if(length($line) > $ngram ) {
			   for(my $i=0; $i < @test_fields; $i++)
			   {
				   if( $i < ( ((length($line)) - ($ngram - 1) ) ) ) {
					   my $z = $i;
					   for(my $j = 0; $j < $ngram; $j++) {
						   if($ngram_phrase eq "") {
							   $ngram_phrase = $test_fields[$z];
						   }else {
								$ngram_phrase = $ngram_phrase . $test_fields[$z];
						   }
						   $z++;
					   }
					   
					   push(@sentence, $ngram_phrase);
						
					}
					$ngram_phrase = "";
			   }
			}else{
				$ngram_phrase = $line;
				
				push(@sentence, $ngram_phrase);
			}
			
			for( my $s = 0; $s < @sentence; $s++) {
				print $sentence[$s] . "\n";
			}
			@sentence = ();
			$ngram_phrase = "";
		}
		
	}
}

### Retrieving all tokens from the result file #####

if($set_text_normalization) {
	my $index = 1;
	
	if($file_containing_tokens) {
		my $filename = $file_containing_tokens;
		open FH1, "<:encoding(UTF-8)", $filename or die "Unknown File name $filename . $!";
		
		while(<FH1>) {
			chomp;
			my $line = $_;
			my @each_line = split(" ", $line);
			
			$feature_vectors{$each_line[1]}{'count'} = $each_line[0];
			$feature_vectors{$each_line[1]}{'index'} = $index;
			
			$index = $index + 1;
		}
	}
	
	if($fname) { 
		
		my($name, $directory) = fileparse($fname);
		if( $ARGV[3] ) {
			$label = $ARGV[3];
		}else {
			$label = basename($directory);
		}
		
		my $filename = $fname;
		open FH, "<:encoding(UTF-8)", $filename or die "Unknown File name $filename . $!";
		
		while(<FH>) {
			chomp;
			my $line = $_;
			my @test_fields = split(//, $line);
			
			if(length($line) > $ngram ) {
			   for(my $i=0; $i < @test_fields; $i++)
			   {
				   if( $i < ( ((length($line)) - ($ngram - 1) ) ) ) {
					   my $z = $i;
					   for(my $j = 0; $j < $ngram; $j++) {
						   if($ngram_phrase eq "") {
							   $ngram_phrase = $test_fields[$z];
						   }else {
								$ngram_phrase = $ngram_phrase . $test_fields[$z];
						   }
						   $z++;
					   }
					   
					   push(@sentence, $ngram_phrase);
						
					}
					$ngram_phrase = "";
			   }
			}else{
				$ngram_phrase = $line;
				
				push(@sentence, $ngram_phrase);
			}
			
			my $sent = "";
			for( my $s = 0; $s < @sentence; $s++) {
				$sent = $sent . " " . $sentence[$s];
			}
			
			my @array_features = ();
			my @array_result = ();
			my $first_time = 0;
			my $array_line = "";
		
			for( my $s = 0; $s < @sentence; $s++) {
				if( exists $feature_vectors{$sentence[$s]} ) {
					$array_result[$feature_vectors{$sentence[$s]}{'index'}] = $feature_vectors{$sentence[$s]}{'count'};
					push( @array_features, $feature_vectors{$sentence[$s]}{'index'});
				}
			}
			
			if( @array_features ) {
				@array_features = sort { $a <=> $b } @array_features;
			}
			
			@sentence = ();
			$ngram_phrase = "";
			my $iter = 0;
			my $previous_num = 0;
			
			#print @array_features;
			if ( @array_features ) {
				foreach (@array_features) {
					my $fd = $_;
					if( $iter > 0 ) {
						if( $previous_num == $fd ) {
							next;
						}
					}
					
					my $feature = $fd . ":" . $array_result[$fd];
					
					if( $first_time <= 0 ) {
						$array_line = $hash_lang{$label} . " " . $feature . " ";
					}else {
						$array_line = $array_line . $feature . " ";
					}
					$first_time = $first_time + 1;
					$iter = $iter + 1;
					$previous_num = $fd;
				}
			}
			
			$array_line = $array_line . "   ${sent}\n";
			print $array_line;
		}
	}
}
close(FH1);
close (FH);
