//
//  SceneController.h
//  clearway
//
//  Created by Abhishek Mishra on 6/26/13.
//
//

//controls all scenes in the games
//listens to all major menu callbacks

#import "cocos2d.h"

//local classes
#import "ApplicationConstants.h"
#import "GameController.h"
#import "MainMenuController.h"
#import "AppStoreController.h"
#import "Hud.h"
#import "OverlayMenu.h"
#import "MainMenu.h"
#import "Level.h"
#import "LevelMenu.h"
#import "LevelCompletion.h"
#import "LevelSelectMenu.h"
#import "EpisodeSelectMenu.h"

//change to inherit nsobject
@interface SceneController : NSObject<HudDelegate,OverlayMenuDelegate,MainMenuDelegate,AppStoreDelegate,LevelMenuDelegate,LevelCompletionDelegate,LevelSelectMenuDelegate,EpisodeSelectMenuDelegate>
{
    Hud * _hud;
    OverlayMenu *_overlayMenu;
    MainMenuController *_mainMenuController;
    GameController *_gameController;
    AppStoreController *_appStoreController;
    CCScene *_currentScene;
    LevelMenu *_levelMenu;
    LevelCompletion *_levelCompletion;
    CGSize m_windowSize;
    EpisodeSelectMenu *_episodeSelectMenu;
    LevelSelectMenu *_levelSelectMenu;
}

-(CCScene*) getCurrentScene;

@end
