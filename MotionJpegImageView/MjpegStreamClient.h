//
//  MjpegStreamClient.h
//  MotionJpegImageView
//
//  Created by Raman Fedaseyeu on 4/13/13.
//  Copyright (c) 2013 ThinkFlood Inc. All rights reserved.
//

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
