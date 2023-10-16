#include <iostream>
#include <cstring>
#include <algorithm>


class Command {

    private:

    public:

    int start, len_arr_spec, len_arr_new_string, len_arr_id;
    char* command, *input_string;
    bool correct;
    char arr_spec[10][10], arr_new_string[10][2], arr_id[10][10];

    Command(char* command, char* input_string){
        this->command = command;
        this->input_string = input_string;
        this->start = 0;
        this->correct = true;
    }

    void printCommand(){
        if (this->correct){
            std::cout << "Detected command " << this->command << std::endl;
            for (int i = 0; i < this->len_arr_spec; i ++) std::cout << "Detceted specification " << this->arr_spec[i] << std::endl;
            std::cout << "Detceted \\n " << this->len_arr_new_string << std::endl;
            for (int i = 0; i < this->len_arr_id; i ++) std::cout << "Detceted id " << this->arr_id[i] << std::endl;
        }
        

    }

    void scanFirstParametr(){
        int i = this->start, j = 0;
        char parametr[1000];

        while(this->input_string[i] != '"' && i < strlen(input_string)) {
            parametr[j] = this->input_string[i];
            i++;
            j++;
        }

        if (i == strlen(input_string)) {
            this->correct = false;
            std::cout << "Expected \" " << std::endl;
        } 
        else {
            parametr[j] = '\0';
            this->start += (j + 1);
            bool spec = false, new_string = false;
            char str_spec[10], str_new_string[2];
            char arr_spec_symb[] = {'d', 'c', 's', 'f'};
            int n = sizeof(arr_spec_symb) / sizeof(*arr_spec_symb);
            int k = 0, c = 0, i = 0;

            while (i < strlen(parametr) && this->correct) {

                if (new_string) {
                    if (parametr[i] == 'n') {
                        new_string = false;
                        str_new_string[1] = 'n';
                        strcpy(arr_new_string[c], str_new_string);
                        c++;
                    } else {
                        this->correct = false;
                        std::cout << "Expected symbol 'n'" << std::endl;
                    }
                }

                if (spec){

                    if (parametr[i] >= '0' && parametr[i] <= '9'){
                        str_spec[j] = parametr[i];
                        j++;
                    }else{

                        if (std::find(arr_spec_symb, arr_spec_symb + n, parametr[i]) != arr_spec_symb + n) {
                            spec = false;
                            str_spec[j] = parametr[i];
                            str_spec[j+1] = '\0';
                            strcpy(this->arr_spec[k], str_spec);
                            k++;
                        } else {
                            this->correct = false;
                            std::cout << "Epected digit or [d, c, s, f] after %" << std::endl;
                        }
                    }
                }

                if (parametr[i] == '%' && !spec){
                    spec = true;
                    j = 0;
                    str_spec[0] = '%';
                }

                if (parametr[i] == '\\' && !new_string) {
                    new_string = true;
                    str_new_string[0] = '\\';
                }
                i++;
            }
            this->len_arr_new_string = c;
            this->len_arr_spec = k;
        }
    }

     void find_last(){
        if (this->correct){
            this->start += 1;
            if (!(this->input_string[this->start] == ';')) {
                this->correct = false;
                std::cout << "Expected symbol ';'" << std::endl;
            }
        }
    }

};


class Printf: public Command{
    
    public:

    Printf(char* command, char* input_string): Command(command, input_string) {
        
        this->start += 6;
    }

    bool scanCommand() {
        if(this->input_string[start] == '('){
            this->start += 1;
        } else { 
            this->correct = false; 
            std::cout << "Expected '('" << std::endl;
            return this->correct;
        }

        if(this->correct && this->input_string[start] == '"') {
            this->start += 1;
            scanFirstParametr();
            find_id();
            find_last();
        } else {
            this->correct = false; 
            std::cout << "Expected \" " << std::endl;
        }

        return this->correct;
    }

   

    void find_id(){
        bool first_symb = true;
        char output[10];
        int j = 0, k = 0;
        while(this->input_string[this->start] != ')' && this->correct && this->start < strlen(this->input_string)) {
            if (this->input_string[this->start] == ',') {
                first_symb = true;

                if (j > 0) {
                    output[j] = '\0';
                    strcpy(this->arr_id[k], output);
                    k++;
                    j = 0;
                }
                
            } else {

                if (first_symb){
                    first_symb = false;
                    if ((this->input_string[this->start] >= 'a' && this->input_string[this->start] <= 'z') ||
                     (this->input_string[this->start] >= 'A' && this->input_string[this->start] <= 'Z')) {
                        output[j] = this->input_string[this->start];
                        j++;
                     } else {
                        this->correct = false;
                        std::cout << "Incorrect symbols" << std::endl;
                     }
                } else {
                    if ((this->input_string[this->start] >= 'a' && this->input_string[this->start] <= 'z') ||
                     (this->input_string[this->start] >= 'A' && this->input_string[this->start] <= 'Z') ||
                     (this->input_string[this->start] >= '0' && this->input_string[this->start] <= '9')
                     ) {
                        output[j] = this->input_string[this->start];
                        j++;
                     } else {
                        this->correct = false;
                        std::cout << "Incorrect symbols" << std::endl;
                     }
                }
            }
            this->start += 1;
        }

        if (this->start == strlen(this->input_string)){
            this->correct = false;
        }

         if (j > 0) {
            output[j] = '\0';
            strcpy(this->arr_id[k], output);
            k++;
            j = 0;
        }

        this->len_arr_id = k;
    }

};


class Scanf: public Command {

    public:

    Scanf(char* command, char* input_string): Command(command, input_string) {
        this->start += 5;
    }

    bool scanCommand() {
        if(this->input_string[start] == '('){
            this->start += 1;
        } else { 
            this->correct = false; 
            std::cout << "Expected '('" << std::endl;
            return this->correct;
        }

        if(this->correct && this->input_string[start] == '"') {
            this->start += 1;
            scanFirstParametr();
            find_id();
            find_last();
        } else {
            this->correct = false; 
            std::cout << "Expected \" " << std::endl;
        }

        return this->correct;
    }

    void find_id(){
        bool first_symb = true;
        char output[10];
        int j = 0, k = 0;
        while(this->input_string[this->start] != ')' && this->correct && this->start < strlen(this->input_string)) {
            if (this->input_string[this->start] == ',') {
                first_symb = true;

                if (j > 0) {
                    output[j] = '\0';
                    strcpy(this->arr_id[k], output);
                    k++;
                    j = 0;
                }
                
            } else {

                if (first_symb){
                    first_symb = false;
                    if ((this->input_string[this->start] >= 'a' && this->input_string[this->start] <= 'z') ||
                     (this->input_string[this->start] >= 'A' && this->input_string[this->start] <= 'Z') || 
                     this->input_string[this->start] == '&') {
                        output[j] = this->input_string[this->start];
                        j++;
                     } else {
                        this->correct = false;
                        std::cout << "Incorrect symbols" << std::endl;
                     }
                } else {
                    if ((this->input_string[this->start] >= 'a' && this->input_string[this->start] <= 'z') ||
                     (this->input_string[this->start] >= 'A' && this->input_string[this->start] <= 'Z') ||
                     (this->input_string[this->start] >= '0' && this->input_string[this->start] <= '9')
                     ) {
                        output[j] = this->input_string[this->start];
                        j++;
                     } else {
                        this->correct = false;
                        std::cout << "Incorrect symbols" << std::endl;
                     }
                }
            }
            this->start += 1;
        }

        if (this->start == strlen(this->input_string)){
            this->correct = false;
        }

         if (j > 0) {
            output[j] = '\0';
            strcpy(this->arr_id[k], output);
            k++;
            j = 0;
        }

        this->len_arr_id = k;
    }

};



class Scaner {
    private:

    char* string;
    char* command;

    void removeExtraSpace(int length){
        char output[length];
        int i = 0, j = 0;
        while (this->string[i] != '\0'){
            if (!(this->string[i] == ' ' )){
                output[j] = this->string[i];
                j++;
            }
            i++;
        }
        strcpy(this->string, output);
    }

    char* findCommand(int length){
        char* command = new char[8];
        if (std::strncmp(this->string, "printf", 6) == 0) {
            for (int i = 0; i < 6; i ++) command[i] = this->string[i];
            command[6] = '\0';
            return command;
        }

        if (std::strncmp(this->string, "scanf", 5) == 0) {
            for (int i = 0; i < 5; i ++) command[i] = this->string[i];
            command[5] = '\0';
            return command;
        }   

        return 0;
    }

    bool chooseCommand(){

        bool correct = false;

        if (strcmp(this->command, "printf") == 0) {
            Printf p = Printf(this->command, this->string);
            p.scanCommand();
            p.printCommand();
            correct = p.correct;
        }

        if (strcmp(this->command, "scanf") == 0) {
            Scanf p = Scanf(this->command, this->string);
            p.scanCommand();
            p.printCommand();
            correct = p.correct;
        }

        return correct;
    }

    public:


    Scaner(char* string){
        this->string = string;
    }

    bool scanString() {
        removeExtraSpace(std::strlen(this->string));
        this->command = findCommand(std::strlen(this->string));
        if (this->command) return chooseCommand();

        return false;
    }
};



int main(){
    char input_string[1000];
    std::cout << "Enter string:" << std::endl;
    std::cin.getline(input_string, sizeof(input_string));
    Scaner scan = Scaner(input_string);
    scan.scanString();
}