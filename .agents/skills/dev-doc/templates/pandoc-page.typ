// Pandoc `--include-in-header`: page chrome before `conf()` title float.
#import "theme/report.typ": report-page
#show: report-page.with(
  header-left: [Sample report · Typst pipeline],
  header-right: [draft for review],
)
