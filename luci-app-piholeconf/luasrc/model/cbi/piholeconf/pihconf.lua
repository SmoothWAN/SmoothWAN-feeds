config = Map("piholeconf")

view = config:section(NamedSection,"Setup", "config",  translate("Pi-hole Configuration"), translate("‣ Check the log tab for installation progress.<br>‣ Click Save & Apply after changing values before installation."))
upd = view:option(Button, "_update", "Trigger Install/Update", "Clients need to reconnect to obtain Pi-hole DNS after first install only.")
uin = view:option(Button, "_uninstall", "Trigger Uninstall", "Clients need to reconnect to obtain SmoothWAN DNS.<br>Use this to revert to default DNS settings if installation fails.")
ip = view:option(Value, "ip", "IP Address", "IP address is applied on installation.<br>Pi-hole admin page is at http://IPAddressAbove/admin")
pass = view:option(Value, "pass", "WebUI Password:", "Default admin password: brassworld<br>Password is set on installation/update only.<br>Click  Save and Apply  after setting the password before triggering install/update."); pass.optional=false; pass.rmempty = false; pass.password=true;

function upd.write()
  luci.sys.call("echo 'Log Reset' > /usr/lib/piholeconf/piholeconfig.log & sh /usr/lib/piholeconf/install.sh >> /usr/lib/piholeconf/piholeconfig.log &")
end

function uin.write()
  luci.sys.call("echo 'Log Reset' > /usr/lib/piholeconf/piholeconfig.log & sh /usr/lib/piholeconf/uninstall.sh >> /usr/lib/piholeconf/piholeconfig.log &")
end

return config
