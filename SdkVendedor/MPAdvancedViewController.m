//
//  MPAdvancedViewController.m
//  SdkVendedor
//
//  Created by jgyonzo on 5/13/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import "MPAdvancedViewController.h"
#import "MPAdvanced2ViewController.h"
#import "MPCheckout.h"

@interface MPAdvancedViewController ()

@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *monthTextField;
@property (weak, nonatomic) IBOutlet UITextField *yearTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *docTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *docNumberTextField;

@end

@implementation MPAdvancedViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"to advanced 2"]) {
        MPAdvanced2ViewController *step2 = (MPAdvanced2ViewController *) [segue destinationViewController];
        
        //Collect the user's credit card info
        MPCardTokenRequestData *card = [[MPCardTokenRequestData alloc] init];
        card.cardNumber = self.numberTextField.text;
        card.securityCode = [[[NSNumberFormatter alloc]init]numberFromString:self.codeTextField.text];
        card.expirationMonth = [[[NSNumberFormatter alloc]init]numberFromString:self.monthTextField.text];
        card.expirationYear = [[[NSNumberFormatter alloc]init]numberFromString:self.yearTextField.text];
        card.cardholderName = self.nameTextField.text;
        card.docType = self.docTypeTextField.text;
        card.docNumber = self.docNumberTextField.text;
        
        //pass the card info to step 2
        step2.cardData = card;
    }
}

@end
