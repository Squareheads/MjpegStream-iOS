//
//  CredentialsAlertView.h
//  MotionJpegImageView
//
//  Created by Raman Fedaseyeu on 4/13/13.
//  Copyright (c) 2013 ThinkFlood Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CredentialsAlertView;


@protocol CredentialsAlertDelegate <NSObject>

- (void)credentialAlertCancelled:(CredentialsAlertView *)alert;
- (void)credentialAlertSaved:(CredentialsAlertView *)alert;

@end


@interface CredentialsAlertView : UIAlertView <UITextFieldDelegate, UIAlertViewDelegate> {
@private
	UITextField *_usernameField;
	UITextField *_passwordField;
}

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, weak) id <CredentialsAlertDelegate> credentialDelegate;

- (id)initWithDelegate:(id<CredentialsAlertDelegate>)delegate forHost:(NSString *)hostName;

@end
