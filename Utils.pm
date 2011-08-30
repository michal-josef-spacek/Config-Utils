package Config::Utils;

# Pragmas.
use base qw(Exporter);
use strict;
use warnings;

# Modules.
use Error::Pure qw(err);
use Readonly;

# Constants.
Readonly::Array our @EXPORT_OK => qw(conflict hash);

# Version.
our $VERSION = 0.01;

# Check conflits.
sub conflict {
	my ($self, $config, $key) = @_;
	if ($self->{'set_conflicts'} && exists $config->{$key}) {
		err 'Conflict in \''.join('.', @{$self->{'stack'}}, $key).
			'\'.';
	}
	return;
}

# Create record to hash.
sub hash {
	my ($self, $key_array_ref, $val) = @_;
	my @tmp = @{$key_array_ref};
	my $tmp = $self->{'config'};
	foreach my $i (0 .. $#tmp) {
		if ($i != $#tmp) {
			if (! exists $tmp->{$tmp[$i]}) {
				$tmp->{$tmp[$i]} = {};
			} elsif (ref $tmp->{$tmp[$i]} ne 'HASH') {
				conflict($self, $tmp, $tmp[$i]);
				$tmp->{$tmp[$i]} = {};
			}
			$tmp = $tmp->{$tmp[$i]};
			push @{$self->{'stack'}}, $tmp[$i];
		} else {
			conflict($self, $tmp, $tmp[$i]);
			if (defined $self->{'callback'}) {
				$tmp->{$tmp[$i]} = $self->{'callback'}->($val);
			} else {
				$tmp->{$tmp[$i]} = $val;
			}
			$self->{'stack'} = [];
		}
	}
	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Config::Utils - TODO

=head1 SYNOPSIS

 TODO

=head1 SUBOUTINES

=over 8

=item B<conflict()>

TODO

=item B<hash()>

TODO

=back

=head1 ERRORS

 conflict():
         Conflict in '%s'.

 hash():
         Conflict in '%s'.

=head1 EXAMPLE

 TODO

=head1 DEPENDENCIES

L<Error::Pure>,
L<Readonly>.

=head1 SEE ALSO

L<Cnf>,
L<Cnf::More>,
L<Cnf::Output>,
L<Cnf::Reparse>,
L<Cnf::Uniq>.

=head1 AUTHOR

Michal Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.01

=cut
