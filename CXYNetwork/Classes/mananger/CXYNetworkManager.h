//
//  CXYNetworkManager.h
//  CXYNetwork_Example
//
//  Created by Avalanching on 2019/5/16.
//  Copyright © 2019 avanlanching. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void(^HTTPRequestSuccessBlock)(id result);
typedef void(^HTTPRequestFaliureBlock)(NSError *error);
typedef void(^HTTPRequestProgressBlock)(NSProgress *downloadProgress);

@interface CXYNetworkManager : NSObject

+ (AFHTTPSessionManager *)configureSessionManager;
/*
 @method getWithUrl:progress:success:failure:
 @abstrac 发起get请求
 @discussion 发起get请求
 @param url
 @param progress 进度（可传nil）
 @param success 成功回调
 @param faliure 失败回调
 @result void
 */
+ (void)getWithUrl:(NSString *)url progress:(HTTPRequestProgressBlock)progress success:(HTTPRequestSuccessBlock)success faliure:(HTTPRequestFaliureBlock)faliure;

/*
 @method putWithUrl:param:success:failure:
 @abstrac 发起put请求
 @discussion 发起put请求
 @param url
 @param param 参数
 @param success 成功回调
 @param faliure 失败回调
 @result void
 */
+ (void)putWithUrl:(NSString *)url param:(NSMutableDictionary *)param success:(HTTPRequestSuccessBlock)success faliure:(HTTPRequestFaliureBlock)faliure;

/*
 @method postWithUrl:param:progress:success:failure:
 @abstrac 发起post请求
 @discussion 发起post请求
 @param url
 @param param 参数
 @param progress 进度（可传nil）
 @param success 成功回调
 @param faliure 失败回调
 @result void
 */
+ (void)postWithUrl:(NSString *)url param:(NSMutableDictionary *)param progress:(HTTPRequestProgressBlock)progress success:(HTTPRequestSuccessBlock)success faliure:(HTTPRequestFaliureBlock)faliure;

/*
 @method deleteWithUrl:param:progress:success:failure:
 @abstrac 发起delete请求
 @discussion 发起delete请求
 @param url
 @param param 参数
 @param progress 进度（可传nil）
 @param success 成功回调
 @param faliure 失败回调
 @result void
 */
+ (void)deleteWithUrl:(NSString *)url param:(NSMutableDictionary *)param progress:(HTTPRequestProgressBlock)progress success:(HTTPRequestSuccessBlock)success faliure:(HTTPRequestFaliureBlock)faliure;


@end
