//
//  Hud.h
//  clearway
//
//  Created by Abhishek Mishra on 6/19/13.
//
//

#import "cocos2d.h"
#import "CCLayer.h"
#import "OverlayMenu.h"

@protocol HudDelegate <NSObject>
- (void)didPressPause:(id)sender;
@end

@interface Hud : CCLayer
{
}

-(void) setupPausebutton;
-(void) hidePauseButton;

@property (nonatomic, assign)id<HudDelegate> delegate;

@end
