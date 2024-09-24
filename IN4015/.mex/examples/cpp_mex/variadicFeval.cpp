/*
* VariadicFeval.cpp - example in MATLAB External Interfaces
*
* This example shows how to pass multiple data types to the feval function,
* which takes no input arguments and prints the returned value.
*
* Usage : from MATLAB
          >> mex variadicFeval.cpp  //To compile the code
*         >> outMatrix = variadicsFeval  //To execute the code
*
* This is a C++ MEX-file for MATLAB.
* Copyright 2023 The MathWorks, Inc.
*
*/

#include "mex.hpp"
#include "mexAdapter.hpp"


std::string utf16_to_utf8(const std::u16string& u16str) {
    std::wstring_convert<std::codecvt_utf8_utf16<char16_t>, char16_t> convert;
    return convert.to_bytes(u16str);
}

class MexFunction : public matlab::mex::Function {
public:
    void operator()(matlab::mex::ArgumentList outputs, matlab::mex::ArgumentList inputs) {
        callVariadicFeval();
    }

    void callVariadicFeval() {

        std::shared_ptr<matlab::engine::MATLABEngine> matlabPtr = getEngine();
        matlab::data::ArrayFactory factory;

        // std::complex and display results
        std::complex<double> myComplex(10.0, 2.0);
        std::complex<double> conj = matlabPtr->feval<std::complex<double>>(u"conj", myComplex);
        std::cout << "\n" << std::endl;
        std::cout << "Passing std::complex to variadic feval" << std::endl;
        std::cout << "The result of std::complex is" << std::endl;
        std::cout << conj.real() << '\n';
        std::cout << conj.imag() << '\n';

        // std::vector and display results.
        std::vector<double> dvector{4.0, 16.0, 25.0};
        std::vector<double> dresult = matlabPtr->feval<std::vector<double>>(u"sqrt", dvector);
        std::cout << "\n" << std::endl;
        std::cout << "Passing std::vector to variadic feval" << std::endl;
        std::cout << "The result of std::vector is" << std::endl;
        std::cout << dresult[0] << '\n';
        std::cout << dresult[1] << '\n';
        std::cout << dresult[2] << '\n';

        //Invoke feval by passing "disp" and pass std::string directly.
        std::string value="welcome to the ";
        std::string value1="support of array_of_characters";
        std::cout << "\n" << std::endl;
        std::cout << "Passing std::string to variadic feval" << std::endl;
        std::cout << "The result of std::string is" << std::endl;
        std::string stringresult = matlabPtr->feval<std::string>(u"strcat", value, value1);
        std::cout << stringresult.c_str() << std::endl;

        //Converting MATLAB CharArray to std::string
        std::string charArray="Converting CharArray to std::string";
        std::cout << "\n" << std::endl;
        std::cout << "Passing std::string to variadic feval" << std::endl;
        std::cout << "The return type of charArray is :" << std::endl;
        std::string chararrayresult = matlabPtr->feval<std::string>(u"class", value);
        std::cout << chararrayresult.c_str() << std::endl;

        //Invoke feval by passing ustring directly
        std::u16string valuestr=u"welcome to the ";
        std::u16string value1str=u"support of array_of_characters";
        //Invoke feval by passing "disp" and pass std::string directly.
        std::u16string resultstr = matlabPtr ->feval<std::u16string>(u"strcat", valuestr, value1str);
        // Convert to UTF-8
        std::string utf8str = utf16_to_utf8(resultstr);
        // Print the UTF-8 string
        std::cout << "\n" << std::endl;
        std::cout << "Passing std::u16string to variadic feval" << std::endl;
        std::cout << "The result of std::u16string is" << std::endl;
        std::cout << utf8str << std::endl;

        // Invoke feval by passing multiple different types of arguments including matlab::data::Array
        matlab::data::Array argument = factory.createArray<double>({1,2},{20,30});
        std::cout << "\n" << std::endl;
        std::cout << "Passing multiple types to variadic feval" << std::endl;
        std::cout << "The result of mix types is" << std::endl;

        auto mixedresult = matlabPtr->feval<matlab::data::Array>(u"sum", argument, "all");
        std::vector<size_t> dims = mixedresult.getDimensions();

        // Print the values of the array
        for (int i = 0; i < dims[0]; i++) {
            for (int j = 0; j < dims[1]; j++) {
                double value = mixedresult[i][j];
                std::cout << value << " ";
            }
            std::cout << std::endl;
        }
    }
};
