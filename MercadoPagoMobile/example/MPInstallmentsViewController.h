//
//  MPInstallmentsViewController.h
//  MercadoPagoMobile
//
//  Created by jgyonzo on 5/30/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPCard.h"

@interface MPInstallmentsViewController : UIViewController<UIPickerViewDelegate>

@property (nonatomic, strong) MPCard *card;

@end
