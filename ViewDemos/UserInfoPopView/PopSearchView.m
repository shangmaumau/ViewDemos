//
//  PopSearchView.m
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/21.
//

#import "PopSearchView.h"
#import "SMMCategories.h"

#import "LocalJSONManager.h"

static NSString *searchResultCellIdentifier = @"searchResultCellIdentifier";

@interface PopSearchCell : UITableViewCell

- (void)updateTitle:(NSString *)title highlightedText:(NSString *)hilight;

@end

@implementation PopSearchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.font = [UIFont systemFontOfSize:18.0];
        self.textLabel.textColor = [UIColor doubleFishThemeColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)updateTitle:(NSString *)title highlightedText:(NSString *)hilight {
    
    if (title.length < 1 || hilight.length < 1) {
        return;
    }
    
    NSRange hiRange = [title localizedStandardRangeOfString:hilight];
    
    NSMutableAttributedString *mAttribute = [[NSMutableAttributedString alloc] initWithString:title];
    [mAttribute addAttribute:NSForegroundColorAttributeName
                       value:[UIColor doubleFishTintColor]
                       range:hiRange];
    [mAttribute addAttribute:NSForegroundColorAttributeName
                       value:[UIColor doubleFishThemeColor]
                       range:NSMakeRange(NSMaxRange(hiRange), title.length - hiRange.length)];
    
    self.textLabel.attributedText = [mAttribute copy];
}

@end

@interface PopSearchView ()<UITableViewDataSource, UITableViewDelegate> {
    
    NSString *_searchText;
}

@property (nonatomic, assign) PopSearchFilterMode mode;

@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSString *> *dataSource;
@property (nonatomic, strong) NSArray<NSString *> *showList;

@end

@implementation PopSearchView

- (BOOL)resignFirstResponder {
    [_searchField resignFirstResponder];
    return [super resignFirstResponder];
}

- (void)configDataSource:(NSArray *)dataSource {
    
    NSMutableArray<NSString *> *datas = [NSMutableArray array];
    for (NSUInteger i = 0; i < dataSource.count; i++) {
        NSString *title = (NSString *)(dataSource[i]);
        if (![title isKindOfClass:[NSString class]]) {
            title = [[dataSource[i] valueForKey:@"title"] stringValue];
        }
        if (![title isKindOfClass:[NSString class]]) {
            title = [[dataSource[i] valueForKey:@"name"] stringValue];
        }
        if ([title isKindOfClass:[NSString class]]) {
            [datas addObject:title];
        }
    }
    
    _dataSource = [datas copy];
}

- (void)configSearchPlaceholderText:(NSString *)placeholder {
    _searchField.placeholder = placeholder;
}

- (instancetype)initWithFrame:(CGRect)frame mode:(PopSearchFilterMode)mode andDataSource:(NSArray *)dataSource {
    
    if (self = [super initWithFrame:frame]) {
        
        _mode = mode;
        [self configDataSource:dataSource];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self _configBasicSubviews];
        _mode = PopSearchFilterModeBeginsWith;
        _dataSource = [LocalJSONManager universities_name];
    }
    return self;
}

- (void)_configBasicSubviews {
    
    UITextField *view = [UITextField new];
    view.textColor = [UIColor doubleFishThemeColor];
    view.font = [UIFont systemFontOfSize:18.0];
    
    view.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    view.backgroundColor = [[UIColor doubleFishThemeColor] colorWithAlphaComponent:0.04];
    // rgba(255, 120, 253, 1)
    view.tintColor = [UIColor colorWith255R:255.0 g:120.0 b:253.0];
    view.layer.cornerRadius = 8.0;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIPadding, kUIPadding)];
    view.leftViewMode = UITextFieldViewModeAlways;
    view.leftView = leftView;
    
    _searchField = view;
    _searchField.placeholder = NSLocalizedString(@"请输入以检索", @"");
    
    [_searchField addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[PopSearchCell class] forCellReuseIdentifier:searchResultCellIdentifier];
    
    _tableView.layer.cornerRadius = 8.0;
    
    [self addSubview:_searchField];
    [self addSubview:_tableView];

    [_searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@(51.5*kWidthScale));
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_searchField.mas_bottom).offset(kUIPaddingHalf);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
}

- (void)textFieldTextDidChange:(UITextField *)tf {
    
    NSString *searchText = tf.text;
    
    if ([searchText length] == 0) {
        
        _showList = @[];
        [_tableView reloadData];
        
    } else {
        UITextRange *selectedRange = [tf markedTextRange];
        // 获取高亮部分
        UITextPosition *position = [tf positionFromPosition:selectedRange.start offset:0];
        
        if (!position) {
            _searchText = searchText;
            
            NSPredicate *predicate = nil;
            switch (_mode) {
                case PopSearchFilterModeBeginsWith:
                    predicate = [NSPredicate predicateWithFormat:@"SELF beginsWith[cd] %@", searchText];
                    break;
                
                case PopSearchFilterModeContains:
                    predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchText];
                    
                default: // 默认匹配开头
                    predicate = [NSPredicate predicateWithFormat:@"SELF beginsWith[cd] %@", searchText];
                    break;
            }
            
            _showList = [_dataSource filteredArrayUsingPredicate:predicate];
            [_tableView reloadData];
        }
    }
}

// MARK: - 列表视图数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _showList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PopSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:searchResultCellIdentifier forIndexPath:indexPath];
    [cell updateTitle:_showList[indexPath.row] highlightedText:_searchText];
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchView:willSelectRow:)]) {
        NSInteger idx = [self indexOfData:_showList[indexPath.row]];
        if (idx != NSNotFound) {
            [self.delegate searchView:self willSelectRow:idx];
        }
    }
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchView:didSelectRow:)]) {
        
        NSString *selectTitle = _showList[indexPath.row];
        
        _searchField.text = selectTitle;
        [self textFieldTextDidChange:_searchField];
        
        NSInteger idx = [self indexOfData:selectTitle];
        if (idx != NSNotFound) {
            [self.delegate searchView:self didSelectRow:idx];
        }
    }
}

- (NSInteger)indexOfData:(NSString *)title {
    if (![title isKindOfClass:[NSString class]] || title.length < 1) {
        return NSNotFound;
    }
    return [_dataSource indexOfObject:title];
}

@end
