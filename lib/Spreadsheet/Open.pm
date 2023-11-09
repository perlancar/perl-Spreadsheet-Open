package Spreadsheet::Open;

use strict;
use warnings;
use Log::ger;

use File::Which;

use Exporter qw(import);

# AUTHORITY
# DATE
# DIST
# VERSION

our @EXPORT_OK = qw(open_spreadsheet);

my @libreoffice_versions = qw(
                                 7.5 7.4 7.3 7.2 7.1 7.0
                                 6.4 6.3 6.2 6.1
                         );

my @known_commands = (
    # [os, program, params]
    ['', 'libreoffice', ['--calc']],
    (map { ['', "libreoffice$_", ['--calc']] } @libreoffice_versions }),
);

sub open_spreadsheet {
    my $path = shift;

    for my $e (@known_commands) {
        next if $e->[0] && $^O ne $e->[0];
        my $which = which($e->[1]);
        next unless $which;
        log_trace "Opening file %s in spreadsheet program %s ...",
            $path, $which;
        return system($which, @{ $e->[2] }, $path);
    }

    require Desktop::Open;
    return Desktop::Open($path);
}

1;
# ABSTRACT: Open spreadsheet in a spreadsheet program

=head1 SYNOPSIS

 use Spreadsheet::Open qw(open_spreadsheet);

 my $ok = open_spreadsheet("/path/to/my.xlsx");


=head1 DESCRIPTION


=head1 FUNCTIONS

=head2 open_spreadsheet

Usage:

 $status = open_spreadsheet($path);

Try a few programs to open a spreadsheet. Currently, in order, LibreOffice (in
decreasing order of version), then failing that, L<Desktop::Open>

C<$ok> is what returned by C<system()> or Desktop::Open.


=head1 SEE ALSO

C<Browser::Open> to open a URL in a browser.
