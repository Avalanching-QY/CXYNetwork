//
//  CTMediator+CXYLogin.m
//  CXYNetwork_Example
//
//  Created by Avalanching on 2019/5/16.
//  Copyright © 2019 avanlanching. All rights reserved.
//

#import "CTMediator+CXYLogin.h"

NSString * const kCTMediatorTarget = @"Networking";
NSString * const kCTMediatorLoginAction = @"userLoginWithParam";
@implementation CTMediator (CXYLogin)

- (void)loginWithParam:(NSDictionary *)param complete:(void(^)(id<CXYNetworkDataProtocol>object))complete {
    NSMutableDictionary *params = @{}.mutableCopy;
    if (param && complete) {
        [params setObject:param forKey:@"param"];
        [params setObject:complete forKey:@"back"];
    } else if (complete) {
        [params setObject:complete forKey:@"back"];
    }
    
    [self performTarget:kCTMediatorTarget action:kCTMediatorLoginAction params:params shouldCacheTarget:NO];
}

@end
