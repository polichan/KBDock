@interface UIKeyboardDockItem : NSObject{
  UIImage *_image;
}
@property (nonatomic,retain) UIImage * image;
+(id)_standardGlyphColor;
+(id)_darkStyleGlyphColor;
-(id)initWithImageName:(id)arg1 identifier:(id)arg2;
@end

@class KBDockCollectionView;
@interface UIKeyboardDockView : UIView{
  UIKeyboardDockItem* _rightDockItem;
}
@property (retain, nonatomic) UIButton *clipBoardBtn;
@property (retain, nonatomic) KBDockCollectionView *appDock;
@property (nonatomic,retain) UIKeyboardDockItem *rightDockItem;
@end

@interface UISystemKeyboardDockController : UIViewController{
  UIKeyboardDockItem * _dictationDockItem;
}
@property (nonatomic,retain) UIKeyboardDockView * dockView;
-(void)dictationItemButtonWasPressed:(id)arg1 withEvent:(id)arg2;
@end


@interface UIKeyboardMenuView : UIView
-(id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2;
@end


@interface UIInputSwitcherTableCellBackgroundView : UIView {
	BOOL _selected;
	BOOL _drawsOpaque;
	BOOL _drawsBorder;
	BOOL _usesDarkTheme;
	int _roundedCorners;
}
@end

@interface UIInputSwitcherTableCell : UITableViewCell
- (id)initWithStyle:(long long)arg1 reuseIdentifier:(id)arg2;
@property (nonatomic,retain) UIInputSwitcherTableCellBackgroundView * backgroundView;
@end

@interface UITableViewCellContentView : UIView
@property (copy,readonly) NSString * description;
@end

@interface UIInputSwitcherTableView : UITableView
-(void)selectRowAtIndexPath:(id)arg1 animated:(BOOL)arg2 scrollPosition:(long long)arg3;
@end

@interface UIInputSwitcherView : UIKeyboardMenuView
+ (UIInputSwitcherView *)sharedInstance;
+ (UIInputSwitcherView *)activeInstance;
- (void)setInputMode:(NSString *)identifer;
- (void)customizeCell:(id)arg1 forItemAtIndex:(unsigned long long)arg2 ;
- (void)_reloadInputSwitcherItems;
@end


@interface UIPasteboard : NSObject
@property (nonatomic,copy) NSArray * items;
@property (nonatomic,readonly) long long numberOfItems;
-(void)addItems:(id)arg1;
-(void)setString:(NSString *)arg1;
@end
