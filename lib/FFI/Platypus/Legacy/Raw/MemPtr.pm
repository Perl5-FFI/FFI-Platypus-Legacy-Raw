package FFI::Platypus::Legacy::Raw::MemPtr;

use strict;
use warnings;

=head1 NAME

FFI::Platypus::Legacy::Raw::MemPtr - FFI::Platypus::Legacy::Raw memory pointer type

=head1 DESCRIPTION

A B<FFI::Platypus::Legacy::Raw::MemPtr> represents a memory pointer which can be passed to
functions taking a C<FFI::Platypus::Legacy::Raw::ptr> argument.

The allocated memory is automatically deallocated once the object is not in use
anymore.

=head1 METHODS

=head2 new( $length )

Allocate a new C<FFI::Platypus::Legacy::Raw::MemPtr> of size C<$length> bytes.

=head2 new_from_buf( $buffer, $length )

Allocate a new C<FFI::Platypus::Legacy::Raw::MemPtr> of size C<$length> bytes and copy C<$buffer>
into it. This can be used, for example, to pass a pointer to a function that
takes a C struct pointer, by using C<pack()> or the L<Convert::Binary::C> module
to create the actual struct content.

For example, consider the following C code

    struct some_struct {
      int some_int;
      char some_str[];
    };

    extern void take_one_struct(struct some_struct *arg) {
      if (arg -> some_int == 42)
        puts(arg -> some_str);
    }

It can be called using FFI::Platypus::Legacy::Raw as follows:

    use FFI::Platypus::Legacy::Raw;

    my $packed = pack('ix![p]p', 42, 'hello');
    my $arg = FFI::Platypus::Legacy::Raw::MemPtr -> new_from_buf($packed, length $packed);

    my $take_one_struct = FFI::Platypus::Legacy::Raw -> new(
      $shared, 'take_one_struct',
      FFI::Platypus::Legacy::Raw::void, FFI::Platypus::Legacy::Raw::ptr
    );

    $take_one_struct -> ($arg);

Which would print C<hello>.

=head2 new_from_ptr( $ptr )

Allocate a new C<FFI::Platypus::Legacy::Raw::MemPtr> pointing to the C<$ptr>, which can be either
a C<FFI::Platypus::Legacy::Raw::MemPtr> or a pointer returned by another function.

This is the C<FFI::Platypus::Legacy::Raw> equivalent of a pointer to a pointer.

=head2 to_perl_str( [$length] )

Convert a C<FFI::Platypus::Legacy::Raw::MemPtr> to a Perl string. If C<$length> is not provided,
the length of the string will be computed using C<strlen()>.

=for Pod::Coverage tostr

=cut

sub tostr {
  my $self = shift;
  return $self -> to_perl_str(@_)
}

=head1 AUTHOR

Alessandro Ghedini <alexbio@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright 2013 Alessandro Ghedini.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of FFI::Platypus::Legacy::Raw::MemPtr