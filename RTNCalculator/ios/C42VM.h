#include <stdio.h>

#define STACK_SIZE 100

typedef struct {
    int* heap;    // stack disinda tutulacak datalarin baslangic adresi ( pointer )
    int* code;      // calistirilacak kodlarin arrayine ait referans ( pointer )
    int* stack;     // yaratilan stackin baslangic adresini tutan referans ( pointer )
    int pc;         // program pozisyonunu tutan degisken
    int sp;         // stack pozisyonunu tutan degisken
    int fp;         // goreceli pozisyonlama icin kullanilan cercevenin pozisyonunu tutan degisken
} C42VM;

enum {
    ADD_I32 = 1,    // tam sayi toplama
    LT_I32 = 5,     // tam sayi kucuktur kontrolu ( x < 5 gibi )
    EQ_I32 = 6,     // tam sayi esittir kontrolu
    JMP = 7,        // dallan ( verilen program adresine git )
    JMPT = 8,       // eger true ise dallan
    JMPF = 9,       // eger false ise dallan
    CONST_I32 = 10,  // tam sayi degeri stacke koy
    PRINT = 15,     // stackin en tepesindeki sayiyi ekrana yazdir
    EXIT = 17,      // programi durdur
    EXIT_AND_RETURN = 99
};

#define S_PUSH(vm, v) vm->stack[++vm->sp] = v // stackin tepesine bir deger koy ( C derlenirken kodlarda S_PUSH olan yere arka planda "vm->stack[++vm->sp] = v" yazar )
#define S_POP(vm)     vm->stack[vm->sp--]     // stackin tepesinden bir deger al
#define NEXT_BYTE_CODE(vm)   vm->code[vm->pc++]      // siradaki bytecode degerini oku ( bytecode bir komut, deger ya da referans olabilir illa ki komut olmak zorunda degil ! )

C42VM* newC42VM(int* code,
    int pc,             
    int heapMemorySize);

void destroyC42VM(C42VM* vm);

int runVM(C42VM* vm);