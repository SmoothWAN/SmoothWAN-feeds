config = Map("speedifyconf") 

view = config:section(NamedSection,"Setup", "config",  translate("Speedify Configuration"), translate("Check the log tab for installation progress."))
apt = view:option(Value, "apt", "Repository URL:", "Default address last tested on Q1 2022."); view.optional=false; view.rmempty = false;
auto = view:option(Flag, "autoupdate", "Update on boot:", "Update Speedify before starting."); view.optional=false; view.rmempty = false;
upd = view:option(Button, "_update", "Trigger Install/Update", "Install Speedify or update and restart.")
rst = view:option(Button, "_reset", "Trigger Reset", "Reset and restart Speedify.")

function upd.write()
  luci.sys.call("echo 'Log Reset' > /usr/lib/speedifyconfig.log & sh /usr/lib/speedifyconf/run.sh update >> /usr/share/speedifyconfig.log &")
end

function rst.write()
  luci.sys.call("echo 'Log Reset' > /usr/lib/speedifyconfig.log & killall -KILL speedify && rm -rf /usr/share/speedify/logs/* && sh /usr/lib/speedifyconf/run.sh >> /usr/share/speedifyconfig.log &")
end

return config

