# On App.py of https://github.com/matiastoro/cc3201
# Line 30
cur.execute("SELECT nombres, apellido_p, apellido_m, mes, anho, total FROM uchile.transparencia WHERE apellido_p=%s ORDER BY total DESC LIMIT 250", [input])