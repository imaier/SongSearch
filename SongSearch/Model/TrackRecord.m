//
//  TrackRecord.m
//  SongSearch
//
//  Created by Ilya Maier on 31/03/2019.
//  Copyright © 2019 imaier. All rights reserved.
//

#import "TrackRecord.h"

@implementation TrackRecord
-(instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (!self) {
        return nil;
    }
/*
    {"wrapperType":"track", "kind":"song", "artistId":321144807, "collectionId":444635869, "trackId":444635878, "artistName":"Fitz and The Tantrums", "collectionName":"Friends With Benefits (Original Soundtrack)", "trackName":"L.O.V.", "collectionCensoredName":"Friends With Benefits (Original Soundtrack)", "trackCensoredName":"L.O.V.", "collectionArtistId":331122, "collectionArtistName":"Various Artists", "artistViewUrl":"https://itunes.apple.com/us/artist/fitz-and-the-tantrums/321144807?uo=4", "collectionViewUrl":"https://itunes.apple.com/us/album/l-o-v/444635869?i=444635878&uo=4", "trackViewUrl":"https://itunes.apple.com/us/album/l-o-v/444635869?i=444635878&uo=4",
        "previewUrl":"https://audio-ssl.itunes.apple.com/apple-assets-us-std-000001/Music/v4/b6/81/2e/b6812ea9-d59a-72fc-6ee1-e0a2bde322e5/mzaf_6451550154940293045.plus.aac.p.m4a", "artworkUrl30":"https://is2-ssl.mzstatic.com/image/thumb/Music/v4/db/97/57/db975702-f231-ccf0-53f4-385aaeb49a78/source/30x30bb.jpg", "artworkUrl60":"https://is2-ssl.mzstatic.com/image/thumb/Music/v4/db/97/57/db975702-f231-ccf0-53f4-385aaeb49a78/source/60x60bb.jpg", "artworkUrl100":"https://is2-ssl.mzstatic.com/image/thumb/Music/v4/db/97/57/db975702-f231-ccf0-53f4-385aaeb49a78/source/100x100bb.jpg", "collectionPrice":9.99, "trackPrice":-1.00, "releaseDate":"2010-08-24T07:00:00Z", "collectionExplicitness":"notExplicit", "trackExplicitness":"notExplicit", "discCount":1, "discNumber":1, "trackCount":15, "trackNumber":2, "trackTimeMillis":221086, "country":"USA", "currency":"USD", "primaryGenreName":"Soundtrack", "isStreamable":false},
*/
    
    self.track = [dict valueForKey:@"trackName"];
    self.artist = [dict valueForKey:@"artistName"];
    self.collection = [dict valueForKey:@"collectionName"];
    self.trackID = [NSString stringWithFormat:@"%@", [dict valueForKey:@"trackId"]].integerValue;
    self.artworkUrl100 = [dict valueForKey:@"artworkUrl100"];
    self.previewUrl = [dict valueForKey:@"previewUrl"];
    return self;
}
@end
