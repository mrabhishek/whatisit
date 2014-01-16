//
//  MainMenuController.h
//  clearway
//
//  Created by Abhishek Mishra on 6/27/13.
//
//

#import "CCScene.h"
#import "MainMenu.h"

@interface MainMenuController : CCScene
{
}

@property (nonatomic,assign) MainMenu *Menu;

-(id)initWithMenu;

@end
