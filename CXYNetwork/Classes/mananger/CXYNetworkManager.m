//
//  CXYNetworkManager.m
//  CXYNetwork_Example
//
//  Created by Avalanching on 2019/5/16.
//  Copyright © 2019 avanlanching. All rights reserved.
//

#import "CXYNetworkManager.h"

#define weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; \
_Pragma("clang diagnostic pop")

#define strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __weak_##x##__; \
_Pragma("clang diagnostic pop")


// 关键字符串安全策略
#define STRNG_ENCRYPT_KEY 9

static NSString *const client() {
    unsigned char key[] = {
        (STRNG_ENCRYPT_KEY ^ 'k'), (STRNG_ENCRYPT_KEY ^ 'j'), (STRNG_ENCRYPT_KEY ^ 'e'), (STRNG_ENCRYPT_KEY ^ '6'), (STRNG_ENCRYPT_KEY ^ '5'), (STRNG_ENCRYPT_KEY ^ '0'), (STRNG_ENCRYPT_KEY ^ '9'), (STRNG_ENCRYPT_KEY ^ '1'), (STRNG_ENCRYPT_KEY ^ '8'), (STRNG_ENCRYPT_KEY ^ '2'), (STRNG_ENCRYPT_KEY ^ 'a'), (STRNG_ENCRYPT_KEY ^ '2'), (STRNG_ENCRYPT_KEY ^ '3'), (STRNG_ENCRYPT_KEY ^ 'b'), (STRNG_ENCRYPT_KEY ^ '2'), (STRNG_ENCRYPT_KEY ^ '4'), (STRNG_ENCRYPT_KEY ^ 'c'), (STRNG_ENCRYPT_KEY ^ '2'), (STRNG_ENCRYPT_KEY ^ '0'), (STRNG_ENCRYPT_KEY ^ 'r'), (STRNG_ENCRYPT_KEY ^ 'r'), (STRNG_ENCRYPT_KEY ^ 'r')
    };
    unsigned char * p = key;
    while (((*p) ^= STRNG_ENCRYPT_KEY != '\0')) {
        p++;
    }
    return [NSString stringWithUTF8String:(const char *)key];
}

static NSString *const suffixP12() {
    unsigned char key[] = {
        (STRNG_ENCRYPT_KEY ^ 'p'), (STRNG_ENCRYPT_KEY ^ '1'), (STRNG_ENCRYPT_KEY ^ '2')
    };
    unsigned char * p = key;
    while (((*p) ^= STRNG_ENCRYPT_KEY != '\0')) {
        p++;
    }
    return [NSString stringWithUTF8String:(const char *)key];
}

static NSString *const clientPassword() {
    unsigned char key[] = {
        (STRNG_ENCRYPT_KEY ^ 'p'), (STRNG_ENCRYPT_KEY ^ '1'), (STRNG_ENCRYPT_KEY ^ '2')
    };
    unsigned char * p = key;
    while (((*p) ^= STRNG_ENCRYPT_KEY != '\0')) {
        p++;
    }
    return [NSString stringWithUTF8String:(const char *)key];
}

@implementation CXYNetworkManager

#pragma mark - public method

// get请求
+ (void)getWithUrl:(NSString *)url progress:(HTTPRequestProgressBlock)progress success:(HTTPRequestSuccessBlock)success faliure:(HTTPRequestFaliureBlock)faliure {

    [[self configureSessionManager] GET:url parameters:nil progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self serverResponseClientWithObject:responseObject success:success faliure:faliure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self serverDissResponseClientWithError:error failure:faliure];
    }];
}

// put请求
+ (void)putWithUrl:(NSString *)url param:(NSMutableDictionary *)param success:(HTTPRequestSuccessBlock)success faliure:(HTTPRequestFaliureBlock)faliure {
    [[self configureSessionManager] PUT:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self serverResponseClientWithObject:responseObject success:success faliure:faliure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self serverDissResponseClientWithError:error failure:faliure];
    }];
}

// post请求
+ (void)postWithUrl:(NSString *)url param:(NSMutableDictionary *)param progress:(HTTPRequestProgressBlock)progress success:(HTTPRequestSuccessBlock)success faliure:(HTTPRequestFaliureBlock)faliure {
    
    if (!param) {
        param = @{}.mutableCopy;
    }
    
    [[self configureSessionManager] POST:url parameters:param progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self serverResponseClientWithObject:responseObject success:success faliure:faliure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self serverDissResponseClientWithError:error failure:faliure];
    }];
}

// delete请求
+ (void)deleteWithUrl:(NSString *)url param:(NSMutableDictionary *)param progress:(HTTPRequestProgressBlock)progress success:(HTTPRequestSuccessBlock)success faliure:(HTTPRequestFaliureBlock)faliure {
    
    [[self configureSessionManager] DELETE:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self serverResponseClientWithObject:responseObject success:success faliure:faliure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self serverDissResponseClientWithError:error failure:faliure];
    }];
}

#pragma mark - private method

+ (void)networkReachabilityComplete:(void(^)(AFNetworkReachabilityStatus status))complete faliure:(HTTPRequestFaliureBlock)faliure {

}

+ (void)serverResponseClientWithObject:(id)object success:(HTTPRequestSuccessBlock)success faliure:(HTTPRequestFaliureBlock)faliure {
    NSError *error = nil;
    id temp = [NSJSONSerialization JSONObjectWithData:object options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        if (faliure) {
            faliure(error);
        }
        return;
    } else {
        success(temp);
    }
}

+ (void)serverDissResponseClientWithError:(NSError *)error failure:(HTTPRequestFaliureBlock)failure {
    if (failure) {
        failure(error);
    }
}

#pragma mark - verification method

// 设置请求相关参数
+ (AFHTTPSessionManager *)configureSessionManager {
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO//如果是需要验证自建证书，需要设置为YES
        securityPolicy.allowInvalidCertificates = YES;
        //validatesDomainName 是否需要验证域名，默认为YES;这里使用NO，否则无法请求数据
        securityPolicy.validatesDomainName = NO;
        sessionManager.securityPolicy = securityPolicy;
        sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [sessionManager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
        sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        sessionManager.requestSerializer.timeoutInterval = 30;
        sessionManager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
        [sessionManager.requestSerializer setValue:@"gzip,deflate,sdch" forHTTPHeaderField:@"Accept-Encoding"];
        sessionManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        [sessionManager setSessionDidBecomeInvalidBlock:^(NSURLSession * _Nonnull session, NSError * _Nonnull error) {
            NSLog(@"setSessionDidBecomeInvalidBlock");
        }];
        
        __weak typeof(self)weakSelf = self;
        @weakify(sessionManager);
        [sessionManager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession*session, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing*_credential) {
            @strongify(sessionManager);
            NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
            __autoreleasing NSURLCredential *credential = nil;
            if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
                if([sessionManager.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
                    credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                    if(credential) {
                        disposition =NSURLSessionAuthChallengeUseCredential;
                    } else {
                        disposition =NSURLSessionAuthChallengePerformDefaultHandling;
                    }
                } else {
                    disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
                }
            } else {
                // client authentication
                SecIdentityRef identity = NULL;
                SecTrustRef trust = NULL;
                NSString *p12 = [[NSBundle mainBundle] pathForResource:client() ofType:suffixP12()];
                NSFileManager *fileManager =[NSFileManager defaultManager];
                if(![fileManager fileExistsAtPath:p12]) {
                    NSLog(@"client.p12:not exist");
                } else {
                    NSData *PKCS12Data = [NSData dataWithContentsOfFile:p12];
                    
                    if ([[weakSelf class] extractIdentity:&identity andTrust:&trust fromPKCS12Data:PKCS12Data]) {
                        
                        SecCertificateRef certificate = NULL;
                        SecIdentityCopyCertificate(identity, &certificate);
                        const void*certs[] = {certificate};
                        CFArrayRef certArray = CFArrayCreate(kCFAllocatorDefault, certs,1,NULL);
                        credential = [NSURLCredential credentialWithIdentity:identity certificates:(__bridge  NSArray*)certArray persistence:NSURLCredentialPersistencePermanent];
                        disposition = NSURLSessionAuthChallengeUseCredential;
                    }
                }
            }
            *_credential = credential;
            return disposition;
        }];
    });
    return sessionManager;
}

+ (BOOL)extractIdentity:(SecIdentityRef*)outIdentity andTrust:(SecTrustRef *)outTrust fromPKCS12Data:(NSData *)inPKCS12Data {
    OSStatus securityError = errSecSuccess;
    //client certificate password
    NSDictionary*optionsDictionary = [NSDictionary dictionaryWithObject:clientPassword() forKey:(__bridge id)kSecImportExportPassphrase];
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import((__bridge CFDataRef)inPKCS12Data,(__bridge CFDictionaryRef)optionsDictionary,&items);
    
    if(securityError == 0) {
        CFDictionaryRef myIdentityAndTrust =CFArrayGetValueAtIndex(items,0);
        const void*tempIdentity =NULL;
        tempIdentity= CFDictionaryGetValue (myIdentityAndTrust,kSecImportItemIdentity);
        *outIdentity = (SecIdentityRef)tempIdentity;
        const void*tempTrust =NULL;
        tempTrust = CFDictionaryGetValue(myIdentityAndTrust,kSecImportItemTrust);
        *outTrust = (SecTrustRef)tempTrust;
    } else {
        return NO;
    }
    return YES;
}

@end
