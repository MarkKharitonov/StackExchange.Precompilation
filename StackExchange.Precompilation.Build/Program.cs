using System;
using System.Diagnostics;

namespace StackExchange.Precompilation
{
    static class Program
    {
        static void Main(string[] args)
        {
            if (Environment.GetEnvironmentVariable("SE_DEBUG_PRECOMPILER") == "1")
            {
                Debugger.Launch();
            }

            try
            {
                if (!CompilationProxy.RunCs(args))
                {
                    Environment.ExitCode = 1;
                }
            }
            catch (Exception ex)
            {
                var agg = ex as AggregateException;
                Console.WriteLine("ERROR: An unhandled exception occured");
                if (agg != null)
                {
                    agg = agg.Flatten();
                    foreach (var inner in agg.InnerExceptions)
                    {
                        Console.Error.WriteLine("error: " + inner);
                    }
                }
                else
                {
                    Console.Error.WriteLine("error: " + ex);
                }
                Environment.ExitCode = 2;
            }
        }

    }
}
