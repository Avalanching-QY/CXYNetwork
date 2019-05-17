//
//  CTMediator+CXYLogin.h
//  CXYNetwork_Example
//
//  Created by Avalanching on 2019/5/16.
//  Copyright © 2019 avanlanching. All rights reserved.
//

#import <CTMediator/CTMediator.h>
#import "CXYNetworkDataProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface CTMediator (CXYLogin)

- (void)loginWithParam:(NSDictionary *)param complete:(void(^)(id<CXYNetworkDataProtocol>object))complete;

@end

NS_ASSUME_NONNULL_END
