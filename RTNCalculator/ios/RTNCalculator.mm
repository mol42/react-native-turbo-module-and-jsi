#import "RTNCalculatorSpec.h"
#import "RTNCalculator.h"
#import "C42VM.h"

@implementation RTNCalculator

RCT_EXPORT_MODULE()

- (void)add:(double)a b:(double)b resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    NSNumber *result = [[NSNumber alloc] initWithInteger:a+b];
    resolve(result);
}

- (NSNumber *)addSync:(double)a
                    b:(double)b {
    NSNumber *result = [[NSNumber alloc] initWithInteger:a+b];         
    return result;  
}

- (NSNumber *)runC42VMSync {
    int program[] = {
        CONST_I32, 10,
        CONST_I32, 3,
        ADD_I32,
        EXIT_AND_RETURN            
    };
    
    // initialize virtual machine
    C42VM* vm = newC42VM(program,
                       0, // main 7. index
                       100);
                       
    int resultFromVM = runVM(vm);

    NSNumber *result = [[NSNumber alloc] initWithInteger:resultFromVM];         
    return result;  
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeCalculatorSpecJSI>(params);
}

@end