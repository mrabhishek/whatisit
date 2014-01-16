//
//  AppStoreController.h
//  clearway
//
//  Created by Abhishek Mishra on 7/7/13.
//
//

#import "cocos2d.h"
#import "AppStoreView.h"
#import "GameIAPHelper.h"

@interface AppStoreController : CCScene
{
    
}

@property (nonatomic,assign) AppStoreView *AppStoreView;

-(id)initWitAppStoreView;

- (void)buyButtonClicked:(id)sender;
- (void)buyButtonTapped:(id)sender;

@end
