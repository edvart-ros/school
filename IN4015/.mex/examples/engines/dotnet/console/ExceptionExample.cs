/* Copyright 2022 The MathWorks, Inc. */

/*
 * This file contains examples of exception handling, which may be thrown if:
 * - The application cannot find or connect to MATLAB.
 * - A error occurs when executing a MATLAB function.
 * - An unsupported .NET type is used as an argument to a MATLAB function.
 * - A MATLAB type cannot be converted to a particular .NET type.
 */ 
using MathWorks.MATLAB.Exceptions;
using MathWorks.MATLAB.Types;
using System;

namespace MathWorks.MATLAB.Engine.ConsoleExamples
{
    public class ExceptionExample
    {
        public static void Run(dynamic eng)
        {
            // If MATLAB is not available, a MATLABNotAvailableException will be thrown.
            const string nameThatDoesNotExist = "unknown_matlab";
            Console.Write("Connecting to MATLAB {0}... ", nameThatDoesNotExist);
            try
            {
                eng = MATLABEngine.ConnectMATLAB(nameThatDoesNotExist);
            }
            catch (MATLABNotAvailableException)
            {
                Console.WriteLine("MATLAB {0} does not exist.", nameThatDoesNotExist);
            }


            // If a runtime error occurs, a MATLABExecutionException will be thrown. 
            // The error text is forwarded to Console.Error by default. 
            // This behavior may be modified with the Error property of a RunOptions instance.
            Console.Write("Calling MATLAB function unknown_function... ");
            try
            {
                eng.unknown_function();
            }
            catch (MATLABExecutionException) { }


            // If a .NET type cannot be converted to a MATLAB type,
            // an UnsupportedTypeException will be thrown.
            Console.Write("Sending a System.Decimal to MATLAB... ");
            try
            {
                decimal someUnsupportedData = decimal.One;
                eng.disp(new RunOptions() { Nargout = 0 }, someUnsupportedData);
            }
            catch (UnsupportedTypeException e)
            {
                Console.WriteLine(e.Message);
            }


            // If a MATLAB type cannot be converted to a .NET type,
            // a System.InvalidCastException will be thrown.
            Console.Write("Converting a MATLAB char array to System.Double... ");
            try
            {
                double notADouble = eng.eval(" 'this is a char array' ");
            }
            catch (InvalidCastException e)
            {
                Console.WriteLine(e.Message);
            }
        }
    }
}
