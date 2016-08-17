# Requirement

MacOS or Linux with Ruby(2.0.0 or higher is recommended)

# Preparation

1. download http://www.post.japanpost.jp/zipcode/dl/oogaki/zip/ken_all.zip
2. unzip the file you downloaded in step 1. and move 'KEN_ALL.CSV' to the app's root directory
3. cd app's root directory

# Execution

execute:  
`$ ruby search_address.rb`

The first time you execute the command above, 'ken_all_index' file will be created in the app's root directory.  
(NOTE: This takes a few minutes. You can enjoy a cup of coffee.)

After 'ken_all_index' is created, you will be asked to type some words to search for addresses like '渋谷'.  
And then up to 100 records regarding the words you typed will be printed.  
When there are more than 100 records, you will be asked if you want to see another page(For example 101 ~ 200).  
If you type 'y', you will be asked which page you want to see. So just type a page number.

# How to quit

Just press `ctrl + c`

# Note

Many full-text search engines use Morphological Analysis(形態素解析) as a search algorithm.  
However, this application adopts Uni-gram(also known as N-gram).  
This might confuse you a bit.
So let me explain the difference between Morphological Analysis and Uni-gram.

Let's say there are two records like below.

```
record1: '東京都台東区上野'
record2: '京都府京都市東山区'
```

and imagine the input text is `'東京'`

**Morphological Analysis:**

Only record1 is hit because record2 does not have a word '東京'

**Uni-gram:**

Both record1 and record2 are hit because they both have '東' and '京'


As mentioned, this application adopts the latter.  
This means if you search '東京', the results will contain '京都府京都市東山区'. This is NOT a bug.
