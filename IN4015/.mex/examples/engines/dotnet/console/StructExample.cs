/* Copyright 2022 The MathWorks, Inc. */

/*
 * This file contains examples of how to interact with MATLAB structs from
 * a C# application using the `dynamic` keyword and the MATLABStruct data type. 
 *  Examples include:
 * - Creating a MATLABStruct
 * - Calling methods of a MATLABStruct
 * - Passing a MATLABStruct to MATLAB
 */
using MathWorks.MATLAB.Types;
using System;
using System.Collections.Generic;

namespace MathWorks.MATLAB.Engine.ConsoleExamples
{
    public class StructExample
    {
        public static void Run(dynamic eng)
        {

            // Create a MATLABStruct and assign it to the 'dynamic' type
            Console.WriteLine("Creating a MATLABStruct... ");
            MATLABStruct mStruct = new MATLABStruct(("a", 1), ("b", 2));
            dynamic dynamicMStruct = mStruct;
            Console.WriteLine("Created a 1x1 MATLABStruct with 2 fields");


            // Access fields of a MATLABStruct
            Console.WriteLine("Display values of fields... ");
            double a = mStruct.GetField("a");
            double b = dynamicMStruct.b;
            Console.WriteLine("(a, b): ( {0} , {1})",a, b);


            // Call methods of MATLABStruct
            Console.WriteLine("Calling methods of MATLABStruct... ");
            int numFields = mStruct.Count();
            bool containsFieldA = mStruct.IsField("a");
            IEnumerable<string> fieldNames = mStruct.GetFieldNames();
            Console.WriteLine("The struct contains {0} fields", numFields);

            // Call MATLAB function with a MATLABStruct as input
            eng.disp(new RunOptions(nargout: 0), mStruct);
            
        }
    }
}
