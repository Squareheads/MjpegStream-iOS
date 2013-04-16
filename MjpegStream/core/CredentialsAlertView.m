//
//  CredentialsAlertView.m
//  MjpegImageView
//
//  Created by Matthew Eagar on 10/3/11.
//  Copyright 2011 ThinkFlood Inc. All rights reserved.
//
//  Modified by Raman Fedaseyeu on 4/13/13.
//  Copyright 2013 Raman Fedaseyeu. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is furnished
// to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "CredentialsAlertView.h"


#define ALERT_HEIGHT 200.0
#define ALERT_Y_POSITION 55.0
#define BUTTON_MARGIN 15.0
#define TEXT_FIELD_MARGIN 5.0


@implementation CredentialsAlertView

@dynamic username;
@dynamic password;
@synthesize credentialDelegate = _credentialDelegate;

- (id)initWithDelegate:(id<CredentialsAlertDelegate>)delegate forHost:(NSString *)hostName {
	self = [super initWithTitle:NSLocalizedString(@"CredentialAlertTitle", @"") 
	                    message:hostName 
	                   delegate:self 
	          cancelButtonTitle:NSLocalizedString(@"CancelButtonTitle", @"") 
	          otherButtonTitles:NSLocalizedString(@"LoginButtonTitle", @""), 
	                            nil];

	if (self) {
		_credentialDelegate = delegate;
		
		_usernameField = [[UITextField alloc] initWithFrame:CGRectZero];
		_usernameField.borderStyle = UITextBorderStyleBezel;
		_usernameField.backgroundColor = [UIColor whiteColor];
		_usernameField.placeholder = NSLocalizedString(@"UsernamePlaceholderText", @"");
		_usernameField.delegate = self;
		_usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
		_usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		_usernameField.returnKeyType = UIReturnKeyNext;
		_usernameField.clearButtonMode = UITextFieldViewModeUnlessEditing;
		[self addSubview:_usernameField];
		
		_passwordField = [[UITextField alloc] initWithFrame:CGRectZero];
		_passwordField.secureTextEntry = YES;
		_passwordField.borderStyle = UITextBorderStyleBezel;
		_passwordField.backgroundColor = [UIColor whiteColor];
		_passwordField.placeholder = NSLocalizedString(@"PasswordPlaceholderText", @"");
		_passwordField.delegate = self;
		_passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
		_passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		_passwordField.returnKeyType = UIReturnKeyDone;
		_passwordField.clearButtonMode = UITextFieldViewModeUnlessEditing;
		[self addSubview:_passwordField];
	}
	
	return self;
}

- (NSString *)username {
	return _usernameField.text;
}

- (void)setUsername:(NSString *)username {
	_usernameField.text = username;
}

- (NSString *)password {
	return _passwordField.text;
}

- (void)setPassword:(NSString *)password {
	_passwordField.text = password;
}

- (void)setFrame:(CGRect)frame {
	frame.size.height = ALERT_HEIGHT;
	frame.origin.y = ALERT_Y_POSITION;
	[super setFrame:frame];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	NSString *username = _usernameField.text;
	_usernameField.text = @"a";
	CGSize textFieldSize = [_usernameField sizeThatFits:CGSizeZero];
	_usernameField.text = username;

	UILabel *titleLabel = nil;
	UILabel *messageLabel = nil;
	NSMutableArray *buttonViews = [NSMutableArray arrayWithCapacity:3];
	
	for (UIView *subview in self.subviews) {
		if (subview == _usernameField ||
			subview == _passwordField) {
			// continue
		} else if ([subview isKindOfClass:[UILabel class]]) {
			if (titleLabel == nil) {
				titleLabel = (UILabel *)subview;
			} else if (titleLabel.frame.origin.y > subview.frame.origin.y) {
				messageLabel = titleLabel;
				titleLabel = (UILabel *)subview;
			} else {
				messageLabel = (UILabel *)subview;
			}
		} else if ([subview isKindOfClass:[UIImageView class]]) {
			// continue
		} else if ([subview isKindOfClass:[UITextField class]]) {
			// continue
		} else {
			[buttonViews addObject:subview];
		} 
	}
	
	CGFloat buttonViewTop = 0.0;
	for (UIView *buttonView in buttonViews) {
		CGRect buttonViewFrame = buttonView.frame;
		buttonViewFrame.origin.y = 
		self.bounds.size.height - buttonViewFrame.size.height - BUTTON_MARGIN;
		buttonView.frame = buttonViewFrame;
		buttonViewTop = CGRectGetMinY(buttonViewFrame);
	}
	
	CGRect labelFrame = messageLabel.frame;
	CGRect textFieldFrame = CGRectMake(labelFrame.origin.x, 
	                                   labelFrame.origin.y + labelFrame.size.height + TEXT_FIELD_MARGIN, 
	                                   labelFrame.size.width, 
	                                   textFieldSize.height);
	_usernameField.frame = textFieldFrame;
	[self bringSubviewToFront:_usernameField];
	
	textFieldFrame.origin.y += textFieldFrame.size.height + TEXT_FIELD_MARGIN;
	_passwordField.frame = textFieldFrame;
	[self bringSubviewToFront:_passwordField];
}

#pragma mark - UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == [self cancelButtonIndex]) {
		if (_credentialDelegate) {
			[_credentialDelegate credentialAlertCancelled:self];
		}
	}
	else if (_credentialDelegate) {
		[_credentialDelegate credentialAlertSaved:self];
	}
	
	[alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField.text.length > 0) {
		if (textField == _usernameField) {
			[_passwordField becomeFirstResponder];
		} else if (textField == _passwordField) {
			[textField resignFirstResponder];
		}
	}
	return NO;
}

@end
