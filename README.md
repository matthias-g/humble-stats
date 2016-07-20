Humble Bundle Stats
===================

This is a small project monitoring the change of the average price of current [humble bundles](https://www.humblebundle.com).
Usually the average price rises during the two weeks a bundle is active.
I started developing this project after I discovered that the average price was falling in one case and I was interested in how often this happens.

[Here](https://16byte.de/graphs/humble) you can see the live results.

This repository should contain all files to set this up on your own.
It's cobbled up and hacky - sorry about that.
Feel free to improve it, clean it up, and create a pull request. ;-)

Setup
-----

The paths in the scripts assume that you have to following structure in your home:
```
graphs/humble
├── do_plot
├── fetch_humble_stats.pl
├── get_data
├── plot.gp
├── run_update_current_bundles
├── stats
└── update_current_bundles.rb

html/graphs/humble
└── index.php
```

Where the directory `html` is accessible from the web and your crontab contains the following entries:
```
*/1 * * * * ~/graphs/humble/get_data
*/20 * * * * ~/graphs/humble/do_plot
*/20 * * * * ~/graphs/humble/run_update_current_bundles
```

How it works
------------

Every 20 minutes [run_update_current_bundles](run_update_current_bundles) is being called. This script calls [update_current_bundles.rb](update_current_bundles.rb) with the correct parameters and environment variables set.
[update_current_bundles.rb](update_current_bundles.rb) gets the home page of Humble Bundle and parses it for the names of the current bundles and writes them to `graphs/humble/current_bundles`.

Every minute the cronjob calls [get_data](get_data). This calls [fetch_humble_stats.pl](fetch_humble_stats.pl) for every line in `current_bundles` and redirects the output to appropriate file in `graphs/humble/stats/`.
This perl script gets an url to the pubnub service for live updates about the humble bundle stats. The service returns a json that is being parsed and printed to stdout.

The data is being plotted every 20 minutes by [do_plot](do_plot) which calls gnuplot for every current bundle.
How the plot looks like is defined in [plot.gp](plot.gp).
