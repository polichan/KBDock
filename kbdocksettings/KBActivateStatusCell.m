#import "KBActivateStatusCell.h"
#import "../Manager/DLicenseManager.h"

#define PREFERENCE_BUNDLE_PATH  @"/Library/PreferenceBundles/retimesettings.bundle"
static NSString *trialerLicensePath = @"/var/mobile/Library/nactro/trial/com.nactro.kbdock.dat";
static NSString *licensePath = @"/var/mobile/Library/nactro/com.nactro.kbdock.dat";
static NSString *bundleName = @"com.nactro.kbdock";
static NSString *publicKey = @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAptsM8G+m3huFQMYqFkV6Ky5TiGqCjE6G3oL9/XSTAkCyQcVQFry17sN5u2s/7YZq0hZZmDpwXE16y2+feUMz4UI9BuS1zr9IiSqoDRKln3amekA7VLfuwuY6ptEJDqRfl114iLvkfXmArThPS7L1G43fFX5HhsblXF6SrQNHr4HHUMlSaGFBW0s5MYK1hLynV/lkn7heE87BEW13D3XwhVhHTNboZ9tABpStMbTHRUxB1Mjb79TjB0qFUvC7VP57Rd5DzO++GQwdAniKYTisJ5ZPoN9yY7dGoSWhYBz3Te7dlcCNzzSVXDrAvjvXNdkuZvf2iA8FS85QTl3IKIoHLQIDAQAB";

@interface KBActivateStatusCell  ()

@end

@implementation KBActivateStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];
  if (self) {
    [self layoutSubviews];
    [self parseSpecifiers:specifier];
    [self verifyLicense];
  }
  return self;
}

- (void)layoutSubviews{
  [super layoutSubviews];
  self.accessoryView = self.activateStatusLabel;
  [self.contentView addSubview:self.activateStatusLabel];
}

- (void)verifyLicense{

  NSFileManager *fileManager = [NSFileManager defaultManager];
  if([fileManager fileExistsAtPath:trialerLicensePath]){  // 首先判断有没有试用文件
    // 如果存在，就验证文件
    BOOL trial = [DLicenseManager verifyTrailerLicenseFromPath:trialerLicensePath publicKey:publicKey bundleName:bundleName];
    if (trial) {
      self.textLabel.text = @"已激活（试用模式）";
    }
  }else if([fileManager fileExistsAtPath:licensePath]){ //判断正式激活文件是否存在
    // 存在则验证
    BOOL result = [DLicenseManager verifyLicenseFromPath:licensePath publicKey:publicKey bundleName:bundleName];
    if (result) {
      self.textLabel.text = @"已激活（正式购买）";
    }
  }else if([fileManager fileExistsAtPath:licensePath] && [fileManager fileExistsAtPath:trialerLicensePath]){ // 同时存在有先判断正式激活文件
    BOOL result = [DLicenseManager verifyLicenseFromPath:licensePath publicKey:publicKey bundleName:bundleName];
    if (result) {
      self.textLabel.text = @"已激活（正式购买）";
    }
}else{
  self.textLabel.text = @"未激活";
}
}

- (void)setActivateStatus:(NSString *)activateStatus{
  self.activateStatusLabel.text = activateStatus;
}

- (instancetype)initWithSpecifier:(PSSpecifier *)specifier {
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KBActivateCell" specifier:specifier];
    return self;
}

- (void)parseSpecifiers:(PSSpecifier *)specifier {
    NSDictionary *properties = specifier.properties;
    if(properties[@"activateStatus"]) {
      [self setActivateStatus:properties[@"activateStatus"]];
    }
  }

#pragma mark - lazyload
- (UILabel *)activateStatusLabel{
  if (!_activateStatusLabel) {
    _activateStatusLabel = [[UILabel alloc]init];
  }
  return _activateStatusLabel;
}
@end
