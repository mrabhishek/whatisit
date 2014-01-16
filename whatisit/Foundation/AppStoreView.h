//
//  AppStoreView.h
//  tutuescape n    cxz http://atlantaskateboarding.com
//
//  Created by Abhishek Mishra on 11/10/12.
//
//

#import "cocos2d.h"
#import "Reachability.h"
#import "GameIAPHelper.h"

@protocol AppStoreDelegate <NSObject>

-(void)buyButtonClicked:(id)sender;
- (void)buyButtonTapped:(id)sender;
//main me/nu
//new game

@end

@interface AppStoreView : CCLayer {
    
}

- (void)onMenu: (id)sender;
- (void)setupStoreView;

@property (nonatomic,assign)id<AppStoreDelegate> delegate;

@end
