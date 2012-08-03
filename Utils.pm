package Config::Utils;

# Pragmas.
use base qw(Exporter);
use strict;
use warnings;

# Modules.
use Error::Pure qw(err);
use Readonly;

# Constants.
Readonly::Array our @EXPORT_OK => qw(conflict hash hash_array);

# Version.
our $VERSION = 0.02;

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
	my $tmp_hr = $self->{'config'};
	foreach my $i (0 .. $#tmp) {
		if ($i != $#tmp) {
			if (! exists $tmp_hr->{$tmp[$i]}) {
				$tmp_hr->{$tmp[$i]} = {};
			} elsif (ref $tmp_hr->{$tmp[$i]} ne 'HASH') {
				conflict($self, $tmp_hr, $tmp[$i]);
				$tmp_hr->{$tmp[$i]} = {};
			}
			$tmp_hr = $tmp_hr->{$tmp[$i]};
			push @{$self->{'stack'}}, $tmp[$i];
		} else {
			conflict($self, $tmp_hr, $tmp[$i]);
			if (defined $self->{'callback'}) {
				$tmp_hr->{$tmp[$i]}
					= $self->{'callback'}->(
					[@{$self->{'stack'}}, $tmp[$i]],
					$val);
			} else {
				$tmp_hr->{$tmp[$i]} = $val;
			}
			$self->{'stack'} = [];
		}
	}
	return;
}

# Create record to hash.
sub hash_array {
	my ($self, $key_ar, $val) = @_;
	my @tmp = @{$key_ar};
	my $tmp_hr = $self->{'config'};
	foreach my $i (0 .. $#tmp) {
		if ($i != $#tmp) {
			if (! exists $tmp_hr->{$tmp[$i]}) {
				$tmp_hr->{$tmp[$i]} = {};
			} elsif (ref $tmp_hr->{$tmp[$i]} ne 'HASH') {
				conflict($self, $tmp_hr, $tmp[$i]);
				$tmp_hr->{$tmp[$i]} = {};
			}
			$tmp_hr = $tmp_hr->{$tmp[$i]};
			push @{$self->{'stack'}}, $tmp[$i];
		} else {
			if (defined $self->{'callback'}) {
				$tmp_hr->{$tmp[$i]}
					= $self->{'callback'}->(
					[@{$self->{'stack'}}, $tmp[$i]],
					$val);
			} else {
				if (ref $tmp_hr->{$tmp[$i]} eq 'ARRAY') {
					push @{$tmp_hr->{$tmp[$i]}}, $val;
				} elsif ($tmp_hr->{$tmp[$i]}) {
					my $foo = $tmp_hr->{$tmp[$i]};
					$tmp_hr->{$tmp[$i]} = [$foo, $val];
				} else {
					$tmp_hr->{$tmp[$i]} = $val;
				}
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

 use Config::Utils qw(conflict hash hash_array);
 conflict($self, {'key' => 1}, 'key');
 hash($self, ['one', 'two'], $val);
 hash_array($self, ['one', 'two'], $val);

=head1 SUBOUTINES

=over 8

=item B<conflict($self, $config_hr, $key)>

 Check conflits.
 Returns undef or fatal error.

=item B<hash($self, $key_ar, $val)>

 Create record to hash.
 Returns undef or fatal error.

=item B<hash_array($self, $key_ar, $val)>

 Create record to hash.
 If exists more value record for one key, then create array of values.
 Returns undef or fatal error.

=back

=head1 ERRORS

 conflict():
         Conflict in '%s'.

 hash():
         Conflict in '%s'.

 hash_array():
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

=head1 EXAMPLE3

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Config::Utils qw(hash_array);
 use Dumpvalue;

 # Object.
 my $self = {
         'config' => {},
         'set_conflicts' => 1,
         'stack' => [],
 };

 # Add records.
 hash_array($self, ['foo', 'baz'], 'bar');
 hash_array($self, ['foo', 'baz'], 'bar');

 # Dump.
 my $dump = Dumpvalue->new;
 $dump->dumpValues($self);

 # Output:
 # 0  HASH(0x8edf890)
 #    'config' => HASH(0x8edf850)
 #       'foo' => HASH(0x8edf840)
 #          'baz' => ARRAY(0x8edf6d0)
 #             0  'bar'
 #             1  'bar'
 #    'set_conflicts' => 1
 #    'stack' => ARRAY(0x8edf6e0)
 #         empty array

=head1 DEPENDENCIES

L<Error::Pure>,
L<Exporter>,
L<Readonly>.

=head1 SEE ALSO

L<Config::Dot>.

=head1 AUTHOR

Michal Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.02

=cut
