//
//  CalculatorBrain.m
//  PocketCalculator
//
//  Created by Pham Thanh on 12/4/15.
//  Copyright © 2015 Pham Thanh. All rights reserved.
//

#import "CalculatorBrain.h"

@implementation CalculatorBrain

// ----------------------
// init
- (id) init{
    _lstNumbers = [[NSMutableArray alloc] init];
    _lstOperations = [[NSMutableArray alloc] init];
    _expressionStack = [[NSMutableArray alloc] init];
    
    //round to 16 digits decimal
    _formatter = [[NSNumberFormatter alloc] init];
    _formatter.numberStyle = NSNumberFormatterDecimalStyle;
    _formatter.maximumFractionDigits = 16;
    _formatter.roundingMode = NSNumberFormatterRoundUp;
    
    return [super init];
}

// ----------------------
// push number to array
- (void) pushNumbers:(NSNumber*) number
{
    if(number != nil){
        [_expressionStack addObject:[number stringValue]];
    }
    [_lstNumbers addObject:number];
}

// ----------------------
// get last number
-(NSNumber*) getLastNumber{
    return [_lstNumbers lastObject];
}

// ----------------------
// push operation to array
- (void) pushOperations:(NSString*) operation
{
    [_expressionStack addObject:operation];
    [_lstOperations addObject:operation];
}

// ----------------------
// get last operation
- (NSString*) getLastOperation{
    return [_lstOperations lastObject];
}


// ----------------------
// calculate
- (NSNumber*) performOperation{
    NSNumber* result = 0;
    
    if([_lstOperations count] > 0){
        NSNumber* operand2 = nil;
        NSNumber* operand1 = nil;
        
        if([_lstNumbers count] > 0){
            operand2 = [_lstNumbers lastObject];
            [_lstNumbers removeLastObject];
        }
        if([_lstNumbers count] > 0){
            operand1 = [_lstNumbers lastObject];
        }
        
        
        unichar operator = [[_lstOperations lastObject] characterAtIndex:0];
        switch (operator){
            case '%':
                result = [NSNumber numberWithDouble: [operand2 doubleValue] / 100.0f];
                break;
            case L'±':
                result = [NSNumber numberWithDouble:[operand2 doubleValue] * -1];
                break;
            case L'÷':
                result = [NSNumber numberWithDouble:[operand1 doubleValue] / [operand2 doubleValue]];
                [_lstNumbers removeLastObject];
                break;
            case L'×':
                result = [NSNumber numberWithDouble:[operand1 doubleValue] * [operand2 doubleValue]];
                [_lstNumbers removeLastObject];
                break;
            case L'−':
                result = [NSNumber numberWithDouble:[operand1 doubleValue] - [operand2 doubleValue]];
                [_lstNumbers removeLastObject];
                break;
            case L'+':
                result = [NSNumber numberWithDouble:[operand1 doubleValue] + [operand2 doubleValue]];
                [_lstNumbers removeLastObject];
                break;
        }
        
        [_lstOperations removeLastObject];
        
    }

    return result;
}

// ----------------------
// reset
- (void) resetBrain{
    [_lstNumbers removeAllObjects];
    [_lstOperations removeAllObjects];
}

// ----------------------
// format number
- (NSString*) formatValue:(NSNumber*)number{
    NSString *strValue = [number stringValue];
    
    strValue = [_formatter stringFromNumber:number];
    
    return strValue;
}

// ----------------------
// push expression stack
- (void) pushExpressioStack:(NSString *)item{
    [_expressionStack addObject:item];
}

// ----------------------
// check expression valid
- (BOOL) checkExpressionValid:(NSString*) addValue{
    BOOL rs = true;
    
    if([_expressionStack count] > 0){
        NSString *item = [_expressionStack lastObject];
        
        if([item characterAtIndex:0] == L'+' || [item characterAtIndex:0] == L'−' ||
           [item characterAtIndex:0] == L'×' || [item characterAtIndex:0] == L'÷' ){
            if([addValue characterAtIndex:0] == L'+' || [addValue characterAtIndex:0] == L'−' ||
               [addValue characterAtIndex:0] == L'×' || [addValue characterAtIndex:0] == L'÷' ){
                rs = false;
            }
        }
    }

    return rs;
}


@end
