module("luci.controller.adhomeconfig.adhconf", package.seeall)
  
local fs = require "nixio.fs"
local sys = require "luci.sys"
local template = require "luci.template"
local i18n = require "luci.i18n"


function index()
     local e = entry({"admin", "services", "adhconf"}, firstchild(), _("AdGuard Home"), 60)
     e.acl_depends = { "luci-app-adhomeconfig" }
     e.dependent = false
     
     entry({"admin", "services", "adhconf", "guide"}, call("guidehelp"), _("Guide"), 1)
     entry({"admin", "services", "adhconf", "config"}, cbi("adhomeconfig/adhconf"), _("Configuration"), 2)
end

function guidehelp()
    template.render("adhomeconfig/guidehelp",
        {title = i18n.translate("Quick Setup")})
end