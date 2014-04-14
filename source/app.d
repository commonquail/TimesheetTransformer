import std.datetime;
import std.stdio;
import std.file;
import std.algorithm;

import timesheet.timelog;
import timesheet.rest;

int main(string[] args)
{
    if (validateArgs(args) == ArgValidation.Invalid)
    {
        return 1;
    }

    auto file = args[1];

    try
    {
        Rest rest;
        auto log = createTimeLog(file);

        foreach (Date date; sort!"a < b"(log.keys))
        {
            auto duration = log[date];
            rest.update(duration);

            writefln("%s\t%02d:%02d",
                    date.toISOExtString,
                    duration.hours,
                    duration.minutes);
        }
        writeln("---------------------");
        writefln("Rest:\t\t" ~ rest.toString);
    }
    catch (Exception e)
    {
        writeln(e.msg);
        return 1;
    }

    return 0;
}

enum ArgValidation {
    Valid,
    Invalid
}

ArgValidation validateArgs(string[] args)
{
    if (args.length < 2)
    {
        writefln("usage: %s file",
                args.length == 1 ? args[0] : "timesheet");
        return ArgValidation.Invalid;
    }

    auto file = args[1];
    if (!file.exists)
    {
        writeln("No such file: " ~ file);
        return ArgValidation.Invalid;
    }

    if (!file.isFile)
    {
        writeln("Not a regular file: " ~ file);
        return ArgValidation.Invalid;
    }

    return ArgValidation.Valid;
}
