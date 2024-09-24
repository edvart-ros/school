/* Copyright 2022 The MathWorks, Inc. */

/* 
 * This file contains is the entry point to the Console Application. It does the following:
 * 1. Starts a MATLAB instance and connects to it.
 * 2. Runs all of the example files included in this project.
 * 3. Closes and disposes of MATLAB.
 */
using System;

namespace MathWorks.MATLAB.Engine.ConsoleExamples
{
    public class Program
    {
        static readonly string LineBreak = new string('=', 20);

        /// <summary>
        /// Entry point which runs all .NET Engine examples.
        /// </summary>
        public static void Main(string[] args)
        {
            // Wrap in a `using` block to ensure proper disposal of unmanaged resources.
            Console.Write("Starting MATLAB... ");
            using (dynamic eng = MATLABEngine.StartMATLAB())
            {
                Console.WriteLine("done.");

                Console.WriteLine("BASIC EXAMPLE");
                Console.WriteLine(LineBreak);
                BasicExample.Run(eng);
                Console.WriteLine(LineBreak);

                Console.WriteLine("\nWORKSPACE EXAMPLE");
                Console.WriteLine(LineBreak);
                WorkspaceExample.Run(eng);
                Console.WriteLine(LineBreak);

                Console.WriteLine("\nOBJECT EXAMPLE");
                Console.WriteLine(LineBreak);
                ObjectExample.Run(eng);
                Console.WriteLine(LineBreak);

                Console.WriteLine("\nEXCEPTION EXAMPLE");
                Console.WriteLine(LineBreak);
                ExceptionExample.Run(eng);
                Console.WriteLine(LineBreak);

                Console.WriteLine("\nMATLABSTRUCT EXAMPLE");
                Console.WriteLine(LineBreak);
                StructExample.Run(eng);
                Console.WriteLine(LineBreak);
            }
            // MATLABEngine.Dispose() is implicitly called when "eng" goes out of scope.
            Console.WriteLine("\nMATLAB instance \"eng\" has been closed.");

            // Call when you no longer need MATLAB Engine in your application.
            MATLABEngine.TerminateEngineClient();
            Console.WriteLine("\nMATLAB can no longer be accessed from this app.");
        }
    }
}
