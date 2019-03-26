#import "KBDock.h"
#import "KBDockCollectionView.h"


%hook UIKeyboardDockView
%property (retain, nonatomic) KBDockCollectionView *appDock;

- (instancetype)initWithFrame:(CGRect)frame {

  UIKeyboardDockView *dockView = %orig;
  if (dockView) {
    self.appDock = [[KBDockCollectionView alloc]init];
    self.appDock.translatesAutoresizingMaskIntoConstraints = NO;
    [dockView addSubview:self.appDock];

    [dockView addConstraint:[NSLayoutConstraint constraintWithItem:self.appDock attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:dockView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:80]]; // 60
    [dockView addConstraint:[NSLayoutConstraint constraintWithItem:self.appDock attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:dockView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-50]];
    [dockView addConstraint:[NSLayoutConstraint constraintWithItem:self.appDock attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40]];
    [dockView addConstraint:[NSLayoutConstraint constraintWithItem:self.appDock attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:dockView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-22]];
  }
  return dockView;
}
%end
