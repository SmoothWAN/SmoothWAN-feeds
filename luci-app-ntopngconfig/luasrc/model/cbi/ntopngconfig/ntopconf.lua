config = Map("ntopconf")

view = config:section(NamedSection,"Setup", "config",  translate("Ntopng Configuration"),translate("<b>Warning</b>: Depending on the hardware and throughput, VPN performance may be significantly impacted.<br><b>Note</b>: Ntopng proccess is fully de-prioritized in favour of VPN performance and thus the web interface may be slow."))
enabled = view:option(Flag, "enabled", "Enable", "Starts Ntopng and enables autostart on power-up."); view.optional=false; view.rmempty = false;
download = view:option(Button, "_download", "Download Ntopng", "Downloads a <a href='https://github.com/SmoothWAN/SmoothWAN-chroot-imagebuilder'>pre-installed Ntopng in a Debian container</a> to internal storage.<br>Requires at least 4GB of free space.<br>Routers: Go to the Guide tab for external storage setup.")

function download.write()
 luci.http.redirect("/cgi-bin/luci/admin/services/ntopconf/logs")
end

return config