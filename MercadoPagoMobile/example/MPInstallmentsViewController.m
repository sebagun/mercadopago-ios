//
//  MPInstallmentsViewController.m
//  SdkVendedor
//
//  Created by jgyonzo on 5/30/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import "MPInstallmentsViewController.h"
#import "MPPaymentMethod.h"
#import "MPPayerCost.h"
#import "MercadoPago.h"
#import "MPExtraDataViewController.h"

@interface MPInstallmentsViewController ()

@property (weak, nonatomic) IBOutlet UIPickerView *installmentsPicker;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;

@property (nonatomic) NSInteger installments;

//This is a bean where you store the payment method info from the credit card
@property (strong, nonatomic) MPPaymentMethod *paymentMethod;

@end

@implementation MPInstallmentsViewController

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
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.paymentMethod) {
        [self.card fillPaymentMethodExecutingOnSuccess:^(MPPaymentMethod *paymentMethodResponse){
            NSLog(@"Payment method info: %@",paymentMethodResponse);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.paymentMethod = paymentMethodResponse;
                [self.installmentsPicker reloadAllComponents];
            });
        } onFailure:^(NSError *error){
            NSLog(@"Error getting payment method info %@",error);
        }];
    }
}

#pragma mark - Navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     if ([segue.identifier isEqualToString:@"ask extra data"]) {
         MPExtraDataViewController *extraDataController = (MPExtraDataViewController *) segue.destinationViewController;
         extraDataController.card = self.card;
         extraDataController.installments = self.installments;
     }
 }

#pragma mark -
#pragma mark installments pickerView

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    //Here we just update the total amount label
    // TODO: you should save user selection to post to your server
    if (self.paymentMethod) {
        MPPayerCost *costInfo = (MPPayerCost *)[self.paymentMethod.payerCosts objectAtIndex:row];
        NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:@"100"];//TODO: item amount harcoded
        NSString *label = [NSString stringWithFormat:@"Total: $%@",[costInfo totalAmountForAmount: amount]];
        self.totalAmountLabel.text = label;
        self.installments = [costInfo.installments integerValue];
    }
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.paymentMethod) {
        return [self.paymentMethod.payerCosts count];
    }
    return 1;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.paymentMethod) {
        MPPayerCost *costInfo = (MPPayerCost *)[self.paymentMethod.payerCosts objectAtIndex:row];
        NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:@"100"];//TODO: handle your item amount!!
        NSString *label = [NSString stringWithFormat:@"%li x $%@",(long)costInfo.installments.integerValue, [costInfo installmentAmountForAmount: amount]];
        return label;
    }
    return @"1 x $100";
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 140;
    
    return sectionWidth;
}
@end
