TimesheetTransformer
====================

Naively transforms CSV output from the Timesheet Android app into the format I
need it in.

Takes as input the path to a CSV file in the following format:

```csv
Date;Start time;End time
20. Februar 2013;09:00;16:54
21. Februar 2013;09:10;11:54
...
```

The date format is hardcoded because D has lousy support for date formatting,
and the month name must be in Danish because Timesheet has similarly lousy
support for export control. Joy!

If the file doesn't exist or is not a valid CSV file in the above format, an
exception is thrown.

The generated output is the date and the absolute duration, in the format

    2013-02-20	08:00
    2013-02-21	02:45
    ...
    -----------------
    Rest:	00:-7

Duration is rounded to the nearest quarter. The final Rest count indicates how
much extra time has been added to or taken from the total actual duration, for
negative respectively positive values.

Multiple records on the same date are combined to produce a single total for
that date.
