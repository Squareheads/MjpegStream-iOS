//
//  MotionJpegImageView.mm
//  VideoTest
//
//  Created by Matthew Eagar on 10/3/11.
//  Copyright 2011 ThinkFlood Inc. All rights reserved.
//
//  Modified by Raman Fedaseyeu on 4/13/13.
//  Copyright 2011 Raman Fedaseyeu. All rights reserved.
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

#import "MotionJpegImageView.h"
#import "CredentialsAlertView.h"


@interface MotionJpegImageView () <MjpegStreamClientDelegate>

@property (strong, nonatomic) MjpegStreamClient *mjpegStreamClient;

@end


@implementation MotionJpegImageView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.contentMode = UIViewContentModeScaleAspectFit;
	}
	return self;
}

- (void)setUrl:(NSURL *)url {
	if (url != _url) {
		_url = url;
		_mjpegStreamClient = [[MjpegStreamClient alloc] initWithUrl:_url delegate:self];
	}
}

- (BOOL)isActive {
	return _mjpegStreamClient.active;
}

- (void)start {
	[_mjpegStreamClient start];
}

- (void)stop {
	[_mjpegStreamClient stop];
}

#pragma mark <MjpegStreamClientDelegate>

- (void)mjpegStreamClient:(MjpegStreamClient *)mjpegStreamClient didReceiveImage:(UIImage *)image {
	self.image = image;
}

- (void)mjpegStreamClientDidFinishConnection:(MjpegStreamClient *)mjpegStreamClient {
	NSLog(@"%s called.", __func__);
}

- (void)mjpegStreamClient:(MjpegStreamClient *)mjpegStreamClient didFailWithError:(NSError *)error {
	NSLog(@"%s called.", __func__);
	NSLog(@"%@", [error localizedDescription]);
}

@end
