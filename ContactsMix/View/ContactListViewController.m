//
//  ContactListViewController.m
//  ContactsMix
//
//  Created by Abraham Duran on 8/11/25.
//

#import "ContactListViewController.h"
#import "ContactsMix-Swift.h"

@interface ContactListViewController () <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ContactListViewModel *viewModel;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation ContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.systemBackgroundColor;
    self.viewModel = [[ContactListViewModel alloc] init];

    self.title = @"Contactos";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Nuevo"
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:@selector(didTapNew)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Borrar"
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(didTapDelete)];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleInsetGrouped];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];

    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.navigationItem.searchController = self.searchController;
    self.definesPresentationContext = YES;

    [self.viewModel load];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Actions

- (void)didTapNew {
    __weak typeof(self) weakSelf = self;
    UIViewController *addVC = [AddContactFactory
                               makeOnCancel: ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    } onSave:^(Contact * _Nonnull contact) {
        [weakSelf.viewModel addWithContact:contact];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        [weakSelf.tableView reloadData];
    }];

    addVC.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:addVC animated:YES completion:nil];
}

- (void)didTapDelete {
    BOOL editing = !self.tableView.isEditing;
    [self.tableView setEditing:editing animated:YES];
    self.navigationItem.rightBarButtonItem.title = editing ? @"Listo" : @"Borrar";
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfItems];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) { cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuse]; cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; }

    Contact *c = [self.viewModel itemAt:indexPath.row];
    cell.textLabel.text = c.fullName;
    cell.detailTextLabel.text = c.phone;

    // Carga de imagen simple (opcional: mejor usar cache async)
    if (c.imageUrl.length > 0) {
        NSURL *url = [NSURL URLWithString:c.imageUrl];
        NSURLSessionDataTask *task =
        [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *res, NSError *err) {
            if (data && !err) {
                UIImage *img = [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    UITableViewCell *updateCell = [tableView cellForRowAtIndexPath:indexPath];
                    if (updateCell) {
                        updateCell.imageView.image = img;
                        updateCell.imageView.layer.cornerRadius = 6;
                        updateCell.imageView.clipsToBounds = YES;
                        [updateCell setNeedsLayout];
                    }
                });
            }
        }];
        [task resume];
    } else {
        cell.imageView.image = [UIImage systemImageNamed:@"person.circle"];
    }

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.viewModel deleteAt:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *text = searchController.searchBar.text ?: @"";
    [self.viewModel updateQuery:text];
    [self.tableView reloadData];
}

@end
