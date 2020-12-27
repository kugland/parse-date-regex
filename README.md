# parse-date-regex

This regex validates and parses dates in the format YYYY-MM-DD, taking into account
leap years and the number of days in each month. Leading zeros are discarded in the
captures. Accepts dates with year in range \[0, 9999\].

By removing the spaces and comments in the regex, it can be used in Javascript or any
other language that supports PCRE (Perl-compatible regular expressions), *e.g.*:

```javascript
const parseDate = /^0{0,3}(?<year>(?<=^000)\d|(?<=^00)[1-9]\d|(?<=^0)[1-9]\d\d|(?<=^)[1-9]\d{3})-0?(?<month>(?<=0)[1-9]|(?<=-)1[0-2])-0?(?<day>(?<=0)[1-9]|(?<=-)(?:1\d|2[0-8])|(?<!02-)(?:29|30)|(?<=0[13578]-|1[02]-)31|(?<=(?:[02468][048]|[13579][26])00-02-|\d\d(?:0[48]|[2468][048]|[13579][26])-02-)29)$/;

const { year, month, day } = '1985-02-02'.match(parseDate).groups;
console.info({ year, month, day });
// => { year: '1985', month: '2', day: '2' }
console.info('1900-02-29'.match(parseDate));
// => null
```

The Perl script also includes a test for the regex.
