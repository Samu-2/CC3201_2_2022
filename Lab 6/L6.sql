explain analyze select a.* from opt.personaje10000 a, opt.personaje10000 b where b.p_nombre = 'Forrest Gump' and b.p_anho = 1994 and a.a_nombre = b.a_nombre order by a_nombre;
explain analyze select a.* from opt.personaje1000 a, opt.personaje1000 b where b.p_nombre = 'Forrest Gump' and b.p_anho = 1994 and a.a_nombre = b.a_nombre order by a_nombre;
explain analyze select a.* from opt.personaje100 a, opt.personaje100 b where b.p_nombre = 'Forrest Gump' and b.p_anho = 1994 and a.a_nombre = b.a_nombre order by a_nombre;

explain analyze select a.* from opti.personaje10000 a, opti.personaje10000 b where b.p_nombre = 'Forrest Gump' and b.p_anho = 1994 and a.a_nombre = b.a_nombre order by a_nombre;
explain analyze select a.* from opti.personaje1000 a, opti.personaje1000 b where b.p_nombre = 'Forrest Gump' and b.p_anho = 1994 and a.a_nombre = b.a_nombre order by a_nombre;
explain analyze select a.* from opti.personaje100 a, opti.personaje100 b where b.p_nombre = 'Forrest Gump' and b.p_anho = 1994 and a.a_nombre = b.a_nombre order by a_nombre;

-- ani

explain analyze select * from opt.personaje10000 where a_nombre in (select a_nombre from opt.personaje10000 where p_nombre like 'Forrest Gump') order by a_nombre;
explain analyze select * from opt.personaje1000 where a_nombre in (select a_nombre from opt.personaje1000 where p_nombre like 'Forrest Gump') order by a_nombre;
explain analyze select * from opt.personaje100 where a_nombre in (select a_nombre from opt.personaje100 where p_nombre like 'Forrest Gump') order by a_nombre;

explain analyze select * from opti.personaje10000 where a_nombre in (select a_nombre from opti.personaje10000 where p_nombre like 'Forrest Gump') order by a_nombre;
explain analyze select * from opti.personaje1000 where a_nombre in (select a_nombre from opti.personaje1000 where p_nombre like 'Forrest Gump') order by a_nombre;
explain analyze select * from opti.personaje100 where a_nombre in (select a_nombre from opti.personaje100 where p_nombre like 'Forrest Gump') order by a_nombre;