//
//  MPTrustDefenderDelegate.m
//  SdkVendedor
//
//  Created by jgyonzo on 5/19/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import "MPTrustDefenderDelegate.h"

@interface MPTrustDefenderDelegate ()

@end

@implementation MPTrustDefenderDelegate

-(void) profileComplete: (thm_status_code_t) status;
{
    if(status == THM_OK){
        // No errors, profiling succeeded!
        NSLog(@"profile complete!! succeded!");
    }else{
        NSLog(@"Profile error!! %u",status);
    }
}

@end
