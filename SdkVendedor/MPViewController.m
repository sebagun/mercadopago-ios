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
//#import "MPJSONRestClient.h"


@interface MPViewController ()

@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *monthTextField;
@property (weak, nonatomic) IBOutlet UITextField *yearTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *docTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *docNumberTextField;
@end

@implementation MPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Post Card Info"]) {
        MPResultViewController *resultController = (MPResultViewController *) segue.destinationViewController;
        
        //Instantiate the checkout and set your public key
        MPCheckout *checkout = [[MPCheckout alloc] init];
        [checkout setPublishableKey:@"841d020b-1077-4742-ad55-7888a0f5aefa"];
        
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
        [checkout createTokenWithCardInfo:card
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

@end
