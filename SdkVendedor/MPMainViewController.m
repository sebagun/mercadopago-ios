//
//  MPViewController.m
//  SdkVendedor
//
//  Created by jgyonzo on 5/6/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import "MPMainViewController.h"
#import "MPInstallmentsViewController.h"
#import "MPCard.h"

@interface MPMainViewController ()

//outlets
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;

//we will strong reference the card in this controller, others should reference it weak
@property (nonatomic, strong) MPCard *card;

@end

@implementation MPMainViewController

/*
 Validate the credit card number being typed.
 Once you get a valid card number, enable the next button
 */
- (IBAction)creditCardNumberTyped:(UITextField *)sender {
    NSError *validationError;
    NSString *textRef = sender.text;
    [self.nextButton setEnabled:[self.card validateCardNumber:&textRef error:&validationError]];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"go to installments"]) {
        MPInstallmentsViewController *installmentsController = (MPInstallmentsViewController *) segue.destinationViewController;
        
        //With the creidt card number, I'll get payment method detail in next step and
        //show you installments options
        self.card.cardNumber = self.numberTextField.text;
        installmentsController.card = self.card;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.card = [[MPCard alloc] init];
    
    [self.nextButton setEnabled:NO];
    
    //hide keyboard when touching outside a text field
    UIGestureRecognizer *tapper;
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
}

//just fancy stuff for showing/hiding the keyboard
- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}
- (void)doneButtonDidPressed:(id)sender
{
    [self.view endEditing:YES];
}

@end
