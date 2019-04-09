@interface UIKeyboardDockItem : NSObject{
  UIImage *_image;
}
@property (nonatomic,retain) UIImage * image;
+(id)_standardGlyphColor;
+(id)_darkStyleGlyphColor;
-(id)initWithImageName:(id)arg1 identifier:(id)arg2;
@end

@interface UISystemKeyboardDockController : UIViewController{
  UIKeyboardDockItem * _dictationDockItem;
}
-(void)dictationItemButtonWasPressed:(id)arg1 withEvent:(id)arg2;
@end

@class KBDockCollectionView;
@interface UIKeyboardDockView : UIView{
  UIKeyboardDockItem* _rightDockItem;
}
@property (retain, nonatomic) UIButton *clipBoardBtn;
@property (retain, nonatomic) KBDockCollectionView *appDock;
@property (nonatomic,retain) UIKeyboardDockItem *rightDockItem;
@end
