# svn2git-migration
A script using [svn2git](https://github.com/nirvdrum/svn2git) to converting multiple repositories from SVN to Git.

## Requirements
- [svn2git](https://github.com/nirvdrum/svn2git)
- [PHP 5+](http://php.net)

## Usage

	sh svn2git-migration.sh repositories.txt

## Configuration
To configure copy `lib/config.sample.ini` to `lib/config.ini`. Details for configuring can be found in the comments.

## Contributing
[Fork us](https://github.com/viastudio/svn2git-migration/fork)!

We're specifically looking to convert `lib/create-github-repo.php` from PHP to Ruby. This would eliminate our PHP requirement as `svn2git` requires Ruby.

We'd also like to modify `lib/create-github-repo.php` for non-organizational accounts.