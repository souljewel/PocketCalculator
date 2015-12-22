//
//  CalculatorBrain.h
//  PocketCalculator
//
//  Created by Pham Thanh on 12/4/15.
//  Copyright © 2015 Pham Thanh. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CalculatorBrain : NSObject
@property NSMutableArray* lstNumbers;
@property NSMutableArray* lstOperations;
@property NSNumberFormatter* formatter;
@property NSMutableArray* expressionStack;

- (void) pushNumbers:(NSNumber*) number;
-(NSNumber*) getLastNumber;
- (void) pushOperations:(NSString*) operation;
- (NSString*) getLastOperation;
- (void) pushExpressioStack:(NSString*) item;

- (NSNumber*) performOperation;
- (NSString*) formatValue:(NSNumber*)number;
- (BOOL) checkExpressionValid:(NSString*)addValue;
- (void) resetBrain;
@end