//
//  OverlayMenu.h
//  clearway
//
//  Created by Abhishek Mishra on 6/22/13.
//
//

#import "cocos2d.h"
#import "ApplicationConstants.h"

@protocol OverlayMenuDelegate <NSObject>

-(void) didPressResume :(id)sender;
-(void) didPressRestart:(id)sender;
-(void) didPressAppStore:(id)sender;
-(void) didPressMenuFromOverlayMenu: (id)sender;

@end

@interface OverlayMenu : CCLayer

-(void) createOverlayMenu;
-(void) hideOverlayMenu;

@property (nonatomic,assign) id<OverlayMenuDelegate> delegate;

@end
