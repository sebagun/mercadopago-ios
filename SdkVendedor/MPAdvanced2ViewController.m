//
//  MPAdvanced2ViewController.m
//  SdkVendedor
//
//  Created by jgyonzo on 5/14/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import "MPAdvanced2ViewController.h"

@interface MPAdvanced2ViewController ()

@end

@implementation MPAdvanced2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_paymentMethodInfo && self.cardData.cardNumber) {
        //get the payment method info so you can show the user bank
    }
}

#pragma mark -
#pragma mark pickerView
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows = 5;
    
    return numRows; //TODO
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2; //TODO
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0){
        return @"12 x $50";//TODO
    }else{
        return @"Banco X";//TODO
    }
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 120; //TODO
    
    return sectionWidth;
}

@end
