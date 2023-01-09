config = Map("adhomeconfig")

view = config:section(NamedSection,"Setup", "config",  translate("AdGuard Home Configuration"))
pass = view:option(Value, "pass", "WebUI Password:", "Default admin password: brassworld"); pass.optional=false; pass.rmempty = false; pass.password=true;

return config
