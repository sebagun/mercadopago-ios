//
//  MPPaymentMethodInfo.m
//  SdkVendedor
//
//  Created by jgyonzo on 5/12/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import "MPPaymentMethodInfo.h"

@implementation MPPaymentMethodInfo

- (NSString *) description
{
    NSMutableArray *desc = [[NSMutableArray alloc]init];
    [desc addObject:@"{ paymentMethodId: "];
    [desc addObject:[NSString stringWithFormat:@"%@",self.paymentMethodId]];
    [desc addObject:@", name: "];
    [desc addObject:[NSString stringWithFormat:@"%@",self.name]];
    [desc addObject:@", paymentTypeId: "];
    [desc addObject:[NSString stringWithFormat:@"%@",self.paymentTypeId]];
    [desc addObject:@", siteId: "];
    [desc addObject:[NSString stringWithFormat:@"%@",self.siteId]];
    
    return [desc componentsJoinedByString:@""];//TODO add more fields to description
}

@end
