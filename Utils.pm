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
	my ($self, $config_hr, $key) = @_;
	if ($self->{'set_conflicts'} && exists $config_hr->{$key}) {
		err 'Conflict in \''.join('.', @{$self->{'stack'}}, $key).
			'\'.';
	}
	return;
}

# Create record to hash.
sub hash {
	my ($self, $key_ar, $val) = @_;
	my @tmp = @{$key_ar};
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

Config::Utils - Common config utilities.

=head1 SYNOPSIS

 use Config::Utils qw(conflict hash);
 conflict($self, {'key' => 1}, 'key');
 hash($self, ['one', 'two'], $val);

=head1 SUBOUTINES

=over 8

=item B<conflict($self, $config_hr, $key)>

 Check conflits.
 Returns undef or fatal error.

=item B<hash($self, $key_ar, $val)>

 Create record to hash.
 Returns undef or fatal error.

=back

=head1 ERRORS

 conflict():
         Conflict in '%s'.

 hash():
         Conflict in '%s'.

=head1 EXAMPLE1

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Config::Utils qw(conflict);

 # Object.
 my $self = {
         'set_conflicts' => 1,
         'stack' => [],
 };

 # Conflict.
 conflict($self, {'key' => 'value'}, 'key');

 # Output:
 # ERROR: Conflict in 'key'.

=head1 EXAMPLE2

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Config::Utils qw(hash);
 use Dumpvalue;

 # Object.
 my $self = {
         'config' => {},
         'set_conflicts' => 1,
         'stack' => [],
 };

 # Add records.
 hash($self, ['foo', 'baz1'], 'bar');
 hash($self, ['foo', 'baz2'], 'bar');

 # Dump.
 my $dump = Dumpvalue->new;
 $dump->dumpValues($self);

 # Output:
 # 0  HASH(0x955f3c8)
 #    'config' => HASH(0x955f418)
 #       'foo' => HASH(0x955f308)
 #          'baz1' => 'bar'
 #          'baz2' => 'bar'
 #    'set_conflicts' => 1
 #    'stack' => ARRAY(0x955cc38)
 #         empty array 

=head1 DEPENDENCIES

L<Error::Pure>,
L<Readonly>.

=head1 SEE ALSO

L<Config::Dot>.

=head1 AUTHOR

Michal Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.01

=cut
