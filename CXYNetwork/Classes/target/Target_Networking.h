//
//  Target_Networking.h
//  CXYNetwork_Example
//
//  Created by Avalanching on 2019/5/16.
//  Copyright © 2019 avanlanching. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXYNetworkManager.h"
#import <ReactiveObjC/ReactiveObjC.h>

typedef void(^TargetNetworkingBlock)(id jsonObject, BOOL isSuccess);

@interface Target_Networking : NSObject

+ (instancetype)singletons;

- (NSString *)currentUrlWithSubString:(NSString *)suffix;

@end
