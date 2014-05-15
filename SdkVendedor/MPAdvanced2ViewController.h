//
//  MPAdvanced2ViewController.h
//  SdkVendedor
//
//  Created by jgyonzo on 5/14/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPCardTokenRequestData.h"
#import "MPPaymentMethodInfo.h"

@interface MPAdvanced2ViewController : UIViewController<UIPickerViewDelegate>

//card data from previus step
@property (nonatomic,strong) MPCardTokenRequestData *cardData;

//store the payment method data from MP
@property (nonatomic,strong) MPPaymentMethodInfo *paymentMethodInfo;

@end
