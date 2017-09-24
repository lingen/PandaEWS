
#import <Foundation/Foundation.h>
#import "EWSMailAttachmentModel.h"

@interface EWSMailAttachment : NSObject

+(instancetype)sharedInstance;

-(void)getAttachmentWithEWSUrl:(NSString *)url
                attachmentInfo:(EWSMailAttachmentModel *)attachmentInfo
                      complete:(void (^)())completeBlock;

@end
