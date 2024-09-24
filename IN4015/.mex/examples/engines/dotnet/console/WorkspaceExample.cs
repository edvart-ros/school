/* Copyright 2022 The MathWorks, Inc. */

/*
 * This file contains examples for interacting with the MATLAB base workspace, including:
 * - Setting variables in the MATLAB base workspace.
 * - Retrieving variables from the MATLAB base workspace.
 * - Querying the MATLAB base workspace for the existence of variables.
 */
using MathWorks.MATLAB.Types;
using System;
using System.Linq;

namespace MathWorks.MATLAB.Engine.ConsoleExamples
{
    public class WorkspaceExample
    {
        public static void Run(dynamic eng)
        {
            // Set workspace variables using the MATLABWorkspace dictionary
            Console.Write("Setting workspace variables... ");
            MATLABWorkspace workspace = eng.Workspace;
            workspace["x"] = 3.14;


            // Set workspace variables using the 'eval' function
            RunOptions opts = new RunOptions() { Nargout = 0 };
            eng.eval(opts, "y = 'this is a char array';");


            // Display information on the MALTAB base workspace
            int numVars = workspace.Count;
            Console.WriteLine("There are {0} variables in the MATLAB base workspace.", numVars);

            string[] varNames = workspace.Keys.ToArray();
            Console.WriteLine("  It contains these variables: {0}", string.Join(", ", varNames));


            // Get workspace variables using the MATLABWorkspace dictionary
            Console.WriteLine("Retrieving workspace variables... ");
            double valueOfX = workspace["x"];
            string valueOfY = workspace["y"];
            Console.WriteLine("  x == {0}", valueOfX);
            Console.WriteLine("  y == \"{0}\"", valueOfY);


            // Query for the existence of particular variables
            Console.Write("Querying the value of x... ");
            if (workspace.TryGetValue("x", out valueOfX))
                Console.WriteLine("x == {0}", valueOfX);
            else
                Console.WriteLine("x does not exist in the workspace.");

            Console.Write("Querying the value of z... ");
            if (workspace.TryGetValue("z", out string valueOfZ))
                Console.WriteLine("z == {0}", valueOfZ);
            else
                Console.WriteLine("z does not exist in the workspace.");
        }
    }
}
