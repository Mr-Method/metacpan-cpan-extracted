# encoding: KOI8U
# This file is encoded in KOI8-U.
die "This file is not encoded in KOI8-U.\n" if q{��} ne "\x82\xa0";

use KOI8U;

print "1..12\n";

# eval <<'END' has eval "..."
if (eval KOI8U::escape <<'END') {
eval KOI8U::escape " if ('��' =~ /[��]/i) { return 1 } else { return 0 } "
END
    print qq{ok - 1 $^X @{[__FILE__]}\n};
}
else {
    print qq{not ok - 1 $^X @{[__FILE__]}\n};
}

# eval <<'END' has eval qq{...}
if (eval KOI8U::escape <<'END') {
eval KOI8U::escape qq{ if ('��' =~ /[��]/i) { return 1 } else { return 0 } }
END
    print qq{ok - 2 $^X @{[__FILE__]}\n};
}
else {
    print qq{not ok - 2 $^X @{[__FILE__]}\n};
}

# eval <<'END' has eval '...'
if (eval KOI8U::escape <<'END') {
eval KOI8U::escape ' if (qq{��} =~ /[��]/i) { return 1 } else { return 0 } '
END
    print qq{ok - 3 $^X @{[__FILE__]}\n};
}
else {
    print qq{not ok - 3 $^X @{[__FILE__]}\n};
}

# eval <<'END' has eval q{...}
if (eval KOI8U::escape <<'END') {
eval KOI8U::escape q{ if ('��' =~ /[��]/i) { return 1 } else { return 0 } }
END
    print qq{ok - 4 $^X @{[__FILE__]}\n};
}
else {
    print qq{not ok - 4 $^X @{[__FILE__]}\n};
}

# eval <<'END' has eval $var
my $var = q{ if ('��' =~ /[��]/i) { return 1 } else { return 0 } };
if (eval KOI8U::escape <<'END') {
eval KOI8U::escape $var
END
    print qq{ok - 5 $^X @{[__FILE__]}\n};
}
else {
    print qq{not ok - 5 $^X @{[__FILE__]}\n};
}

# eval <<'END' has eval (omit)
$_ = "if ('��' =~ /[��]/i) { return 1 } else { return 0 }";
if (eval KOI8U::escape <<'END') {
eval KOI8U::escape
END
    print qq{ok - 6 $^X @{[__FILE__]}\n};
}
else {
    print qq{not ok - 6 $^X @{[__FILE__]}\n};
}

# eval <<'END' has eval {...}
if (eval KOI8U::escape <<'END') {
eval { if ('��' =~ /[��]/i) { return 1 } else { return 0 } }
END
    print qq{ok - 7 $^X @{[__FILE__]}\n};
}
else {
    print qq{not ok - 7 $^X @{[__FILE__]}\n};
}

# eval <<'END' has "..."
if (eval KOI8U::escape <<'END') {
if ('��' =~ /[��]/i) { return "1" } else { return "0" }
END
    print qq{ok - 8 $^X @{[__FILE__]}\n};
}
else {
    print qq{not ok - 8 $^X @{[__FILE__]}\n};
}

# eval <<'END' has qq{...}
if (eval KOI8U::escape <<'END') {
if ('��' =~ /[��]/i) { return qq{1} } else { return qq{0} }
END
    print qq{ok - 9 $^X @{[__FILE__]}\n};
}
else {
    print qq{not ok - 9 $^X @{[__FILE__]}\n};
}

# eval <<'END' has '...'
if (eval KOI8U::escape <<'END') {
if ('��' =~ /[��]/i) { return '1' } else { return '0' }
END
    print qq{ok - 10 $^X @{[__FILE__]}\n};
}
else {
    print qq{not ok - 10 $^X @{[__FILE__]}\n};
}

# eval <<'END' has q{...}
if (eval KOI8U::escape <<'END') {
if ('��' =~ /[��]/i) { return q{1} } else { return q{0} }
END
    print qq{ok - 11 $^X @{[__FILE__]}\n};
}
else {
    print qq{not ok - 11 $^X @{[__FILE__]}\n};
}

# eval <<'END' has $var
my $var1 = 1;
my $var0 = 0;
if (eval KOI8U::escape <<'END') {
if ('��' =~ /[��]/i) { return $var1 } else { return $var0 }
END
    print qq{ok - 12 $^X @{[__FILE__]}\n};
}
else {
    print qq{not ok - 12 $^X @{[__FILE__]}\n};
}

__END__
