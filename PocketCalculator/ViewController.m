//
//  ViewController.m
//  PocketCalculator
//
//  Created by Pham Thanh on 12/3/15.
//  Copyright © 2015 Pham Thanh. All rights reserved.
//

#import "ViewController.h"
#import "CalculatorBrain.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UILabel *lblDisplay;
@property CalculatorBrain *calculatorBrain;
@end

@implementation ViewController

bool isInputNumber = false;
bool isNeedCalculation = false;
bool isPressEqual = false;
NSString* currDisplay = @"0";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _calculatorBrain = [[CalculatorBrain alloc] init];
    
    //set status bar color
    [self setNeedsStatusBarAppearanceUpdate];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

// ----------------------
// get numbers
- (IBAction)pressNumbers:(UIButton *)sender {
    NSString* number = sender.currentTitle;
    NSLog(@"%@",number);
    
    if(!isInputNumber){
        currDisplay = number;
        isInputNumber = true;
    }else{
        currDisplay = [currDisplay stringByAppendingString:number];
    }
    _lblDisplay.text = currDisplay;
    
    [_calculatorBrain pushExpressioStack:currDisplay];
    isPressEqual = false;
}

// ----------------------
// get operators
- (IBAction)pressOperator:(UIButton *)sender {
    NSString* operator = sender.currentTitle;
    
    if([operator compare:@"%"] == 0 || [operator compare:@"±"] == 0){
        [_calculatorBrain pushOperations:operator];
        [self calculate];
    }else{

        if([_calculatorBrain checkExpressionValid:operator] == false){
            return;
        }
        
        //check is need calculate
        if(isNeedCalculation){
            [self calculate];
        }
        

        
        //push numbers to array
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *number = [f numberFromString:currDisplay];
        [_calculatorBrain pushNumbers:number];
        
        //press Operator
        [_calculatorBrain pushOperations:operator];
        
        NSLog(@"%@",operator);
        
        //reset input
        isInputNumber = false;
        
        if(isNeedCalculation == false){
            isNeedCalculation = true;
        }
    }
    
    isPressEqual = false;
}

// ----------------------
// press AC
- (IBAction)pressAC:(id)sender {
    [self reset];
}

// ----------------------
// press =
- (IBAction)pressEqual:(id)sender {
    if(isPressEqual){
        return;
    }
    [self calculate];
    isInputNumber = false;
    isPressEqual = true;
}

- (void)calculate {
    //push operand to array
    if(currDisplay != nil && [currDisplay length] > 0){
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *number = [f numberFromString:currDisplay];
        [_calculatorBrain pushNumbers:number];
        
        [self performOperation];
//        if([currDisplay length] ==0){
//            
//        }
        [self show:currDisplay];
        isNeedCalculation = false;
    }
}

// ----------------------
// calculate
- (void) performOperation{
    NSNumber* rs = [_calculatorBrain performOperation];
    currDisplay = [_calculatorBrain formatValue:rs];
}

// ----------------------
// show display
- (void) show:(NSString*) value{
    _lblDisplay.text = value;
    NSLog(@"%@",value);
}

// ----------------------
// reset calculator
- (void) reset{
    isPressEqual = false;
    isNeedCalculation = false;
    isInputNumber = false;
    [_calculatorBrain resetBrain];
    currDisplay = @"0";
    [self show:currDisplay];
}

@end
