#include <iostream>
#include <cstring>

extern "C++" void combination_of_letters(char* string, char* combination, int length_string, int length_combination);
extern "C++" void print(char*);

int main() {
    char string[256], combination[23];

    std::cout << "Input String: " << std::endl;
    std::cin.getline(string, 256);

    std::cout << "Input combination of letters: " << std::endl;
    std::cin.getline(combination, 23);

    int length_string = strlen(string), length_combination = strlen(combination);
    combination_of_letters(string, combination, length_string, length_combination);
    return 0;
}

void print(char* str) {
    std::cout<<str<<std::endl;
}
