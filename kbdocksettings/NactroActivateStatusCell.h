#import <UIKit/UIKit.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>

@interface NactroActivateStatusCell : PSTableCell
@property (nonatomic, strong)UILabel *activateStatusLabel;
- (void)setActivateStatus:(NSString *)activateStatus;
@end
