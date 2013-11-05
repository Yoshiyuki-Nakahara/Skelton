# ------------------------------------------------------------------------- #
#                             Application Name                              #
# ------------------------------------------------------------------------- #

use strict;
use warnings;
use utf8;
use Getopt::Long qw(:config no_ignore_case);
use Config::YAML;

# --- Global Variables --- #
my %program;

{
    my ( $config, $option, $argv ) = parse_program_environment();
    ( $program{ 'config' },
      $program{ 'option' },
      $program{ 'argv'   } ) = ( $config, $option, $argv );

    for my $arg ( @{ $program{ 'argv' } } ) {
    }
}


sub empty
{
    my ( $val_ref ) = @_;

    #return 1 unless defined $val_ref;
    unless ( my $ref = ref $val_ref ) {
        return $val_ref ? 0 : 1;
    }
    elsif ( $ref eq 'SCALAR' ) {
        return $$val_ref ? 0 : 1;
    }
    elsif ( $ref eq 'ARRAY' ) {
        return scalar @{$val_ref} ? 0 : 1;
    }
    elsif ( $ref eq 'HASH' ) {
        return scalar keys %{$val_ref} ? 0 : 1;
    }

    return undef;
}


sub usage
{
    my $usage = $_[0] ? "$_[0]\n" : "";

    my $basename = $0;
    $basename =~ s{\.pl}{}xms;

    return $usage . <<"END_USAGE"
usage: perl $basename.pl [options] yamlfile
  options: -h|--help    : print usage and exit
           -v|--verbose : print message verbosely
           -c|--config  : specify config file
END_USAGE
}


sub verbose
{
    my ( $str, $level, $nl ) = @_;

    $level = 1 unless $level;
    $nl = "\n" unless $nl;

    local $| = 1;
    if ( defined $program{'option'}->{verbose} ) {
        print "$str$nl" if $program{'option'}->{verbose} >= $level;
    }
}


sub parse_program_environment
{
    my $option = parse_program_option();
    my $config = parse_program_config( $option->{config} );
    my @argv   = parse_program_argv( $config, $option );

    return ( $config, $option, \@argv );
}


sub parse_program_config
{
    verbose( "[ parsing program config file ] ...", 2 );

    my $filename = shift;

    my $config = new Config::YAML( config => '/dev/null' );
    unless ( $filename ) {
        # try path that is changed to .conf extension .pl
        my $conf_path = __FILE__;
        $conf_path =~ s/([^\.]+?)$/conf/;
        if ( -s $conf_path ) {
            verbose( "  filename => $conf_path", 2 );
            $config->read( $conf_path );
        }
    }
    else {
        verbose( "  filename => $filename", 2 );
        if ( ! -s $filename ) {
            die "error: invaild config file path $filename";
        }
        $config->read( $filename );
    }

    return $config;
}


sub parse_program_option
{
    my $option = new Config::YAML( config => '/dev/null' );
    GetOptions(
        $option,

        'help',               # print help and exit
        'verbose+',           # print message verbosely
        'config=s',           # specify config file
    ) or die usage;

    verbose( "[ parsing get program option(s) ] ...", 2 );
    $program{'option'} = $option;

    print usage() and exit if $option->{help};

    return $option;
}


sub parse_program_argv
{
    verbose( "[ parsing program argv(s) ] ...", 2 );

    my $config = shift;
    my $option = shift;

    my @argv = @ARGV;
    for my $arg ( @argv ) {
        verbose( "  argv => $arg", 2 );
    }
    die usage() if @argv != 1;

    return @argv;
}


__END__

