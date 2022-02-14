m = Map("wireless", "Simplified WiFi Configuration", "Automatically configures advanced parameters.<br>USB WiFi sticks support is work in progress.<br>It is recommended to use a dedicated WiFi AP via Ethernet when possible.")

s = m:section(TypedSection, "wifi-iface", "Internal WiFi", "Use as backup or configuration access only due to poor performance of the onboard hardware of the Raspberry Pi 4(B).")


function s:filter(value)
        return value == "default_radio0"
end

ap = s:option(Value, "ssid", "Access Point name:")
ap.rmempty = false
ap.optional = false
pass = s:option(Value, "key", "Password:")
pass.password = true
pass.rmempty = false
pass.optional = false

return m
