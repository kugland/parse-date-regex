#!/usr/bin/env perl

# Written by André Kugland <kugland@gmail.com>

# This regex validates and parses dates in the format YYYY-MM-DD, taking into account
# the number of days in each month and leap years. Leading zeros are discarded.

$regex = qr/^
  0{0,3}(?<year>
    (?<=^000)\d|                                  # Year 0-9
    (?<=^00)[1-9]\d|                              # Year 10-99
    (?<=^0)[1-9]\d\d|                             # Year 100-999
    (?<=^)[1-9]\d{3}                              # Year 1000-9999
  )
  -0?(?<month>
    (?<=0)[1-9]|                                  # Month 1-9
    (?<=-)1[0-2]                                  # Month 10-12
  )
  -0?(?<day>
    (?<=0)[1-9]|                                  # Day 1-9 (any month)
    (?<=-)(?:1\d|2[0-8])|                         # Day 10-28 (any month)
    (?<!02-)(?:29|30)|                            # Day 29-30 (all months except February)
    (?<=0[13578]-|1[02]-)31|                      # Day 31 (months 1, 3, 5, 7, 8, 10, 12)
    (?<=
      (?:[02468][048]|[13579][26])00-02-|         # Only for years divisible by 400,
      \d\d(?:0[48]|[2468][048]|[13579][26])-02-   # or years divisible by 4 but not by 100,
    )29                                           # there is a February 29.
  )
$/x;

# Let's make sure this regex works.
sub test_date {
  my ( $y, $m, $d ) = @_;
  $date = sprintf("%04d-%02d-%02d", $y, $m, $d);
  $validByRegex = ($date =~ m/$regex/o);
  $max_day = 31 if ($m == 1 || $m == 3 || $m == 5 || $m == 7 || $m == 8 || $m == 10 || $m == 12);
  $max_day = 30 if ($m == 4 || $m == 6 || $m == 9 || $m == 11);
  $max_day = 28 if ($m == 2);
  $max_day = 29 if ($m == 2 && (($y % 4) == 0) && ((($y % 100) != 0) || (($y % 400) == 0)));
  $valid = $y >= 0 && $y <= 9999 && $m >= 1 && $m <= 12 && $d >= 1 && $d <= $max_day;
  if ($valid && $validByRegex) {
    if ($y != $+{year} || $m != $+{month} || $d != $+{day}) {
      print "Parse error: $date => [ $+{year}, $+{month}, $+{day} ]\n";
    }
  } elsif ($valid && !$validByRegex) {
    print "Valid date not matched by regex: ${date}\n";
  } elsif (!$valid && $validByRegex) {
    print "Invalid date matched by regex: ${date}\n";
  }
}

print "Testing all valid and invalid dates from 0000-00-00 to 0099-199-199...\n";
for ($y = 0; $y < 100; $y++) {
  for ($m = 0; $m <= 199; $m++) {
    for ($d = 0; $d <= 199; $d++) {
      test_date($y, $m, $d);
    }
  }
}
print "Testing all February 29 dates from year 100 to year 19999...\n";
for ($y = 100; $y < 19999; $y++) {
  test_date($y, 2, 29);
}
print "If you didn't see any error messages, then it's fine. :-)\n";
