//
//  SongSearchTableViewController.m
//  SongSearch
//
//  Created by Ilya Maier on 29/03/2019.
//  Copyright © 2019 imaier. All rights reserved.
//

#import "SongSearchTableViewController.h"
#import "TrackTableViewCell.h"
#import "PlaySongViewController.h"
#import "DownloadManager.h"

#define CELL_IDENTIFIER @"TrackInformationID"
#define NUMBER_OF_SECTION 1
#define MIN_TEXT_LENGTH_FOR_SEARCHING 5

@interface SongSearchTableViewController ()

@property (strong) NSArray * songs;

@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivityIndicatorView;

- (void)searchSongsWithText:(NSString*)text;
- (void)showLoadingView;
- (void)hideLoadingView;

@end

@implementation SongSearchTableViewController

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return NUMBER_OF_SECTION;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.songs.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    TrackRecord *song = self.songs[indexPath.row];
    
    if ([cell isKindOfClass:[TrackTableViewCell class]]) {
        TrackTableViewCell *myCell = (TrackTableViewCell*)(cell);
        myCell.trackRecord = song;
        myCell.track.text = song.track;
        myCell.artist.text = song.artist;
        myCell.collection.text = song.collection;
        
        [[DownloadManager sharedInstance] downloadDataWithURL:song.artworkUrl100 completionHandler:^(NSData *image, NSString *copyUrl) {
            if ([myCell.trackRecord.artworkUrl100 compare:copyUrl] == NSOrderedSame) {
                myCell.artwork.image = [UIImage imageWithData:image];
            }
        }];
    }
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[TrackTableViewCell class]]) {
        TrackTableViewCell *cell = (TrackTableViewCell*)sender;
        if ([[segue destinationViewController] isKindOfClass:[PlaySongViewController class]]) {
            PlaySongViewController *playSongVC = (PlaySongViewController*)[segue destinationViewController];
            playSongVC.trackRecord = cell.trackRecord;
        }
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self searchSongsWithText:searchBar.text];
}
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length < MIN_TEXT_LENGTH_FOR_SEARCHING) {
        return;
    }
    [self searchSongsWithText:searchBar.text];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchSongsWithText:searchBar.text];
}

#pragma mark - Private methods

- (void)searchSongsWithText:(NSString *)text {
    self.songs = @[];
    [self.tableView reloadData];
    [self showLoadingView];

    [[DownloadManager sharedInstance] searchSongsWithText:text completionHandler:^(NSArray *songlist) {
        self.songs = songlist;
        [self.tableView reloadData];
        [self hideLoadingView];
    }];
}

- (void)showLoadingView {
    CGPoint viewCenter = [self.view center];
    viewCenter.y /=2; //just to place under ui keyboard
    self.loadingView.center = viewCenter;
    [self.view addSubview:self.loadingView];
    [self.loadingActivityIndicatorView startAnimating];
}

- (void)hideLoadingView {
    [self.loadingActivityIndicatorView stopAnimating];
    [self.loadingView removeFromSuperview];
}

@end
