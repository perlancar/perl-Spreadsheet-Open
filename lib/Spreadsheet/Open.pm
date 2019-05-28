package Spreadsheet::Open;

# DATE
# VERSION

use strict;
use warnings;
use Log::ger;

use File::Which;

use Exporter qw(import);
our @EXPORT_OK = qw(open_spreadsheet);

my @known_commands = (
    # [os, program, params]
    ['', 'libreoffice', ['--calc']],
    ['', 'libreoffice6.2', ['--calc']],
    ['', 'libreoffice6.1', ['--calc']],
    ['', 'xdg-open', []],
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
}

1;
# ABSTRACT: Open spreadsheet in a spreadsheet program

=head1 SYNOPSIS

 use Spreadsheet::Open qw(open_spreadsheet);

 my $ok = open_spreadsheet("/path/to/my.xlsx");


=head1 DESCRIPTION


=head1 FUNCTIONS

=head2 open_spreadsheet


=head1 SEE ALSO

C<Browser::Open> to open a URL in a browser.
