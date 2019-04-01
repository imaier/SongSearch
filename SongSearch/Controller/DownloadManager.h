//
//  ITunesManager.h
//  SongSearch
//
//  Created by Ilya Maier on 29/03/2019.
//  Copyright © 2019 imaier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadManager : NSObject
+(instancetype)sharedInstance;

-(void)downloadDataWithURL:(NSString*)url completionHandler:(void(^)(NSData* data, NSString *copyUrl))block;
-(void)searchSongsWithText:(NSString*)text completionHandler:(void(^)(NSArray* songlist))block;
@end
