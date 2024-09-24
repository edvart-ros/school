/*
* VariadicFevalAsync.cpp - example in MATLAB External Interfaces
*
* This example shows how to pass multiple data types to the fevalAsync function,
* which takes no input arguments and prints the returned value.
*
* Usage : from MATLAB
          >> mex variadicFevalAsync.cpp   //To compile the code
*         >> outMatrix = variadicFevalAsync   // To execute the code
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
        callVariadicFevalAsync();
    }

    void callVariadicFevalAsync() {

        std::shared_ptr<matlab::engine::MATLABEngine> matlabPtr = getEngine();
        matlab::data::ArrayFactory factory;

        // std::complex and display results
        std::complex<double> myComplex(10.0, 2.0);
        auto conjFuture = matlabPtr->fevalAsync<std::complex<double>>(u"conj", myComplex);
        auto valueconjFuture = conjFuture.get();
        std::cout << "\n" << std::endl;
        std::cout << "Passing std::complex to variadic fevalAsync" << std::endl;
        std::cout << "The result of std::complex is" << std::endl;
        std::cout << valueconjFuture.real() << '\n';
        std::cout << valueconjFuture.imag() << '\n';

        // std::vector and display results.
        std::vector<double> dvector{4.0, 16.0, 25.0};
        auto dresultFuture = matlabPtr->fevalAsync<std::vector<double>>(u"sqrt", dvector);
        auto valuedresultFuture = dresultFuture.get();
        std::cout << "\n" << std::endl;
        std::cout << "Passing std::vector to variadic fevalAsync" << std::endl;
        std::cout << "The result of std::vector is" << std::endl;
        std::cout << valuedresultFuture[0] << '\n';
        std::cout << valuedresultFuture[1] << '\n';
        std::cout << valuedresultFuture[2] << '\n';

        //Invoke fevalAsync by passing "disp" and pass std::string directly.
        std::string value="welcome to the ";
        std::string value1="support of array_of_characters";
        std::cout << "\n" << std::endl;
        std::cout << "Passing std::string to variadic fevalAsync" << std::endl;
        std::cout << "The result of std::string is" << std::endl;
        auto stringFuture = matlabPtr->fevalAsync<std::string>(u"strcat", value, value1);
        auto valuestringFuture = stringFuture.get();
        std::cout << valuestringFuture.c_str() << std::endl;


        //Converting MATLAB CharArray to std::string
        std::string charArray="Converting CharArray to std::string";
        std::cout << "\n" << std::endl;
        std::cout << "Passing std::string to variadic fevalAsync" << std::endl;
        std::cout << "The return type of charArray is :" << std::endl;
        auto charArrayFuture = matlabPtr ->fevalAsync<std::string>(u"class", charArray);
        auto valueCharArrayFuture = charArrayFuture.get();
        std::cout << valueCharArrayFuture.c_str() << std::endl;

        //Invoke feval by passing ustring directly
        std::u16string valuestr=u"welcome to the ";
        std::u16string value1str=u"support of array_of_characters";
        //Invoke feval by passing "disp" and pass std::string directly.
        auto ustringFuture = matlabPtr ->fevalAsync<std::u16string>(u"strcat", valuestr, value1str);
        // Convert to UTF-8
        auto valueustringFuture = ustringFuture.get();
        std::string utf8str = utf16_to_utf8(valueustringFuture);
        // Print the UTF-8 string
        std::cout << "\n" << std::endl;
        std::cout << "Passing std::u16string to variadic fevalAsync" << std::endl;
        std::cout << "The result of std::u16string is" << std::endl;
        std::cout << utf8str << std::endl;


        // Invoke fevalAsync by passing multiple different types of arguments including matlab::data::Array
        matlab::data::Array argument = factory.createArray<double>({1,2},{20,30});
        auto mixedFuture = matlabPtr->fevalAsync<matlab::data::Array>(u"sum", argument, "all");
        std::cout << "\n" << std::endl;
        std::cout << "Passing multiple types to variadic fevalAsync" << std::endl;
        std::cout << "The result of mix types is" << std::endl;
        auto valuemixedFuture = mixedFuture.get();
        std::vector<size_t> dims = valuemixedFuture.getDimensions();

        // Print the values of the array
        for (int i = 0; i < dims[0]; i++) {
            for (int j = 0; j < dims[1]; j++) {
                double value = valuemixedFuture[i][j];
                std::cout << value << " ";
            }
            std::cout << std::endl;
        }
    }
};
