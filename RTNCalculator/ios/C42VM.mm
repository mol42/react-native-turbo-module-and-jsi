#include "C42VM.h"

C42VM* newC42VM(int* code,    // calistirilacak bytecode'larin bulundugu dizinin referansi
    int pc,             // baslangic program pozisyonu, ilk calistirilacak kodun pozisyonu
    int heapMemorySize) {      // lokal data ( stack disindaki data ) icin belirlenen boyut
    C42VM* vm = (C42VM*)malloc(sizeof(C42VM));
    vm->code = code;
    vm->pc = pc;
    vm->fp = 0;
    vm->sp = -1;
    vm->heap = (int*)malloc(sizeof(int) * heapMemorySize);
    vm->stack = (int*)malloc(sizeof(int) * STACK_SIZE);

    return vm;
}

void destroyC42VM(C42VM* vm){
    free(vm->heap);
    free(vm->stack);
    free(vm);
}

int runVM(C42VM* vm){
    do{
        int opcode = NEXT_BYTE_CODE(vm);        // bir bytecode oku
        int v, addr, offset, a, b, argc, rval;

        switch (opcode) {   // kodu biz yazdigimiz icin mantiken bu bytecode bir komuttur ve switch icerisinde ilgilenen ilgilendigi degeri okuma islemini ayrica yapacak
            case EXIT: 
                return -1;  // program ( ya da sonsuz dongu durur ve haliye exit gerceklesir )
            case EXIT_AND_RETURN:
                a = S_POP(vm);
                return a;
            case CONST_I32:
                v = NEXT_BYTE_CODE(vm);   // bu islem siradaki bytecode degerini okur
                S_PUSH(vm, v);     // ... ve stack'in en tepesine koyar
                break;
            case ADD_I32:
                b = S_POP(vm);        // bu islem stackin en tepesinden degeri okur ( stack 1 geri gider )
                a = S_POP(vm);        // ...sonra tekrar en tepedeki degeri okur ( bir onceki islemde stack 1 geri gitmisti... )
                S_PUSH(vm, a + b);    // ... okudugu 2 degeri toplar ve stackin en tepesine koyar
                break;
            case LT_I32:
                b = S_POP(vm);        // bu islem stackin en tepesinden degeri okur ( stack 1 geri gider )
                a = S_POP(vm);        // ...sonra tekrar en tepedeki degeri okur ( bir onceki islemde stack 1 geri gitmisti... )
                S_PUSH(vm, (a<b) ? 1 : 0); // ... okunan 2 deger karsilastirilir ve bulunan sonuc stackin en tepesine koyulur ( ikinci degisken birinciden kucuk mu kontrolu yapiliyor )
                break;
            case JMP:
                vm->pc = NEXT_BYTE_CODE(vm);  // program pozisyonunu verilen adrese gecirir yani programimiz oraya ziplar ( herhangi bir kontrol yapmadan )
                break;
            case JMPT:
                addr = NEXT_BYTE_CODE(vm);  // siradaki bytecode degerini okur ( bu deger ziplanacak adrestir )
                if(S_POP(vm)) {      // ... stackin en tepesindeki degeri cikartir ve kontrol eder
                    vm->pc = addr; // ... eger kontrol dogru ise verilen adrese ziplar
                }
                break;    
            case JMPF:
                addr = NEXT_BYTE_CODE(vm);  // siradaki bytecode degerini okur ( bu deger ziplanacak adrestir )
                if(!S_POP(vm)) {      // ... stackin en tepesindeki degeri cikartir ve kontrol eder
                    vm->pc = addr; // ... eger kontrol yanlis (false) ise verilen adrese ziplar
                }
                break;
            case EQ_I32:
                b = S_POP(vm);        // stackin en tepesinden 2. degeri okur ( stack 1 geri gider )
                a = S_POP(vm);        // stackin en tepesinden 1. degeri okur ( stack 1 geri gider )
                S_PUSH(vm, a == b);    // ... 2 degerin esitligini kontrol eder ve sonucu stackin en tepesine koyariz
                break;
            case PRINT:
                v = S_POP(vm);        // stackin en tepesindeki degeri okuruz
                printf("%d\n", v);  // ... ve ekrana bastiririz
                break;
            default:
                break;
        }
    }while(1);

    return -1;
}
  