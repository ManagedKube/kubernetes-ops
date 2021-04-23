output chart {
  value       = helm_release.helm_chart.chart
}

output revision {
  value       = helm_release.helm_chart.revision
}

output status {
  value       = helm_release.helm_chart.status
}
