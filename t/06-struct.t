#!perl

use lib 't';

use FFI::Platypus::Legacy::Raw;
use CompileTest;

my $test   = '06-struct';
my $source = "./t/$test.c";
my $shared = CompileTest::compile($source);

my $int_arg = 42;
my $str_arg = "hello";

my $packed = pack('ix![p]p', 42, $str_arg);

my $arg = FFI::Platypus::Legacy::Raw::MemPtr -> new_from_buf($packed, length $packed);

my $take_one_struct = FFI::Platypus::Legacy::Raw -> new(
  $shared, 'take_one_struct',
  FFI::Platypus::Legacy::Raw::void, FFI::Platypus::Legacy::Raw::ptr
);

$take_one_struct -> call($arg);

print "ok - survived the call\n";

$arg = FFI::Platypus::Legacy::Raw::MemPtr -> new(length $packed);

my $return_one_struct = FFI::Platypus::Legacy::Raw -> new(
  $shared, 'return_one_struct',
  FFI::Platypus::Legacy::Raw::void, FFI::Platypus::Legacy::Raw::ptr
);

$return_one_struct -> call($arg);

print "ok - survived the call\n";

my ($int, $str) = unpack('ix![p]p', $arg -> to_perl_str(length $packed));

print "ok - got passed int 42\n" if $int == 42;
print "ok - str\n" if $str eq 'hello';

print "1..7\n";
