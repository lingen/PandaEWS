
#import "EWSEmailBoxModel.h"

@implementation EWSEmailBoxModel

-(instancetype)initWith:(NSString*)email andPassword:(NSString*)password{
    if (self = [super init]) {
        self.emailAddress = email;
        self.password = password;
    }
    return self;
}

@end
