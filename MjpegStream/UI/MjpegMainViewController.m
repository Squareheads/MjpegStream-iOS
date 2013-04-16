//
//  MjpegMainViewController.m
//  MjpegStream
//
//  Created by Raman Fedaseyeu on 4/13/13.
//  Copyright 2013 Raman Fedaseyeu. All rights reserved.
//

#import "MjpegMainViewController.h"
#import "MjpegImageView.h"


@interface MjpegMainViewController ()

@end


@implementation MjpegMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

	// Any MJPEG over HTTP stream.
	NSURL *url = [NSURL URLWithString:@"http://192.168.1.1/?action=stream"];

	_mjpegImageView.url = url;
	[_mjpegImageView start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
