/* Copyright 2022 The MathWorks, Inc. */

/*
 * This file contains basic examples of calling MATLAB functions from C#, including:
 * - Calling MATLAB functions from a MATLABEngine instance.
 * - Invoking MATLAB package functions from a MATLABEngine instance.
 * - Passing C# types as arguments to MATLAB functions.
 * - Converting MATLAB return values to C# types.
 */
using MathWorks.MATLAB.Types;
using System;

namespace MathWorks.MATLAB.Engine.ConsoleExamples
{
    public class BasicExample
    {
        public static void Run(dynamic eng)
        {
            // Call a MATLAB function with a single output
            Console.Write("Calling sqrt(2)... ");
            double sqrt = eng.sqrt(2.0);
            Console.WriteLine(sqrt);


            // Call a MATLAB package function
            Console.Write("Calling matlab.desktop.commandwindow.size()... ");
            double[] size = eng.matlab.desktop.commandwindow.size();
            Console.WriteLine("[{0}]", string.Join(',', size));


            // Call a MATLAB function with zero outputs
            Console.Write("Calling disp(\"Hello, MATLAB!\")... ");
            RunOptions opts = new RunOptions() { Nargout = 0 };
            eng.disp(opts, "Hello, MATLAB!");


            // Call a MATLAB function with two outputs
            Console.Write("Calling weekday(\"10-10-2010\")... ");
            opts = new RunOptions() { Nargout = 2 };
            (double, string) result = eng.weekday(opts, "10-10-2010");
            Console.WriteLine(result);
            
        }
    }
}
