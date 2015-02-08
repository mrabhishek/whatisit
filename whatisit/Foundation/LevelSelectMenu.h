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

-(void) didPressLevel :(id)sender :(int) lvl;
-(void) didPressMainMenuFromLevelSelectMenu: (id)sender;

@end

@interface LevelSelectMenu : CCLayer
{
    int m_episode;
    int m_level;
}

-(void) createLevelMenu;
-(void) hideLevelMenu;
-(id) initWithEpisode:(int) episode;
-(void) setEpisode: (int) episode;
-(int) getEpisode;

@property (nonatomic,assign) id<LevelSelectMenuDelegate> delegate;

@end
