Jenkins.instance.pluginManager.plugins.each{
    plugin ->
        println ("'${plugin.getShortName()}' :  version =>  '${plugin.getVersion()}'; # ${plugin.getDisplayName()}  ")
}


println  ("done.")



