Jenkins.instance.pluginManager.plugins.each{
    plugin ->
        println ("'${plugin.getShortName()}' => { version =>   '${plugin.getVersion()}' , update_url => \$targetall.vars[plugins_repo]}, # ${plugin.getDisplayName()}  ")

}
println  ("done.")
