//
//  ITunesManager.m
//  SongSearch
//
//  Created by Ilya Maier on 29/03/2019.
//  Copyright © 2019 imaier. All rights reserved.
//

#import "DownloadManager.h"
#import "TrackRecord.h"

DownloadManager *g_sharedInstance = nil;

@interface DownloadManager()

@property NSCache *imageCache;

@end

@implementation DownloadManager

+(instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_sharedInstance = [DownloadManager new];
    });
    return g_sharedInstance;
}

-(void)downloadDataWithURL:(NSString*)url completionHandler:(void(^)(NSData* image, NSString *copyUrl))block {
    NSData* imageData = [self.imageCache objectForKey:url];
    if (imageData) {
        block(imageData, url);
        return;
    }
    NSURLSession *urlSession = [NSURLSession sharedSession];
    NSURL *imageUrl= [NSURL URLWithString:url];
    DownloadManager __weak *weakself = self;
    NSString *copyUrl = url.copy;
    NSURLSessionDataTask *task = [urlSession dataTaskWithURL:imageUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself.imageCache setObject:data forKey:url];
                block(data, copyUrl);
            });
        }
    }];
    [task resume];
}

-(void)searchSongsWithText:(NSString *)text completionHandler:(void (^)(NSArray *))block {

    NSURLSession *urlSession = [NSURLSession sharedSession];
    NSString *searchUrlText = [NSString stringWithFormat:@"https://itunes.apple.com/search?term=%@", text];
    NSURL *searchUrl= [NSURL URLWithString:searchUrlText];
    
    NSURLSessionDataTask *task = [urlSession dataTaskWithURL:searchUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSError *jsonError = nil;
            NSDictionary *searchResults = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            NSArray *results = searchResults[@"results"];
            NSMutableArray *songs = [NSMutableArray new];
            for (NSDictionary *track in results) {
                TrackRecord *trackRecord = [[TrackRecord alloc] initWithDictionary: track];
                [songs addObject:trackRecord];
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                block([NSArray arrayWithArray:songs]);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(nil);
            });
        }
    }];
    [task resume];
}
@end
