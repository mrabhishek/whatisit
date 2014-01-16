//
//  Menu.h
//  clearway
//
//  Created by Abhishek Mishra on 6/18/13.
//
//

#import "cocos2d.h"
#import "ApplicationConstants.h"

@protocol MainMenuDelegate <NSObject>

-(void) didPressPlay:(id)sender;

@end

@interface MainMenu : CCLayer
{
}


@property (nonatomic,assign)id<MainMenuDelegate> delegate;

@end
