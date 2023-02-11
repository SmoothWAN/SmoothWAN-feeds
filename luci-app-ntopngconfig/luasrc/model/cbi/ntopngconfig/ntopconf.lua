config = Map("ntopconf")

view = config:section(NamedSection,"Setup", "config",  translate("Ntopng Configuration"),translate("<b>Warning</b>: Depending on the hardware and throughput, performance may be significantly impacted.<br><b>Note</b>: Ntopng proccess is fully de-prioritized in favour of VPN performance and thus the web interface may be slow.<br>‣ Service may take a minute to start at: <a href='http://172.17.17.2:4000'>http://172.17.17.2:4000</a>"))
enabled = view:option(Flag, "enabled", "Enable", "Starts Ntopng and enables autostart on power-up."); view.optional=false; view.rmempty = false;
download = view:option(Button, "_download", "Download / Update Ntopng", "Downloads a <a href='https://github.com/SmoothWAN/SmoothWAN-chroot-imagebuilder'>pre-installed Ntopng in a Debian container</a> to internal storage.<br>Requires at least 4GB of free space.<br>Routers: Go to the Guide tab for external storage setup.")

function download.write()
 luci.sys.call("sh /usr/lib/chroot/download.sh > /tmp/ntopconf.log &")
 luci.http.redirect("/cgi-bin/luci/admin/services/ntopconf/logs")
end

function config.on_commit(self)
    luci.sys.exec("sh -c 'sleep 2 && /etc/init.d/ntopngconf restart' &")
end

return config