
#import <Foundation/Foundation.h>

@interface EWSInboxList : NSObject

+(instancetype)sharedInstance;

-(void)getInboxListWithEWSUrl:(NSString *)url
                  resultBlock:(void(^)(NSMutableArray *inboxList, NSError *error))resultBlock;

@end
