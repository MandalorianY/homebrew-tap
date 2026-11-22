# Job Scrapper Homebrew Tap

Install Job Scrapper on macOS to search French job boards and track your applications in a spreadsheet.

## Install

Add the tap and trust it on Homebrew 6 or later. [Homebrew Tap Trust](https://docs.brew.sh/Tap-Trust)

```sh
brew tap mandaloriany/tap
brew trust --tap mandaloriany/tap
brew install mandaloriany/tap/job-scrapper
```

## Run

From the directory where you want to keep your data and exports, add a `config.local.yaml` for your search and run:

```sh
job-scrapper
```

The default tracker is `exports/jobs.xlsx`. See the [Job Scrapper guide](https://github.com/MandalorianY/job-scrapper#readme) for an example configuration, export options, and scheduling.
