//
//  TrackRecord.h
//  SongSearch
//
//  Created by Ilya Maier on 31/03/2019.
//  Copyright © 2019 imaier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackRecord : NSObject
@property (nonatomic) NSInteger trackID;
@property (copy, nonatomic) NSString *track;
@property (copy, nonatomic) NSString *artist;
@property (copy, nonatomic) NSString *collection;
@property (copy, nonatomic) NSString *artworkUrl100;
@property (copy, nonatomic) NSString *previewUrl;


-(instancetype)initWithDictionary:(NSDictionary*)dict;
@end
