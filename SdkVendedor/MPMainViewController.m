//
//  MPViewController.m
//  SdkVendedor
//
//  Created by jgyonzo on 5/6/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import "MPMainViewController.h"
#import "MercadoPago.h"
#import "MPExtraDataViewController.h"
#import "MPPayerCostInfo.h"

@interface MPMainViewController ()

//outlets
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *sharesPicker;
@property (weak, nonatomic) IBOutlet UILabel *sharesLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;

//MercadoPago is the most important class, you will post credit card data to it and retrieve payment method info
@property (strong, nonatomic) MercadoPago *mercadopago;

//This is a bean where you store the payment method info from the credit card
@property (strong, nonatomic) MPPaymentMethodInfo *paymentMethod;

//just to avoid checking multiple times the last bin checked (bin = first six digits of credit card number)
@property (strong, nonatomic) NSString *lastBinChecked;

@end

@implementation MPMainViewController

//Lazy initialize the mercadopago object. Set your public key!
- (MercadoPago *) mercadopago
{
    if (!_mercadopago) {
        _mercadopago = [[MercadoPago alloc]init];
        //set your public key
        [_mercadopago setPublishableKey:@"841d020b-1077-4742-ad55-7888a0f5aefa"];
    }
    return _mercadopago;
}

//when you get enough credit card numbers in the text field (6, the card bin)
//you have to search the payment method detail.
//Then you can show share options
- (IBAction)creditCardNumberTyped:(UITextField *)sender
{
    if (sender.text.length == 6 && ![self.lastBinChecked isEqualToString:sender.text]) {
        self.lastBinChecked = sender.text;
        NSLog(@"got 6 numbers... now get the payment method info");
        [self.mercadopago paymentMethodInfoForCardBin:sender.text
                                            onSuccess:^(MPPaymentMethodInfo *paymentMethodResponse){
                                                NSLog(@"Payment method info: %@",paymentMethodResponse);
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    self.paymentMethod = paymentMethodResponse;
                                                    self.sharesLabel.text = @"Pick a share:";
                                                    self.sharesLabel.hidden = NO;
                                                    [self updatePickerViewContent];
                                                });
                                            }
                                            onFailure:^(NSError *error){
                                                NSLog(@"Error getting payment method info %@",error);
                                            }
         ];
    }else if (sender.text.length < 6){
        //when the user delete numbers, set to nil payment method detail to get it again later
        self.paymentMethod = nil;
        self.lastBinChecked = nil;
        [self updatePickerViewContent];
        
        //if you have less than 6 but more than 2, lets show a loading shares message
        if (sender.text.length > 2) {
            self.sharesLabel.text = @"Loading possible shares...";
            self.sharesLabel.hidden = NO;
        }else{
            //else just hide the label
            self.sharesLabel.hidden = YES;
        }
    }
    //TODO: validate card number to enable the next step
}

//the real thing
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ask extra data"]) {
        MPExtraDataViewController *extraDataController = (MPExtraDataViewController *) segue.destinationViewController;
        
        //In addition to the credit card number, you will need other data from the credit card to post it to MercadoPago and get a Card Token
        //So let's ask the user for the extra data in the next step
        MPCardTokenRequestData *card = [[MPCardTokenRequestData alloc] init];
        card.cardNumber = self.numberTextField.text;
        extraDataController.card = card;
        extraDataController.mercadopago = self.mercadopago;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //let's hide the shares section until the user type the first 6 digits of credit card number
    self.sharesPicker.hidden = YES;
    self.sharesLabel.hidden = YES;
    
    //hide keyboard when touching outside a text field
    tapper = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
    
    //show Done button as accessory view for numpad
    //TODO: should be Next instead of Done in some cases, change first responder
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonDidPressed:)];
    UIBarButtonItem *flexableItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 30.f)];
    [toolbar setItems:[NSArray arrayWithObjects:flexableItem,doneItem, nil]];
    self.numberTextField.inputAccessoryView = toolbar;
}

//just fancy stuff for showing/hiding the keyboard
UIGestureRecognizer *tapper;
- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}
- (void)doneButtonDidPressed:(id)sender
{
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark pickerView

- (void) updatePickerViewContent
{
    if (self.paymentMethod) {
        [self.sharesPicker reloadAllComponents];
        self.sharesPicker.hidden = NO;
    }else{
        self.sharesPicker.hidden = YES;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    //Here we just update the total amount label
    // TODO: you should save user selection to post to your server
    if (self.paymentMethod) {
        MPPayerCostInfo *costInfo = (MPPayerCostInfo *)[self.paymentMethod.payerCosts objectAtIndex:row];
        NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:@"100"];//TODO: item amount harcoded
        NSString *label = [NSString stringWithFormat:@"Total: $%@",[costInfo totalAmountForAmount: amount]];
        self.totalAmountLabel.text = label;
    }
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.paymentMethod) {
        return [self.paymentMethod.payerCosts count];
    }
    return 0;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.paymentMethod) {
        MPPayerCostInfo *costInfo = (MPPayerCostInfo *)[self.paymentMethod.payerCosts objectAtIndex:row];
        NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:@"100"];//TODO: item amount harcoded
        NSString *label = [NSString stringWithFormat:@"%li x $%@",(long)costInfo.installments.integerValue, [costInfo shareAmountForAmount: amount]];
        return label;
    }
    return @"";
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 140;
    
    return sectionWidth;
}

@end
