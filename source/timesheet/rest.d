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

unittest
{
    auto duration = 7.minutes;
    Rest r;
    r.update(duration);

    assert(duration.minutes == 0,
            "Should round duration of 7 minutes to 0 minutes.");
}

unittest
{
    auto duration = 8.minutes;
    Rest r;
    r.update(duration);

    assert(duration.minutes == 15,
            "Should round duration of 8 minutes to 15 minutes.");
}

unittest
{
    auto duration = 22.minutes;
    Rest r;
    r.update(duration);

    assert(duration.minutes == 15,
            "Should round duration of 22 minutes to 15 minutes.");
}

unittest
{
    auto duration = 23.minutes;
    Rest r;
    r.update(duration);

    assert(duration.minutes == 30,
            "Should round duration of 23 minutes to 30 minutes.");
}

unittest
{
    auto duration = 37.minutes;
    Rest r;
    r.update(duration);

    assert(duration.minutes == 30,
            "Should round duration of 37 minutes to 30 minutes.");
}

unittest
{
    auto duration = 38.minutes;
    Rest r;
    r.update(duration);

    assert(duration.minutes == 45,
            "Should round duration of 38 minutes to 45 minutes.");
}

unittest
{
    auto duration = 52.minutes;
    Rest r;
    r.update(duration);

    assert(duration.minutes == 45,
            "Should round duration of 52 minutes to 45 minutes.");
}

unittest
{
    auto duration = 53.minutes;
    Rest r;
    r.update(duration);

    assert(duration.minutes == 0,
            "Should round duration of 53 minutes to 0 minutes.");
}

unittest
{
    auto duration = 67.minutes;
    Rest r;
    r.update(duration);

    assert(duration.minutes == 0,
            "Should round duration of 67 minutes to 0 minutes.");
}

enum intervals = [60, 45, 30, 15, 0];
