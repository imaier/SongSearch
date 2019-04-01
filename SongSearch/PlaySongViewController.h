//
//  PlaySongViewController.h
//  SongSearch
//
//  Created by Ilya Maier on 31/03/2019.
//  Copyright © 2019 imaier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackRecord.h"


@interface PlaySongViewController : UIViewController
@property (strong, nonatomic) TrackRecord *trackRecord;
@end
