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
	// Do any additional setup after loading the view, typically from a nib.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Post Card Info"]) {
        MPResultViewController *resultController = (MPResultViewController *) segue.destinationViewController;
        
        MPCheckout *checkout = [[MPCheckout alloc] init];
        [checkout setPublishableKey:@"841d020b-1077-4742-ad55-7888a0f5aefa"];
        MPCardInfo *card = [[MPCardInfo alloc] init];
        card.cardNumber = self.numberTextField.text;
        card.securityCode = [[[NSNumberFormatter alloc]init]numberFromString:self.codeTextField.text];
        card.expirationMonth = [[[NSNumberFormatter alloc]init]numberFromString:self.monthTextField.text];
        card.expirationYear = [[[NSNumberFormatter alloc]init]numberFromString:self.yearTextField.text];
        card.cardholderName = self.nameTextField.text;
        card.docType = self.docTypeTextField.text;
        card.docNumber = self.docNumberTextField.text;

        [checkout createTokenWithCardInfo:card
                                onSuccess:^(NSDictionary *json, NSInteger statusCode){
                                    NSLog(@"Success create token, json response is %@",json);
                                    NSString *result = [NSString stringWithFormat:@"Info posted ok! response = %@",json];
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [resultController setResultInfo:result];
                                    });
                                }
                                onFailure:^(NSDictionary *json, NSInteger statusCode, NSError *error){
                                    NSLog(@"Error create token, json response is %@ and error is %@",json,error);
                                    NSString *result = [NSString stringWithFormat:@"Error! json response is %@ and error is %@",json,error];
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [resultController setResultInfo:result];
                                    });
                                }
        ];
    }
}

@end
