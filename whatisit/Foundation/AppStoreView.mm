//
//  CreditsLayer.m
//  Escape123
//
//  Created by Abhishek Mishra on 9/19/12.
//
//

#import "AppStoreView.h"

@implementation AppStoreView

-(id) init{
	self = [super init];
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        NSLog(@"No internet connection!");
    } else {
        if ([GameIAPHelper sharedHelper].products == nil) { //check
            
            [[GameIAPHelper sharedHelper] requestProducts];
            //self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //_hud.labelText = @"Loading comics...";
            [self performSelector:@selector(timeout:) withObject:nil afterDelay:30.0];
            
        }
        else {
            [self setupStoreView];
        }
    }
    
	return self;
}

- (void)timeout:(id)arg {
    
    int i =10;
    i++;
    //[self setupStoreView];
    //_hud.labelText = @"Timeout!";
    //_hud.detailsLabelText = @"Please try again later.";
    //_hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.jpg"]] autorelease];
	//_hud.mode = MBProgressHUDModeCustomView;
    // [self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:3.0];
    
}
-(void)setupStoreView {
//    [self removeAllChildrenWithCleanup:YES];
//    
//    CCParallaxNode *intro1 = [CCParallaxNode node];
//    CCSpriteBatchNode * defaultnode = [CCSpriteBatchNode batchNodeWithFile:@"Default.pvr.ccz"]; // 1
//    //[self addChild:defaultnode z:1]; // 2
//    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Default.plist"]; // 3
//    CCSprite *introSprite = [CCSprite spriteWithSpriteFrameName:@"Default.png"];
//    
//    [intro1 addChild:introSprite z:0 parallaxRatio:ccp(0.1, 0.1) positionOffset:ccp([CCDirector sharedDirector].winSize.width/2,
//                                                                                [CCDirector sharedDirector].winSize.height/2)];
//    //_intro1.position = ccp(220,345);
//    [self addChild:intro1 z: -1];
    
    //init with a different image (bought image)
//    CCMenuItemImage *stars1000  = [CCMenuItemImage
//                                    itemFromNormalImage:@"turbobought.png"
//                                    selectedImage:@"turbobought.png"
//                                    target:self
//                                    selector:@selector(onMenu:)];
    
    //CCMenuItemFont *stars1000 = [CCMenuItemFont itemFromString:@"Turbo charge bought" target:self selector: @selector(onMenu:)];
	//CCMenuItemFont *credits;
    //CCMenuItemFont *store;
    
	CCLabelTTF *buy = nil;
    NSString *formattedString = @"";
    for (SKProduct *product in [GameIAPHelper sharedHelper].products){
    
        NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:product.priceLocale];
        formattedString = [numberFormatter stringFromNumber:product.price];
    
    //cell.textLabel.text = product.localizedTitle;
    //cell.detailTextLabel.text = formattedString;
    
        if ([[GameIAPHelper sharedHelper].purchasedProducts containsObject:product.productIdentifier]) {
            //CCMenuItemFont *menuButton = [CCMenuItemFont itemFromString:@"Menu" target:self selector: @selector(onMenu:)];
            //cell.accessoryType = UITableViewCellAccessoryCheckmark;
            //cell.accessoryView = nil;
        } else {
            NSString * text = @"Buy ";
            text = [text stringByAppendingString:product.localizedTitle];
            
//            stars1000  = [CCMenuItemImage
//                                           itemFromNormalImage:@"buyturbo.png"
//                                           selectedImage:@"buyturbo.png"
//                                           target:self
//                                           selector:@selector(buyButtonClicked:)];
            
            buy = [CCLabelTTF labelWithString:formattedString fontName:@"Marker Felt" fontSize:50];
            buy.color = ccRED;
            [buy setOpacity:150];
            //[stars1000 addChild:buy];
            //stars1000 = [CCMenuItemFont itemFromString:text target:self selector: @selector(buyButtonClicked:)];
            //stars1000.tag = ;
     }
    }
    
    //stars1000.color = ccc3(255,0,0);
    
    // Default font size will be 22 points.
//	[CCMenuItemFont setFontSize:44];
//	
//    // Reset Button
//	CCMenuItemLabel *play = [CCMenuItemFont itemWithString:@"buy" block:^(id sender){
//        [self.delegate buyButtonClicked: self];
//	}];
//    
//    CCMenu *menu = [CCMenu menuWithItems:buy, nil];
//    
//	[menu alignItemsVertically];
//	
//	CGSize size = [[CCDirector sharedDirector] winSize];
//	[menu setPosition:ccp( size.width/2, size.height/2)];
//	
//	
//	[self addChild: menu z:-1];
    
//    CCMenuItemImage *menuButton  = [CCMenuItemImage
//             itemFromNormalImage:@"home.png"
//             selectedImage:@"home.png"
//             target:self
//             selector:@selector(onMenu:)];
//    
//    CCMenu *menu = [CCMenu menuWithItems:stars1000,menuButton, nil];
//    menu.position = ccp([CCDirector sharedDirector].winSize.width/2,
//                        [CCDirector sharedDirector].winSize.height/2);
//	[menu alignItemsVerticallyWithPadding: 20.0f];
//	[self addChild:menu z: 2];
//    
//    if(buy !=nil) {
//        buy.position = ccp(menu.position.x + stars1000.contentSize.width/3, menu.position.y + stars1000.contentSize.height/3);
//        [self addChild:buy z:3];
//    }
    
}

- (void)onMenu:(id)sender{
    //[SceneManager goMenu];
}


@end
