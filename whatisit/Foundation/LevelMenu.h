//
//  LevelMenu.h
//  whatisit
//
//  Created by Abhishek Mishra on 1/20/14.
//
//

#import "cocos2d.h"
#import "ApplicationConstants.h"

@protocol LevelMenuDelegate <NSObject>

-(void) didPressNextLevel :(id)sender;
-(void) didPressReplay:(id)sender;
-(void) didPressMainMenuFromLevelMenu: (id)sender;

@end

@interface LevelMenu : CCLayer

-(void) createLevelMenu;
-(void) hideLevelMenu;

@property (nonatomic,assign) id<LevelMenuDelegate> delegate;

@end