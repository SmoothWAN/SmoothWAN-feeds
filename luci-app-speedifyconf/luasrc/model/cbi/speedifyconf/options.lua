config = Map("speedifyconf")

view = config:section(NamedSection,"Setup", "config",  translate("Configuration Extras"), translate("Check the log tab for action results."))
verovd = view:option(Value, "verovd", "Version override:", "Format example: 12.8.0-10744<br>Empty to use the latest version.<br>Re-install Speedify in the configuration tab after applying.");   view.optional=false; view.rmempty = false;
dmpver = view:option(Button, "_dmpver", "List versions", "Lists previously available versions in the log tab.")
restart = view:option(Button, "_restart", "Restart Speedify", "Force restart Speedify.")
stop = view:option(Button, "_stop", "Halt Speedify", "Force stop Speedify.")
uninstall = view:option(Button, "_remove", "Uninstall Speedify", "Remove all Speedify files")

function dmpver.write()
  luci.sys.call("echo 'Log Reset' > /tmp/speedifyconfig.log")
  luci.sys.call("sh /usr/lib/speedifyconf/run.sh list-versions >> /tmp/speedifyconfig.log")
  luci.http.redirect("/cgi-bin/luci/admin/vpn/spdconf/logs")
end

function restart.write()
  luci.sys.call("/etc/init.d/speedifyconf restart")
end

function stop.write()
  luci.sys.call("/etc/init.d/speedifyconf stop")
end

function uninstall.write()
 luci.sys.call("/etc/init.d/speedifyconf stop")
 luci.sys.call("rm -rf /usr/share/speedify/* /usr/share/speedifyui/* /www/spdui/*")
 luci.sys.call("echo '<h1>Speedify was manually uninstalled...</h1>' | tee /www/spdui/index.html | tee /tmp/speedifyconfig.log")
 luci.http.redirect("/cgi-bin/luci/admin/vpn/spdconf/logs")
end

return config