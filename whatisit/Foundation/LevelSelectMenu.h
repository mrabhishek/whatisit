//
//  LevelSelectMenu.h
//  whatisit
//
//  Created by Abhishek Mishra on 7/5/14.
//
//

#import "cocos2d.h"
#import "ApplicationConstants.h"

@protocol LevelSelectMenuDelegate <NSObject>

-(void) didPressLevel :(id)sender :(int) num;
-(void) didPressMainMenuFromLevelSelectMenu: (id)sender;

@end

@interface LevelSelectMenu : CCLayer

-(void) createLevelMenu;
-(void) hideLevelMenu;

@property (nonatomic,assign) id<LevelSelectMenuDelegate> delegate;

@end
