module timesheet.rest;

import core.time;
import std.array;
import std.format;
import std.math;

struct Rest
{
    pure nothrow @property @safe hours() const
    {
        return rest.hours;
    }

    pure nothrow @property @safe minutes() const
    {
        return rest.minutes;
    }

    pure nothrow @safe void update(ref Duration duration)
    {
        foreach (interval; intervals)
        {
            if (duration.minutes > interval - ceil(15 / 2.0))
            {
                rest += dur!"minutes"(duration.minutes - interval);
                duration += dur!"minutes"(interval - duration.minutes);
                break;
            }
        }
    }

    pure @safe string toString() const
    {
        auto writer = appender!string();
        formattedWrite(writer, "%02d:%02d", rest.hours, rest.minutes);
        return writer.data;
    }

    private Duration rest;
}

private:

enum intervals = [60, 45, 30, 15, 0];
