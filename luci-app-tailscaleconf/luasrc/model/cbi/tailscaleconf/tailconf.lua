config = Map("tailconf")

view = config:section(NamedSection,"Setup", "config",  translate("Tailscale Configuration"), translate("Check the log tab for installation progress."))
auto = view:option(Flag, "autoupdate", "Update on boot:", "Updates Tailscale before starting."); view.optional=false; view.rmempty = false;
upd = view:option(Button, "_update", "Trigger Install/Update", "Setup page: <a href='http://172.17.17.2:8088' target='_blank'>http://172.17.17.2:8088</a>");
uni = view:option(Button, "_uninstall", "Trigger Uninstall", "Uninstalls Tailscale");

function upd.write()
  luci.sys.call("echo 'Log Reset' > /usr/lib/tailconf/tailconfig.log && sh /usr/lib/tailconf/run.sh update >> /usr/lib/tailconf/tailconfig.log &")
end

function uni.write()
  luci.sys.call("echo 'Log Reset' > /usr/lib/tailconf/tailconfig.log && sh /usr/lib/tailconf/run.sh uninstall >> /usr/lib/tailconf/tailconfig.log &")
end

return config
