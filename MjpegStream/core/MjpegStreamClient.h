//
//  MjpegStreamClient.h
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


#import <Foundation/Foundation.h>


@class MjpegStreamClient;


@protocol MjpegStreamClientDelegate <NSObject>

@optional
- (void)mjpegStreamClient:(MjpegStreamClient *)mjpegStreamClient didReceiveImage:(UIImage *)image;
- (void)mjpegStreamClientDidFinishConnection:(MjpegStreamClient *)mjpegStreamClient;
- (void)mjpegStreamClient:(MjpegStreamClient *)mjpegStreamClient didFailWithError:(NSError *)error;

@end


@interface MjpegStreamClient : NSObject

//@property (strong, nonatomic) NSString *username;
//@property (strong, nonatomic) NSString *password;

//@property (assign, nonatomic) BOOL allowSelfSignedCertificates;
//@property (assign, nonatomic) BOOL allowClearTextCredentials;

@property (strong, nonatomic) NSURL *url;

@property (readonly, nonatomic, getter=isActive) BOOL active;

@property (weak, nonatomic) id <MjpegStreamClientDelegate> delegate;

- (id)initWithUrl:(NSURL *)url delegate:(id <MjpegStreamClientDelegate>)delegate;

- (void)start;
- (void)stop;

@end
