#import <UIKit/UIKit.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>

@interface KBActivateStatusCell : PSTableCell
@property (nonatomic, strong)UILabel *activateStatusLabel;
- (void)setActivateStatus:(NSString *)activateStatus;
@end
