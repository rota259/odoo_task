"""Provision the local Odoo 17 instance for the 2S Home Wear app.

Runs inside the odoo container (it ships Python 3), so reviewers need nothing
but Docker. Idempotent: safe to run again at any time.

Steps: wait for Odoo -> create `odoo_demo` with demo data -> install Sales ->
ensure admin/demo/portal users -> ensure customers + draft quotations.
"""
import http.cookiejar
import json
import os
import sys
import time
import urllib.request

URL = os.environ.get("ODOO_URL", "http://localhost:8069")
DB = os.environ.get("ODOO_DB", "odoo_demo")
MASTER = os.environ.get("ODOO_MASTER_PASSWORD", "admin")
USERS = [("admin", "admin", "internal"), ("demo", "demo", "internal"),
         ("portal", "portal", "portal")]


class RpcError(Exception):
    pass


class Session:
    def __init__(self):
        jar = http.cookiejar.CookieJar()
        self.opener = urllib.request.build_opener(
            urllib.request.HTTPCookieProcessor(jar))

    def post(self, path, params, timeout=900):
        body = json.dumps({"jsonrpc": "2.0", "method": "call",
                           "params": params}).encode()
        req = urllib.request.Request(URL + path, body,
                                     {"Content-Type": "application/json"})
        data = json.load(self.opener.open(req, timeout=timeout))
        if "error" in data:
            raise RpcError(data["error"]["data"].get("message"))
        return data["result"]

    def login(self, login, password):
        return self.post("/web/session/authenticate",
                         {"db": DB, "login": login, "password": password})

    def kw(self, model, method, args, **kwargs):
        return self.post(f"/web/dataset/call_kw/{model}/{method}",
                         {"model": model, "method": method,
                          "args": args, "kwargs": kwargs})


def log(msg):
    print(f"[setup] {msg}", flush=True)


def wait_for_odoo():
    for _ in range(120):
        try:
            urllib.request.urlopen(URL + "/web/database/selector", timeout=5)
            return log(f"Odoo is up at {URL}")
        except Exception:
            time.sleep(2)
    sys.exit("[setup] Odoo did not come up in time")


def ensure_database():
    dbs = Session().post("/jsonrpc", {"service": "db", "method": "list",
                                      "args": []})
    if DB in dbs:
        return log(f"Database '{DB}' already exists")
    log(f"Creating '{DB}' with demo data (this takes a minute)...")
    Session().post("/jsonrpc", {"service": "db", "method": "create_database",
                                "args": [MASTER, DB, True, "en_US",
                                         "admin", "admin"]})
    dbs = Session().post("/jsonrpc", {"service": "db", "method": "list",
                                      "args": []})
    if DB not in dbs:
        sys.exit("[setup] Database creation failed")
    log(f"Database '{DB}' created")


def admin_session():
    s = Session()
    s.login("admin", "admin")
    return s


def ensure_modules(s):
    for name in ("sale", "sale_management"):
        mod = s.kw("ir.module.module", "search_read", [[["name", "=", name]]],
                   fields=["state"])[0]
        if mod["state"] != "installed":
            log(f"Installing '{name}'...")
            s.kw("ir.module.module", "button_immediate_install", [[mod["id"]]])
            s = admin_session()
        state = s.kw("ir.module.module", "read", [[mod["id"]], ["state"]])
        log(f"Module '{name}': {state[0]['state']}")
    return s


def xmlid(s, module, name):
    rows = s.kw("ir.model.data", "search_read",
                [[["module", "=", module], ["name", "=", name]]],
                fields=["res_id"])
    return rows[0]["res_id"]


def ensure_users(s):
    group = {"internal": xmlid(s, "base", "group_user"),
             "portal": xmlid(s, "base", "group_portal")}
    for login, password, kind in USERS:
        users = s.kw("res.users", "search_read", [[["login", "=", login]]],
                     fields=["id"], context={"active_test": False})
        if not users:
            log(f"Creating user '{login}' ({kind})")
            uid = s.kw("res.users", "create", [{
                "name": login.capitalize(), "login": login,
                "password": password,
                "groups_id": [[6, 0, [group[kind]]]]}])
        else:
            uid = users[0]["id"]
            if login != "admin":
                vals = {"password": password, "active": True}
                if kind == "portal":
                    vals["groups_id"] = [[6, 0, [group["portal"]]]]
                s.kw("res.users", "write", [[uid], vals])
        check = Session()
        info = check.login(login, password)
        internal = check.kw("res.users", "has_group", ["base.group_user"])
        if internal != (kind == "internal"):
            sys.exit(f"[setup] '{login}' internal={internal}, "
                     f"expected {kind}")
        log(f"User '{login}' OK (uid={info['uid']}, internal={internal})")


def ensure_customers(s):
    company_partners = [c["partner_id"][0] for c in s.kw(
        "res.company", "search_read", [[]], fields=["partner_id"])]
    # Odoo 17 demo data only ranks partners with posted invoices (2 of them),
    # so mark the remaining demo contacts as customers too.
    ids = s.kw("res.partner", "search", [[
        ["user_ids", "=", False], ["customer_rank", "=", 0],
        ["id", "not in", company_partners]]])
    if ids:
        s.kw("res.partner", "write", [ids, {"customer_rank": 1}])
    total = s.kw("res.partner", "search_count",
                 [[["customer_rank", ">", 0]]])
    log(f"Customers (customer_rank > 0): {total} ({len(ids)} newly marked)")


def ensure_quotations(s):
    domain = [["state", "in", ["draft", "sent"]]]
    count = s.kw("sale.order", "search_count", [domain])
    if count < 2:
        partners = s.kw("res.partner", "search",
                        [[["customer_rank", ">", 0]]], limit=3)
        products = s.kw("product.product", "search",
                        [[["sale_ok", "=", True]]], limit=3)
        for i, partner in enumerate(partners):
            s.kw("sale.order", "create", [{
                "partner_id": partner,
                "order_line": [[0, 0, {"product_id": products[i],
                                       "product_uom_qty": i + 1}]]}])
        count = s.kw("sale.order", "search_count", [domain])
        log(f"Created {len(partners)} draft quotations")
    log(f"Draft/sent quotations available to confirm: {count}")


if __name__ == "__main__":
    wait_for_odoo()
    ensure_database()
    session = ensure_modules(admin_session())
    ensure_users(session)
    ensure_customers(session)
    ensure_quotations(session)
    log("Done. Open http://localhost:8069 (admin/admin).")
