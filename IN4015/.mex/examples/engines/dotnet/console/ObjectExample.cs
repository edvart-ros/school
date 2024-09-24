/* Copyright 2022 The MathWorks, Inc. */

/*
 * This file contains examples of how to interact with MATLAB objects from
 * a C# application using the `dynamic` keyword. Examples include:
 * - Calling a MATLAB class constructor.
 * - Accessing properties on a MATLAB class.
 * - Invoking methods on a MATLAB class.
 */
using MathWorks.MATLAB.Types;
using System;

namespace MathWorks.MATLAB.Engine.ConsoleExamples
{
    public class ObjectExample
    {
        public static void Run(dynamic eng)
        {
            // Change the directory so our class is visible to MATLAB
            Console.Write("Changing working folder... ");
            string oldDir = eng.pwd();
            string newDir = eng.fullfile(eng.matlabroot(), "extern", "examples", "engines", "dotnet", "console");
            RunOptions opts = new RunOptions() { Nargout = 0 };
            eng.cd(opts, newDir);
            Console.WriteLine("Changed to {0}", newDir);


            // Create a Triangle and assign it to the `dynamic` type
            Console.Write("Creating a Triangle... ");
            double edgeLength = 1;
            dynamic triangle = eng.Triangle(edgeLength, edgeLength);
            Console.WriteLine("Created a 1x1 Triangle.");


            // Access properties of Triangle
            Console.Write("Changing triangle.Base to 3 and triangle.Height to 4... ");
            triangle.Base = 3.0;
            triangle.Height = 4.0;
            double area = triangle.Area;
            Console.WriteLine("triangle.Area is now {0}", area);


            // Call methods of Triangle
            Console.Write("Resizing triangle by 10... ");
            opts = new RunOptions() { Nargout = 0 };
            triangle.resize(opts, 10.0);
            area = triangle.Area;
            Console.WriteLine("triangle.Area is now {0}", area);

            Console.WriteLine("Displaying triangle...");
            triangle.disp(opts);


            // Restore the original working directory
            Console.Write("Restoring original working folder... ");
            opts = new RunOptions() { Nargout = 0 };
            eng.cd(opts, oldDir);
            Console.WriteLine("Changed to {0}", oldDir);
        }
    }
}
