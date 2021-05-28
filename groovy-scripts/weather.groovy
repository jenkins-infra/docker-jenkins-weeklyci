// From https://support.cloudbees.com/hc/en-us/articles/216973327
def dryRun = false

final metricToExclude = "com.cloudbees.hudson.plugins.folder.health.ProjectEnabledHealthMetric"
final verb = dryRun ? "Would remove" : "Removing"
Jenkins.instance.allItems(com.cloudbees.hudson.plugins.folder.AbstractFolder).each { folder ->
    def removed = folder.healthMetrics.removeIf { metric ->
        if (metric.class.name.equals(metricToExclude)) {
            return false
        }
        println "${verb} ${metric.class.simpleName} from ${folder.name}"
        return !dryRun
    }
    if (removed) {
        folder.save()
    }
}
return null
