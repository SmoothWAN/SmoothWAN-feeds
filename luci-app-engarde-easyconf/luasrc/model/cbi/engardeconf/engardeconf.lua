config = Map("engardeconf")

view = config:section(NamedSection,"Setup", "config",  translate("Engarde Configuration (cloud-init)"))
enabled = view:option(Flag, "enabled", "Enable", "Enables Engarde and Wireguard, disabling Speedify and TinyFEC VPN.<br>Wait 20-30 seconds for Engarde & UI change to commence."); view.optional=false; view.rmempty = false;
pass = view:option(Value, "pass", "Password:", "The password set in cloud-init password field."); pass.optional=false; pass.rmempty = false; pass.password=true;
server = view:option(Value, "dstAddr", "Server IP Address:", "The server IP(v4), found in provider instance info.");

function config.on_commit(self)
    luci.sys.exec("sh -c 'sleep 2 && /etc/init.d/engardeconf restart' &")
end

return config