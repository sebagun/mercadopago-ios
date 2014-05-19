//
//  MPExtraDataViewController.h
//  SdkVendedor
//
//  Created by jgyonzo on 5/18/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MercadoPago.h"
#import "MPCardTokenRequestData.h"

@interface MPExtraDataViewController : UIViewController

//warning: strong?
@property (strong, nonatomic) MercadoPago *mercadopago;
@property (strong, nonatomic) MPCardTokenRequestData *card;

@end
