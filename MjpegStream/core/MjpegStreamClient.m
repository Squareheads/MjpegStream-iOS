//
//  MjpegStreamClient.m
//  MjpegStream
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

#import "MjpegStreamClient.h"


@interface MjpegStreamClient () {
	NSURLConnection *_connection;
	NSMutableData *_receivedData;
}

@end


@implementation MjpegStreamClient

+ (NSData *)EOI {
	// EOI, End Of Image marker
	// http://en.wikipedia.org/wiki/JPEG#Syntax_and_structure
	static NSData *marker = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		marker = [[NSData alloc] initWithBytes:(char[]){0xFF, 0xD9} length:2];
	});
	return marker;
}

- (id)initWithUrl:(NSURL *)url delegate:(id <MjpegStreamClientDelegate>)delegate {
	self = [super init];
	if (self) {
		_url = url;
		_delegate = delegate;
	}
	return self;
}

- (void)dealloc {
	[_connection cancel];
}

- (BOOL)isActive {
	return _connection != nil;
}

- (void)start {
	if (_connection == nil && _url) {
		_connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:_url] delegate:self];
	}
}

- (void)stop {
	[_connection cancel];
	[self cleanupConnection];
}

- (void)cleanupConnection {
	_connection = nil;
	_receivedData = nil;
}

#pragma mark - <NSURLConnectionDelegate>

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	_receivedData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[_receivedData appendData:data];
	
	NSRange endRange = [_receivedData rangeOfData:[MjpegStreamClient EOI]
	                                      options:0 
	                                        range:NSMakeRange(0, _receivedData.length)];

	NSUInteger endLocation = endRange.location + endRange.length;
	if (_receivedData.length >= endLocation) {
		NSData *imageData = [_receivedData subdataWithRange:NSMakeRange(0, endLocation)];
		UIImage *image = [UIImage imageWithData:imageData];
		if (image && [_delegate respondsToSelector:@selector(mjpegStreamClient:didReceiveImage:)]) {
			[_delegate mjpegStreamClient:self didReceiveImage:image];
		}
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[self cleanupConnection];
	if ([_delegate respondsToSelector:@selector(mjpegStreamClientDidFinishConnection:)])
		[_delegate mjpegStreamClientDidFinishConnection:self];
}

/*
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	// See for details:
	// http://developer.apple.com/library/mac/#documentation/cocoa/conceptual/urlloadingsystem/Articles/AuthenticationChallenges.html

	// TODO: Doublecheck the code and rewrite if necessary.

	BOOL allow = NO;
	if ([protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
		allow = _allowSelfSignedCertificates;
	} else {
		allow = _allowClearTextCredentials;
	}
	return allow;
}
*/

/*
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	// See for details:
	// http://developer.apple.com/library/mac/#documentation/cocoa/conceptual/urlloadingsystem/Articles/AuthenticationChallenges.html

	// TODO: Doublecheck the code and rewrite if necessary.

	if ([challenge previousFailureCount] == 0 &&
		_username && _username.length > 0 &&
		_password && _password.length > 0) {
		NSURLCredential *credentials = 
			[NSURLCredential credentialWithUser:_username
			                           password:_password
			                        persistence:NSURLCredentialPersistenceForSession];
		[[challenge sender] useCredential:credentials
		       forAuthenticationChallenge:challenge];
	} else {
		[[challenge sender] cancelAuthenticationChallenge:challenge];
		[self cleanupConnection];
		//...
		//NSURLErrorUserAuthenticationRequired
		//NSURLErrorUserCancelledAuthentication
	}
}
*/

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection {
	return YES;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[self cleanupConnection];
	if ([_delegate respondsToSelector:@selector(mjpegStreamClient:didFailWithError:)])
		[_delegate mjpegStreamClient:self didFailWithError:error];
}

@end
