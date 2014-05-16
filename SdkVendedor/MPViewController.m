//
//  MPViewController.m
//  SdkVendedor
//
//  Created by jgyonzo on 5/6/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import "MPViewController.h"
#import "MPCheckout.h"
#import "MPResultViewController.h"
#import "MPPayerCostInfo.h"

@interface MPViewController ()

@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *monthTextField;
@property (weak, nonatomic) IBOutlet UITextField *yearTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *docTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *docNumberTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *sharesPicker;

@property (strong, nonatomic) MPCheckout *mercadopago;
@property (strong, nonatomic) MPPaymentMethodInfo *paymentMethod;
@property (strong, nonatomic) NSString *lastBinChecked;

@end

@implementation MPViewController

//Lazy initialize the mercadopago object. Set your public key
- (MPCheckout *) mercadopago
{
    if (!_mercadopago) {
        _mercadopago = [[MPCheckout alloc]init];
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
                                                    [self updatePickerViewContent];
                                                });
                                            }
                                            onFailure:^(NSError *error){
                                                NSLog(@"Error getting payment method info %@",error);
                                            }
         ];
    }
}

//the real thing
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Post Card Info"]) {
        MPResultViewController *resultController = (MPResultViewController *) segue.destinationViewController;
        
        //Collect the user's credit card info
        MPCardTokenRequestData *card = [[MPCardTokenRequestData alloc] init];
        card.cardNumber = self.numberTextField.text;
        card.securityCode = [[[NSNumberFormatter alloc]init]numberFromString:self.codeTextField.text];
        card.expirationMonth = [[[NSNumberFormatter alloc]init]numberFromString:self.monthTextField.text];
        card.expirationYear = [[[NSNumberFormatter alloc]init]numberFromString:self.yearTextField.text];
        card.cardholderName = self.nameTextField.text;
        card.docType = self.docTypeTextField.text;
        card.docNumber = self.docNumberTextField.text;

        //Now create a Card Token.
        [self.mercadopago createTokenWithCardInfo:card
                                onSuccess:^(MPCardTokenResponseData *tokenResponse){
                                    NSLog(@"Success create token, response is %@",tokenResponse);
                                    NSString *result = [NSString stringWithFormat:@"Info posted ok! response = %@",tokenResponse];
                                    //always update UI in main queue
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [resultController setResultInfo:result];
                                    });
                                    //Post token to your server so you can create the payment from there
                                    //YOUR CODE HERE...
                                }
                                onFailure:^(NSError *error){
                                    NSLog(@"Error create token: %@",error);
                                    NSString *result = [NSString stringWithFormat:@"Error! %@",error];
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [resultController setResultInfo:result];
                                    });
                                }
        ];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.sharesPicker.hidden = YES;
    
    //hide keyboard when touching outside a text field
    tapper = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
    
    //show Done button as accessory view for numpad
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonDidPressed:)];
    UIBarButtonItem *flexableItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 30.f)];
    [toolbar setItems:[NSArray arrayWithObjects:flexableItem,doneItem, nil]];
    self.numberTextField.inputAccessoryView = toolbar;
    self.codeTextField.inputAccessoryView = toolbar;
    self.monthTextField.inputAccessoryView = toolbar;
    self.yearTextField.inputAccessoryView = toolbar;
    self.docNumberTextField.inputAccessoryView = toolbar;
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
    //
    //self.sharesPicker.hidden = NO;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.paymentMethod) {
        return [self.paymentMethod.payerCosts count];
    }else{
        return 3;
    }
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.paymentMethod) {
        MPPayerCostInfo *costInfo = (MPPayerCostInfo *)[self.paymentMethod.payerCosts objectAtIndex:row];
        NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:@"100"];
        NSString *label = [NSString stringWithFormat:@"%li x $%@",(long)costInfo.installments.integerValue, [costInfo shareAmountForAmount: amount]];
        return label;
    }else{
        return @"Shares...";
    }
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 110; //TODO
    
    return sectionWidth;
}

@end
