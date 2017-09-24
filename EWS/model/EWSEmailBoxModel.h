
#import <Foundation/Foundation.h>

@interface EWSEmailBoxModel : NSObject

/*
 * 邮箱用户名
 */
@property (nonatomic, strong) NSString *emailAddress;

/*
 * 邮箱密码
 */
@property (nonatomic, strong) NSString *password;

/*
 * 邮箱API地址
 */
@property (nonatomic, strong) NSString *ewsUrl;
@property (nonatomic, strong) NSString *mailServerAddress;
@property (nonatomic, strong) NSString *domain;

-(instancetype)initWith:(NSString*)email andPassword:(NSString*)password;

@end
