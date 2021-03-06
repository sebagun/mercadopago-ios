//
//  MPExtraDataViewController.h
//  MercadoPagoMobile
//
//  Created by jgyonzo on 5/18/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MercadoPago.h"
#import "MPCard.h"

@interface MPExtraDataViewController : UIViewController

@property (strong, nonatomic) MPCard *card;
@property (nonatomic) NSInteger installments;

@end
