package Text::Munge::Consonants;
require 5.000;
require Exporter;

=head1 NAME

Text::Munge::Consonants - removes consonants from text

=head1 SYNOPSIS

    use Text::Munge::Consonants;

    $obj = new Text::Munge::Consonants();
    $obj->add_stopwords LIST

    $string = $obj->munge LIST

=head1 DESCRIPTION

Text::Munge::Consonants strips consonant spaces from words and phrases in a text input file

=head1 EXAMPLE

    use Text::Munge::Consonants();

    $munger = new Text::Munge::Consonants();

    $text = "This sentence will have some of it\'s consonants removed.";

    print $munger->munge($text), "\n";

=head1 AUTHOR

Baden Hughes <baden@cpan.org>

Broadly based on the Text::Munge::Vowels module by Robert Rothenberg <wlkngowl@unix.asb.com>

=cut

use vars qw($VERSION $LANGUAGE $MinLength $MungeRule @StopWords);
$VERSION = "0.5.1";
$LANGUAGE = "en-US";		# language code (for rules and stop words)

@ISA = qw(Exporter);
@EXPORT = qw();

use Carp;

# defines the minimum length of a text sequence that must be retained through the processing

my $DefaultMinLength = 4;

# What do you want to strip out ? Several examples below ... other modules should be made for these

# my $DefaultMungeRule = '\B[aeiouy]\B';   # only strip inner vowels
# my $DefaultMungeRule = '[aeiouy]';   # strip all vowels
# my $DefaultMungeRule = '\B[aeiouy]\B';   # only strip inner vowels
# my $DefaultMungeRule = '\B[bcdfghjklmnpqrstvwxyz]\B';   # only strip inner consonants
# my $DefaultMungeRule = '\B[bcdfghjklmnpqrstvwxyz]\B';   # strip all consonants

my $DefaultMungeRule = '\B[bcdfghjklmnpqrstvwxyz]\B';   # only strip inner consonants

# Add your own words here if you want some left in the text

my @DefaultStopWords = qw();

sub initialize {
    my $self = shift;
    $self{VERSION} = $VERSION;
    $self{LANGUAGE} = $LANGUAGE;
    $self{MinLength} = $DefaultMinLength;
    $self{MungeRule} = $DefaultMungeRule;
    $self{StopWords} = \@DefaultStopWords;
}

sub new {
    my $this = shift;
    my $class = ref($this) || $this;
    my $self = {};
    bless $self, $class;
    $self->initialize();
    return $self;
}

sub import {
    my $self = shift;
    export $self;

    my @imports = @_;
    if (@imports) {
        carp "import() ignored in ".__PACKAGE__." v$VERSION";
    }
}

sub add_stopwords {
    my $self = shift;

  # yes this adds duplicate words, but for this version it does not matter
    my @words= @_;
    foreach (@words) {
        push @{$self{StopWords}}, $_;
    }
}

sub munge {
    my $self = shift;

    my $phrase = shift;
    my $word, $buffer='';

    foreach $word (split /\b/, $phrase) {
        unless ((length($word)<$self{MinLength}) or (grep (/\b$word\b/i, @{$self{StopWords}} ))) {
            $word =~ s/$self{MungeRule}//ig;
        }        
        $buffer .= $word;
    }

    return $buffer;
}

1;

__END__
