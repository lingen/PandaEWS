
#import <Foundation/Foundation.h>

@interface EWSMailAttachmentModel : NSObject

@property (nonatomic, strong) NSString *attachmentId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSUInteger attachmentType;
@property (nonatomic, strong) NSString *contentType;
@property (nonatomic, strong) NSString *contentId;
@property (nonatomic, strong) NSString *attachmentPath;

@end
