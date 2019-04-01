//
//  TrackTableViewCell.h
//  SongSearch
//
//  Created by Ilya Maier on 29/03/2019.
//  Copyright © 2019 imaier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackRecord.h"

@interface TrackTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *artwork;
@property (weak, nonatomic) IBOutlet UILabel *track;
@property (weak, nonatomic) IBOutlet UILabel *artist;
@property (weak, nonatomic) IBOutlet UILabel *collection;

@property (strong, nonatomic) TrackRecord *trackRecord;

@end
