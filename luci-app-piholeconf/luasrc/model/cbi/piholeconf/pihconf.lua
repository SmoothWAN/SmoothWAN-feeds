config = Map("piholeconf")
  
view = config:section(NamedSection,"Setup", "config",  translate("Pi-hole Configuration"), translate("Check the log tab for installation progress."))
upd = view:option(Button, "_update", "Trigger Install/Update", "Clients need to reconnect to obtain Pi-hole DNS after first install only.<br>Pi-hole Admin page: <a href='http://192.168.3.3/admin' target='_blank'>http://192.168.3.3/admin</a>")
uin = view:option(Button, "_uninstall", "Trigger Uninstall", "Clients need to reconnect to obtain SmoothWAN DNS.<br>Use this to revert to default DNS settings if installation fails.")
pass = view:option(Value, "pass", "WebUI Password:", "Default admin password: brassworld<br>Password is set on installation/update only.<br>Click  Save and Apply  after setting the password before triggering install/update."); pass.optional=false; pass.rmempty = false; pass.password=true;

function upd.write()
  luci.sys.call("echo 'Log Reset' > /usr/lib/piholeconf/piholeconfig.log & sh /usr/lib/piholeconf/install.sh >> /usr/lib/piholeconf/piholeconfig.log &")
end

function uin.write()
  luci.sys.call("echo 'Log Reset' > /usr/lib/piholeconf/piholeconfig.log & sh /usr/lib/piholeconf/uninstall.sh >> /usr/lib/piholeconf/piholeconfig.log &")
end

return config
