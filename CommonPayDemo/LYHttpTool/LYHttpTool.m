//
//  LYHttpTool.m
//  WDLY
//
//  Created by wsk on 2016/12/15.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "LYHttpTool.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#define MAIN_HOST @"后台的主链接"

@implementation LYHttpTool
+ (void)initialize {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}
+ (BOOL)reachable {
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable;
}
+ (BOOL)reachableWWAN {
    return [[AFNetworkReachabilityManager sharedManager] isReachableViaWWAN];
}
+ (BOOL)reachableWifi {
    return [[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi];
}
+ (BOOL)reachNoNet {
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable;
}
//将主链接封装进去
+ (void)requestDateWithUrlString:(NSString *)urlString params:(id)params showAllResponse:(BOOL)showAll success:(void (^)(id))success failure:(void (^)(NSString *))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@",MAIN_HOST,urlString];
    [self POST:url params:params showAllResponse:showAll success:success failure:failure];
}


+ (void)GET:(NSString *)URLString params:(id)params success:(void (^)(id))success failure:(void (^)(NSString *))failure {
    [self Method:@"GET" URLString:URLString params:params showAllResponse:NO bodyBlock:nil progress:nil success:success failure:failure];
}
+ (void)PUT:(NSString *)URLString params:(id)params success:(void (^)(id responseObject))success failure:(void (^)(NSString *errorMsg))failure {
    [self Method:@"PUT" URLString:URLString params:params showAllResponse:NO bodyBlock:nil progress:nil success:success failure:failure];
}
+ (void)DELETE:(NSString *)URLString params:(id)params success:(void (^)(id responseObject))success failure:(void (^)(NSString *errorMsg))failure {
    [self Method:@"DELETE" URLString:URLString params:params showAllResponse:NO bodyBlock:nil progress:nil success:success failure:failure];
}
+ (void)POST:(NSString *)URLString params:(id)params showAllResponse:(BOOL)showAll success:(void (^)(id))success failure:(void (^)(NSString *))failure {
    [self POST:URLString params:params showAllResponse:showAll bodyBlock:nil success:success failure:failure];
}
+ (void)POST:(NSString *)URLString params:(id)params showAllResponse:(BOOL)showAll bodyBlock:(void (^)(id<AFMultipartFormData>))block success:(void (^)(id))success failure:(void (^)(NSString *))failure {
//    [self POST:URLString params:params bodyBlock:block progress:nil success:success failure:failure];
    [self POST:URLString params:params showAllResponse:showAll bodyBlock:block progress:nil success:success failure:failure];
}
+ (void)POST:(NSString *)URLString params:(id)params showAllResponse:(BOOL)showAll bodyBlock:(void (^)(id<AFMultipartFormData>))block progress:(void (^)(NSProgress *))progress success:(void (^)(id))success failure:(void (^)(NSString *))failure {
    [self Method:@"POST" URLString:URLString params:params showAllResponse:showAll bodyBlock:block progress:progress success:success failure:failure];
}
+ (void)Method:(NSString *)method URLString:(NSString *)URLString params:(id)params showAllResponse:(BOOL)showAll bodyBlock:(void (^)(id<AFMultipartFormData>))block progress:(void (^)(NSProgress *))progress success:(void (^)(id))success failure:(void (^)(NSString *))failure {
//    [self Method:method URLString:URLString params:params verifyToken:YES bodyBlock:block progress:progress success:success failure:failure];
    [self Method:method URLString:URLString params:params showAllResponse:showAll verifyToken:YES bodyBlock:block progress:progress success:success failure:failure];
}

+ (void)Method:(NSString *)method URLString:(NSString *)URLString params:(id)params showAllResponse:(BOOL)showAll verifyToken:(BOOL)verifyToken bodyBlock:(void (^)(id<AFMultipartFormData>))block progress:(void (^)(NSProgress *))progress success:(void (^)(id))success failure:(void (^)(NSString *))failure
{
    params = [self preHandleParams:params];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    AFHTTPSessionManager *manager = [self sectionManager];
    //解决3084错误
    AFSecurityPolicy *secur = [[AFSecurityPolicy alloc] init];
    [secur setAllowInvalidCertificates:YES];
    [manager setSecurityPolicy:secur];
    
    AFJSONResponseSerializer *jsonSerializer=[AFJSONResponseSerializer serializer];
    jsonSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript", nil];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    manager.requestSerializer.timeoutInterval = manager.requestSerializer.timeoutInterval ?: LYHttpToolTimeOutInterval;
    void (^successBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) = ^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        NSLog(@"%@ ==> %@ %@ \r\n%@", method, task.originalRequest.URL, params, responseObject);
        [self responseHandle:responseObject method:method URLString:URLString params:params showAllResponse:showAll verifyToken:verifyToken bodyBlock:block progress:progress success:success failure:failure];
    };
    void (^failureBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        NSLog(@"网络请求超时:%@ %@[params:%@] %@", task.originalRequest.URL, method, params, error);
        if (failure) {
            failure(@"网络请求超时");
        }
    };
    if ([method isEqualToString:@"GET"]) {
        [manager GET:URLString parameters:params progress:progress success:successBlock failure:failureBlock];
    }
    else if ([method isEqualToString:@"PUT"]) {
        [manager PUT:URLString parameters:params success:successBlock failure:failureBlock];
    }
    else if ([method isEqualToString:@"DELETE"]) {
        [manager DELETE:URLString parameters:params success:successBlock failure:failureBlock];
    }
    else if ([method isEqualToString:@"POST"] && !block) {
        [manager POST:URLString parameters:params progress:progress success:successBlock failure:failureBlock];
    }
    else if ([method isEqualToString:@"POST"] && block) {
        [manager POST:URLString parameters:params constructingBodyWithBlock:block progress:progress success:successBlock failure:failureBlock];
    }
}

+ (void)responseHandle:(id)responseObject method:(NSString *)method URLString:(NSString *)URLString params:(id)params showAllResponse:(BOOL)showAll verifyToken:(BOOL)verifyToken bodyBlock:(void (^)(id<AFMultipartFormData>))block progress:(void (^)(NSProgress *))progress success:(void (^)(id))success failure:(void (^)(NSString *))failure {
    if (success) {
        NSError *err1;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err1];
        NSString *errorCede = dic[@"Error"];
//        NSString *errorCede = [responseObject valueForKey:@"Error"];
        NSInteger err = [errorCede integerValue];
        if (err == 1002) {
#pragma warning  -- 我们后台的,你们一般不需要,不用管
//            [AccessToken token].overdue = YES;
//            ACCESS_TOKEN;
        }else {
            if (showAll) {
//                success(responseObject);
                success(dic);

            }else {
//                success([responseObject valueForKey:@"Result"]);
                success(dic[@"Result"]);
                NSLog(@"%@=-=-=-=-=-=-=-",dic);
               
            }
        }
    }else {
//        [MBProgressHUD showMessage:[responseObject valueForKey:@"Message"] toView:[UIApplication sharedApplication].keyWindow hideAfterDelay:1];
    }
}
+ (id)preHandleParams:(id)params {
    return params;
}
+ (AFHTTPSessionManager *)sectionManager {
    return [[AFHTTPSessionManager alloc] init];
}



@end
