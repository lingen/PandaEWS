#import <Foundation/Foundation.h>

@interface EWSAutodiscover : NSObject

+(instancetype)sharedInstance;

/*
 * 根据帐号检测EWS的API地址
 */
-(void)autoDiscover:(NSString *)emailAddress
        resultBlock:(void(^)(NSString *ewsApiUrl, NSError *error))resultBlock;

@end
