//
//  AppStoreController.m
//  clearway
//
//  Created by Abhishek Mishra on 7/7/13.
//
//

#import "AppStoreController.h"

@implementation AppStoreController


-(id)initWitAppStoreView
{
    if(self = [super init])
    {
        _AppStoreView = [[AppStoreView alloc] init]; //need to release in dealloc
        [self addChild:_AppStoreView];
        
        //_AppStoreView.delegate = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchaseFailed:) name:kProductPurchaseFailedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
    }
    return self;
}

#pragma mark -
#pragma mark Memory management

- (void)buyButtonClicked:(id)sender {
    
	NSLog(@"Buy Button Clicked");
	CCMenuItemFont *button = (CCMenuItemFont *) sender;
	
    SKProduct *product = [[GameIAPHelper sharedHelper].products objectAtIndex:0];
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[GameIAPHelper sharedHelper] buyProductIdentifier:product.productIdentifier];
    
    //self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSLog(@"Buying 1000 stars...");
    [self performSelector:@selector(timeout:) withObject:nil afterDelay:60*5];
    
}


- (void)buyButtonTapped:(id)sender {
    
	NSLog(@"Buy Button Clicked");
	CCMenuItemFont *button = (CCMenuItemFont *) sender;
	
    SKProduct *product = [[GameIAPHelper sharedHelper].products objectAtIndex:button.tag];
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[GameIAPHelper sharedHelper] buyProductIdentifier:product.productIdentifier];
    
    //self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSLog(@"Buying 1000 stars...");
    [self performSelector:@selector(timeout:) withObject:nil afterDelay:60*5];
    
}

- (void)productPurchased:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //[MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    NSString *productIdentifier = (NSString *) notification.object;
    NSLog(@"Purchased: %@", productIdentifier);
    
    //[self setupStoreView];
    
    //[self.tableView reloadData];
    
}

- (void)productPurchaseFailed:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //[MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    SKPaymentTransaction * transaction = (SKPaymentTransaction *) notification.object;
    if (transaction.error.code != SKErrorPaymentCancelled) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error!"
                                                         message:transaction.error.localizedDescription
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"OK", nil] autorelease];
        
        [alert show];
    }
    
}

- (void)productsLoaded:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [_AppStoreView setupStoreView];
    //[self setupStoreView];
    // [MBProgressHUD hideHUDForView:self.view animated:YES];
    //self.tableView.hidden = FALSE;
    
    //[self.tableView reloadData];
    
}

- (void)timeout:(id)arg {
    
    //[self setupStoreView];
    //_hud.labelText = @"Timeout!";
    //_hud.detailsLabelText = @"Please try again later.";
    //_hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.jpg"]] autorelease];
	//_hud.mode = MBProgressHUDModeCustomView;
    // [self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:3.0];
    
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
