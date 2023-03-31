config = Map("speedifyconf")

view = config:section(NamedSection,"Setup", "config",  translate("Configuration Extras"), translate("Check the log tab for action results."))
verovd = view:option(Value, "verovd", "Version override:", "Format example: 12.8.0-10744<br>Empty to use the latest version.<br>Re-install Speedify in the configuration tab after applying.");   view.optional=false; view.rmempty = false;
dmpver = view:option(Button, "_dmpver", "List versions", "Lists previously available versions in the log tab.")
restart = view:option(Button, "_restart", "Restart Speedify", "Force restart Speedify.")
stop = view:option(Button, "_stop", "Halt Speedify", "Force stop Speedify.")
uninstall = view:option(Button, "_remove", "Uninstall Speedify", "Remove all files.")
renamer = view:option(Flag, "renamer", "Unique USB network interface naming", "Renames USB network devices to the respective port on this device, enable to preserve Speedify network settings, statistics and policy based routing configuration.<br>Disabling this option will name devices in the order they're brought up.<br><br><b>Example:</b> When disabled, plugging a data limited or policy routed interface to different USB ports will always end up <i>eth<b>0</b></i> but it will be named <i>eth<b>1</b></i> or more if other devices are plugged in first, leading to set data caps/policies/statistics applied to the wrong interface in Speedify UI, PBR, and statistics; to add, the order may randomly change when powering up this device with the interfaces plugged.<br>Disable for custom configuration, QMI/NCM modems and probelamtic devices.<br><b>Restart Speedify after applying & replug USB interface(s).</b>"); view.optional=false; view.rmempty = false;
killsw = view:option(Flag, "killsw", "Kill Switch", "Prevents internet access when Speedify is down except bypassed policies, also prevents bypassed policies to leak through Speedify which happens when Speedify is reconnecting/restarted, important for avoiding P2P disconnections. <br>Untested with IPv6 enabled dedicated plan.<br>Auto updates and installation will not work when enabled.<br><b>Restart Speedify after applying.</b>"); view.optional=false; view.rmempty = false;


function dmpver.write()
  luci.sys.call("echo 'Log Reset' > /tmp/speedifyconfig.log")
  luci.sys.call("sh /usr/lib/speedifyconf/run.sh list-versions >> /tmp/speedifyconfig.log")
  luci.http.redirect("/cgi-bin/luci/admin/vpn/spdconf/logs")
end

function restart.write()
  luci.sys.call("/etc/init.d/speedifyconf restart &")
  luci.sys.call("echo 'Done Restart' > /tmp/speedifyconfig.log")
end

function stop.write()
  luci.sys.call("/etc/init.d/speedifyconf stop &")
  luci.sys.call("echo 'Done Stop' > /tmp/speedifyconfig.log")
end

function uninstall.write()
 luci.sys.call("/etc/init.d/speedifyconf stop")
 luci.sys.call("rm -rf /usr/share/speedify/* /usr/share/speedifyui/* /www/spdui/*")
 luci.sys.call("echo 'Speedify was manually uninstalled...' | tee /www/spdui/index.html | tee /tmp/speedifyconfig.log &")
 luci.http.redirect("/cgi-bin/luci/admin/vpn/spdconf/logs")
end

return config