
#import <Foundation/Foundation.h>
#import "EWSInboxListModel.h"
#import "EWSItemContentModel.h"

@interface EWSItemContent : NSObject

+(instancetype)sharedInstance;

-(void)getItemContentWithEWSUrl:(NSString *)url
                           item:(EWSInboxListModel *)item
                    finishBlock:(void (^)(EWSItemContentModel *itemContentInfo, NSError *error))getItemContentBlock;

@end
