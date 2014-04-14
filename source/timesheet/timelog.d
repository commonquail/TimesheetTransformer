module timesheet.timelog;

import std.datetime;
import std.csv;
import std.file;
import std.format;

const TimeLog createTimeLog(string filename)
{
    auto log = TimeLog(filename);
    auto str = readText(log.file);

    try
    {
        auto records = csvReader!Layout(str, noheader,  ';');
        foreach (record; records)
        {
            int year = void;
            string month = void;
            int day = void;
            int hour = void;
            int minute = void;

            formattedRead(record.date, date_format, &day, &month, &year);
            auto date = Date(year, months[month], day);

            formattedRead(record.start_time, time_format, &hour, &minute);
            auto start = TimeOfDay(hour, minute);

            formattedRead(record.end_time, time_format, &hour, &minute);
            auto end = TimeOfDay(hour, minute);

            auto duration = end - start;

            log.saveEntry(date, duration);
        }
    }
    catch (HeaderMismatchException)
    {
        throw new TimeLogException("CSV header mismatched.");
    }
    catch (Exception)
    {
        throw new TimeLogException("Error processing CSV file.");
    }

    return log;
}

class TimeLogException : Exception
{
    pure nothrow @safe this(string s) const
    {
        super(s);
    }
}

private:

struct TimeLog
{
    pure int opApply(int delegate(Date, ref Duration) traverse) const
    {
        int res;
        foreach (Date date, Duration duration; times)
        {
            res += traverse(date, duration);
        }
        return res;
    }

    pure nothrow @safe Duration opIndex(Date d) const
    {
        return times[d];
    }

    pure nothrow @property Date[] keys() const
    {
        return times.keys;
    }

private:
    pure nothrow @safe this(string filename)
    {
        file = filename;
    }

    pure nothrow @safe void saveEntry(in Date date, in Duration duration)
    {
        auto p = (date in times);
        if (p)
        {
            *p += duration;
        }
        else
        {
            times[date] = duration;
        }
    }

    Duration[Date] times;
    string file;
}

struct Layout
{
    string date;
    string start_time;
    string end_time;
    string absolute_duration;
    string relative_duration;
    string project;
    string description;
    string tags;
}

enum int[string] months = [
    "Januar": 1,
    "Februar": 2,
    "Marts": 3,
    "April": 4,
    "Maj": 5,
    "Juni": 6,
    "Juli": 7,
    "August": 8,
    "September": 9,
    "Oktober": 10,
    "November": 11,
    "December": 12
];

enum date_format = "%d. %s %d";
enum time_format = "%d:%d";

enum noheader = null;
