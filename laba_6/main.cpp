#include <iostream>
// extern "C++" void all_substring(char* first, char* second);
extern "C++" void all_substring(char* first_string, char* second_string, int, int);
extern "C++" void print_str(char*);

void print_str(char* str){
    std::cout<< str << std::endl;
}

int main() {
    char first_string[255], second_string[255];
    std::cout << "Enter two strings." << std::endl;
    std::cout << "First string: ";
    std::cin.getline(first_string, 255);
    std::cout << "Second string: ";
    std::cin.getline(second_string, 255);
    int i =0;
    int first_length = 0;

    while (i <255){
        if (first_string[i] == '\0'){
            break;
        }
        i++;
        first_length++;
    }

    i = 0;
    int second_length = 0;

    while (i <255){
        if (second_string[i] == '\0'){
            break;
        }
        i++;
        second_length++;
    }
    

    if (first_length > second_length){
        all_substring(second_string, first_string, second_length, first_length);
    } else {
        all_substring(first_string, second_string, first_length, second_length);
    }
    
    return 0;
}