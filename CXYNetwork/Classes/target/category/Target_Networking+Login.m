//
//  Target_Networking+Login.m
//  CXYNetwork_Example
//
//  Created by Avalanching on 2019/5/16.
//  Copyright © 2019 avanlanching. All rights reserved.
//

#import "Target_Networking+Login.h"
#import "CXYNetworkObject.h"

#define CXYLoginURL @"login/baidu/"

@implementation Target_Networking (Login)

- (void)Action_userLoginWithParam:(NSDictionary *)param {
    NSString *url = [self currentUrlWithSubString:CXYLoginURL];
    void(^block)(id<CXYNetworkDataProtocol>object) = param[@"back"];
    [CXYNetworkManager postWithUrl:url param:param.mutableCopy progress:nil success:^(id result) {
        if (block) {
           CXYNetworkObject *object = [[CXYNetworkObject alloc] initWithCode:CYXNetworkStatusIsSuccess result:result];
            block(object);
        }
    } faliure:^(NSError *error) {
        CXYNetworkObject *object = [[CXYNetworkObject alloc] initWithCode:CYXNetworkStatusIsOther result:error];
        block(object);
    }];
}

@end
