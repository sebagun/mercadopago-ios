//
//  MPExtraDataViewController.m
//  SdkVendedor
//
//  Created by jgyonzo on 5/18/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import "MPExtraDataViewController.h"
#import "MPResultViewController.h"

@interface MPExtraDataViewController ()

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *monthTextField;
@property (weak, nonatomic) IBOutlet UITextField *yearTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *docTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *docNumberTextField;

@end

@implementation MPExtraDataViewController

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

//TODO: implement field validators

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Post Card Info"]) {
        MPResultViewController *resultController = (MPResultViewController *) segue.destinationViewController;
        
        //Collect the user's credit card info
        self.card.securityCode = self.codeTextField.text;
        self.card.expirationMonth = [[[NSNumberFormatter alloc]init]numberFromString:self.monthTextField.text];
        self.card.expirationYear = [[[NSNumberFormatter alloc]init]numberFromString:self.yearTextField.text];
        self.card.cardholderName = self.nameTextField.text;
        self.card.cardholderIDType = self.docTypeTextField.text;
        self.card.cardholderIDNumber = self.docNumberTextField.text;
        
        //Now post the information to MercadoPago to create a Card Token.
        [MercadoPago createTokenWithCard:self.card
                                        onSuccess:^(MPCardToken *tokenResponse){
                                            NSLog(@"Success creating token, response is %@",tokenResponse);
                                            NSString *result = [NSString stringWithFormat:@"Info posted ok! response = %@",tokenResponse];
                                            //always update UI in main queue
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [resultController setResultInfo:result];
                                            });
                                            //Post token to your server so you can create the payment from there
                                            //If the user selected installments, you will need that info in your server
                                            //TODO: YOUR CODE HERE...
                                        }
                                        onFailure:^(NSError *error){
                                            NSLog(@"Error creating token: %@",error);
                                            NSString *result = [NSString stringWithFormat:@"Error! %@",error];
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [resultController setResultInfo:result];
                                            });
                                        }
         ];
    }
}

@end
