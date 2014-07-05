//
//  EpisodeSelectMenu.h
//  whatisit
//
//  Created by Abhishek Mishra on 7/5/14.
//
//

#import "cocos2d.h"
#import "ApplicationConstants.h"

@protocol EpisodeSelectMenuDelegate <NSObject>

-(void) didPressEpisode :(id)sender :(int) num;
-(void) didPressMainMenuFromEpisodeSelectMenu: (id)sender;

@end

@interface EpisodeSelectMenu : CCLayer

-(void) createLevelMenu;
-(void) hideLevelMenu;

@property (nonatomic,assign) id<EpisodeSelectMenuDelegate> delegate;

@end

