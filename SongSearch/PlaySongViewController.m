//
//  PlaySongViewController.m
//  SongSearch
//
//  Created by Ilya Maier on 31/03/2019.
//  Copyright © 2019 imaier. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>

#import "PlaySongViewController.h"
#import "DownloadManager.h"

@interface PlaySongViewController ()
@property (weak, nonatomic) IBOutlet UILabel *trackName;
@property (weak, nonatomic) IBOutlet UILabel *collectionName;
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UIImageView *artwork;
@property (weak, nonatomic) IBOutlet UISlider *currentTimeSlider;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, strong) AVAudioPlayer* player;
@property (nonatomic, strong) NSTimer* timer;

- (void)updateUI;
- (void)updatePlayerUI;
- (void)createPlayer;
- (void)timerFired:(NSTimer*)timer;
- (void)stopTimer;
@end

@implementation PlaySongViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
    [self updateUI];
    [self createPlayer];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.player = nil;
}

- (void)setTrackRecord:(TrackRecord *)trackRecord {
    if (_trackRecord == trackRecord) {
        return;
    }
    _trackRecord = trackRecord;
    [self updateUI];
}

- (void)createPlayer {
    self.durationLabel.text = @"Loading...";
    [self.activityIndicatorView setHidden:FALSE];
    self.activityIndicatorView.hidesWhenStopped = TRUE;

    [self.activityIndicatorView startAnimating];
    [self updatePlayerUI];
    [[DownloadManager sharedInstance] downloadDataWithURL:self.trackRecord.previewUrl completionHandler:^(NSData *data, NSString *copyUrl) {
        if ([self.trackRecord.previewUrl compare:copyUrl] == NSOrderedSame) {
            [self.activityIndicatorView setHidden:TRUE];
            NSError *error = nil;
            self.player = [[AVAudioPlayer alloc] initWithData:data error:&error];
            if (!error) {
                self.player.volume = 1.0f;
                self.durationLabel.text = [NSString
                                           stringWithFormat:@"%.02f",self.player.duration];
                self.currentTimeSlider.minimumValue = 0.0f;
                self.currentTimeSlider.maximumValue = self.player.duration;
                [self updatePlayerUI];
            } else {
                self.durationLabel.text = @"error";
                self.currentTimeSlider.minimumValue = 0.0f;
                self.currentTimeSlider.maximumValue = 1.0f;
            }
        }
    }];
}

- (void)updateUI {
    self.trackName.text = self.trackRecord.track;
    self.collectionName.text = self.trackRecord.collection;
    self.artistName.text = self.trackRecord.artist;
    
    [[DownloadManager sharedInstance] downloadDataWithURL:self.trackRecord.artworkUrl100 completionHandler:^(NSData *image, NSString *copyUrl) {
        if ([self.trackRecord.artworkUrl100 compare:copyUrl] == NSOrderedSame) {
            self.artwork.image = [UIImage imageWithData:image];
        }
    }];
}

- (IBAction)play {
    [self.player play];
    self.timer = [NSTimer
                  scheduledTimerWithTimeInterval:0.1
                  target:self selector:@selector(timerFired:)
                  userInfo:nil repeats:YES];
}
- (IBAction)pause {
    [self.player pause];
    [self stopTimer];
    [self updatePlayerUI];
}
- (IBAction)stop {
    [self.player stop];
    self.player.currentTime = 0;
    [self stopTimer];
    [self updatePlayerUI];
}

- (void)timerFired:(NSTimer*)timer
{
    [self updatePlayerUI];
}

-(void)updatePlayerUI {
    NSTimeInterval currentTime = self.player.currentTime;
    NSString* currentTimeString = [NSString stringWithFormat:@"%.02f", currentTime];
    
    self.currentTimeSlider.value = currentTime;
    self.currentTimeLabel.text = currentTimeString;
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}
- (IBAction)currentTimeSliderValueChanged {
    if(self.timer) {
        [self stopTimer];
    }
    NSString* currentTimeString = [NSString stringWithFormat:@"%.02f", self.currentTimeSlider.value];
    self.currentTimeLabel.text = currentTimeString;
}

- (IBAction)currentTimeSliderTouchUpInside {
    [self.player stop];
    self.player.currentTime = self.currentTimeSlider.value;
    [self.player prepareToPlay];
    [self play];
}

@end
