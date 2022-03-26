using System;
using System.Runtime.CompilerServices;
using Test.Module;

namespace Test.ConsoleApp
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine(PathMapTest().Dump());
            Console.WriteLine(typeof(AliasTest).FullName);
        }

        // path mapping test, configured via <PathMap> property in the .csproj
        static string PathMapTest([CallerFilePath] string path = null) =>
            path.StartsWith("C:\\work\\")
                ? path
                : throw new InvalidOperationException($"CallerFilePath was expected to start with C:\\work\\ but was {path}.");
    }
}
